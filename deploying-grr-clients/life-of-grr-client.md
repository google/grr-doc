# Life of a GRR client (what happens after deployment)

1. When a new client starts, it notices it doesn't have a public/private key pair.
2. The client generates the keys. A hash of the public key becomes the client's ID. The ID is unique.
3. The client enrolls with the GRR server.
4. The server sees the client ID for the first time & interrogates the new client.

## Client Robustness Mechanisms

We have a number of mechanisms built into the client to try and ensure
it has sensible resource requirements, doesn’t get out of control, and
doesn’t accidentally die. We document them here.

### Heart beat

The client process regularly writes to a registry key (file on Linux and
OSX) with a timer. The nanny process watches this registry key called
HeartBeat, if it notices that the the client hasn’t updated the
heartbeat in the time allocated by UNRESPONSIVE\_KILL\_PERIOD (default 3
minutes), the nanny will assume the client has hung and will kill it. In
Windows we then rely on the Nanny to revive it, on Linux and OSX we rely
on the service handling mechanism to do so.

### Transaction log

When the client is about to start an action it writes to a registry key
containing information about what it is about to do. If the client dies
while performing the action, when the client gets restarted it will send
an error along with the data from the transaction log to help diagnose
the issue.

One tricky thing with the transaction log is the case of Bluescreens or
kernel panics. Writing to the transaction log will write a registry key
on Windows, but registry keys are not flushed to disk immediately.
Therefore, writing a transaction log, and then getting a hard BlueScreen
or kernel panic, the transaction log won’t be persistent, and therefore
the error won’t be sent. We work around this by adding a Flush to the
transaction log when we are about to do dangerous transactions, such as
loading a memory driver. But if the client dies during a transaction we
didn’t deem as dangerous, it is possible that you will not get a crash
report.

### Memory limit

We have a hard and a soft memory limit built into the client to stop it
getting out of control. The hard limit is enforced by the nanny, if the
client goes over that limit it will be hard killed. The soft limit is
enforced by the client, if the limit is exceeded the client will stop
retrieving new work to do. Once it has finished its current work it will
die cleanly.

Default soft limit is 500MB, but GRR should only use about 30MB. Some
volatility plugins can use a lot of memory so we try to be generous.
Hard limit is double the soft limit. This is configurable from the
config file.

### CPU limit

A ClientAction can be transmitted from the server with a specified CPU
limit, this is how many seconds the action can use. If the action uses
more than that it will be killed. The actual implementation is a little
more complicated. An action can run for 3 minutes using any CPU it wants
before being killed by nanny. However actions that are good citizens
(normally the dangerous ones) will call the Progress() function
regularly. This function checks if limit has been exceeded and will
exit.

## Advanced

The GRR client uses HTTP to communicate with the server.

The client connections are controlled via a number of config parameters:

- Client.error_poll_min: Time to wait between retries in an ERROR state.

- Client.server_urls: A list of URLs for the base control server.

- Client.proxy_servers: A list of proxies to try to connect through.

- Client.poll_max, Client.poll_min: Parameters for timing of SLOW POLL and FAST
  POLL modes.

The client goes through a state machine:

1) In the INITIAL state, the client has no active server URL or active proxy and
   it is therefore searching through the list of proxies and connection URLs for
   one that works. The client will try each combination of proxy/URL in turn
   without delay until a 200 or a 406 message is seen. If all possibilities are
   exhausted, and a connection is not established, the client will switch to
   SLOW POLL mode (and retry connection every Client.poll_max).

2) In SLOW POLL mode the client will wait Client.poll_max between re-connection
   attempts.

3) If a server is detected, the client will communicate with it. If the server
   returns a 406 error, the client will send an enrollment request. Enrollment
   requests are only re-sent every 10 minutes (regardless of the frequency of
   406 responses). Note that a 406 message is considered a valid connection and
   the client will not search for URL/Proxy combinations as long as it keep
   receiving 406 responses.

4) During CONNECTED state, the client has a valid server certificate, receives
   200 responses from the server and is able to send messages to the server. The
   polling frequency in this state is determined by the polling mode requested
   by the messages received or send. If any message from the server or from the
   worker queue (to the server) has the require_fastpoll flag set, the client
   switches into FAST POLL mode.

5) When not in FAST POLL mode, the polling frequency is controlled by the
   Timer() object. It is currently a geometrically decreasing function which
   starts at the Client.poll_min and approaches the Client.poll_max setting.

6) If a 500 error occurs in the CONNECTED state, the client will assume that the
   server is temporarily down. The client will switch to the RETRY state and
   retry sending the data with a fixed frequency determined by
   Client.error_poll_min to the same URL/Proxy combination. The client will
   retry for retry_error_limit times before exiting the
   CONNECTED state and returning to the INITIAL state (i.e. the client will
   start searching for a new URL/Proxy combination). If a retry is successful,
   the client will return to its designated polling frequency.

7) If there are connection_error_limit failures, the client will
   exit. Hopefully the nanny will restart the client.

Examples:

1) Client starts up on a disconnected network: Client will try every URL/Proxy
   combination once every Client.poll_max (default 10 minutes).

2) Client connects successful but loses network connectivity. Client will re-try
   retry_error_limit (10 times) every Client.error_poll_min (1 Min) to
   resent the last message. If it does not succeed it starts searching for a new
   URL/Proxy combination as in example 1.

See [comms.py](https://github.com/google/grr/blob/master/grr/client/grr_response_client/comms.py)
for the client implementation.
