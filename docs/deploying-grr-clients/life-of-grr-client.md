# Life of a GRR client (what happens after deployment)

## Client and Server Version Compatibility and Numbering

We try hard to avoid breaking backwards compatibility for clients since
upgrading can be painful, but occasionally we need to make changes that
require a new client version to work. As a general rule you want to
upgrade the server first, then upgrade the clients fairly soon after.

Matching major/minor versions of client and server should work well
together. i.e. Clients 3.1.0.0 and 3.1.6.2 should work well with servers
3.1.0.0 and 3.1.9.7 because they are all 3.1 series. We introduced this
approach for the 3.1.0.0 release.

For older servers and clients, matching the last digit provided similar
guarantees. i.e. client 3.0.0.7 was released with server 0.3.0-7 and
should work well together.


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