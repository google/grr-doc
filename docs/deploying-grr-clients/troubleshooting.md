# Troubleshooting ("I don't see my clients")

## Debugging the client installation

If the installer is failing to run, it should output a log file which
will help you debug. The location of the logfile is configurable, but by
default should be:

  - Windows: %WinDir%\\system32\\logfiles\\GRR\_installer.txt

  - Linux/Mac OSX: /tmp/grr\_installer.txt

Once you have done this, you can download the new binary from the Web
UI. It should have the same configuration, but will output detailed
progress to the console, making it much easier to debug.

Note that the binary is also a zipfile, you can open it in any capable
zip reader. Unfortunately this doesn’t include the built in Windows zip
file handler but does include winzip or 7-zip. Opening the zip is useful
for reading the config or checking that the right dependencies have been
included.

Repacking the Windows client in verbose mode enables console output for
both the installer and for the application itself. It does so by
updating the header of the binary at PE\_HEADER\_OFFSET + 0x5c from
value 2 to 3. This is at 0x144 on 64 bit and 0x134 on 32 bit Windows
binaries. You can do this manually with a hex editor as well.

## Interactively Debugging the Client

On each platform, the client binary should support the following options:
--verbose:: This will set higher logging allowing you to see what is
going on. --debug:: If set, and an unhandled error occurs in the client,
the client will break into a pdb debugging shell.

    C:\Windows\system32>net stop "grr monitor"
    The GRR Monitor service is stopping.
    The GRR Monitor service was stopped successfully.

    C:\Windows\system32>c:\windows\system32\grr\3.2.0.4\grr.exe --config grr.exe.yaml --verbose

## Changing Logging For Debugging

On all platforms, by default only hard errors are logged. A hard error
is defined as anything level ERROR or above, which is generally reserved
for unrecoverable errors. But because temporary disconnections are
normal, an client failing to talk to the server doesn’t actually count as
a hard error.

In the client you will likely want to set:

    Logging.verbose: True

And depending on your configuration, you can play with syslog, log file
and Windows EventLog logging using parameters `Logging.path`, and
`Logging.engines`.


# Proxies and Connectivity

If an client can’t connect to the server, there can be a number of
reasons such as:

  - Server Isn’t Listening
    Confirm you can connect to the server and retrieve the server.pem
    file. E.g.

        wget http://server:8080/server.pem

  - Proxy Required For Access
    If the environment doesn’t allow direct connections GRR may need to
    use a proxy. GRR currently doesn’t support Proxy Autoconfig or Proxy
    Authentication. GRR will attempt to guess your proxy configuration,
    or you can explicitly set proxies in the config file, e.g.

        Client.proxy_servers: ["http://cache.example.com:3128/"]
    On
    Windows systems GRR will try a direct connection, and then search
    for configured proxies in all users profiles on the system trying to
    get a working connection. On Linux GRR should obey system proxy
    settings, and it will also obey environment variables. e.g.

        $ export http_proxy=http://cache.example.com:3128

  - Outbound Firewall Blocking Connections
    GRR doesn’t do anything to bypass egress firewalling by default.
    However, if you have a restrictive policy you could add this as an
    installer plugin.

If you look at the running config, the first time the client
successfully connects to the server a variable
`Client.server_serial_number` will be written to the config. If that
exists, the client successfully made a connection.


# Crashes

The client shouldn’t ever crash…​ but it does because making software is
hard. There are a few ways in which this can happen, all of which we try
and catch, record and make visible to allow for debugging. In the UI
they are visible in two ways, in "Crashes" when a client is selected,
and in "All Client Crashes". These have the same information but the
client view only shows crashes for the specific client.

Each crash should contain the reason for the crash, optionally it may
contain the flow or action that caused the crash. In some cases this
information is not available because the client may have crashed when it
wasn’t doing anything or in a way where we could not tie it to the
action.

This data is also emailed to the email address configured in the config
as `Monitoring.alert_email`

## Crash Types

### Crashed while executing an action

Often seen with an error "Client killed during transaction". This means
that while handling a specific action, the client died, the nanny knows
this because the client recorded the action it was about to take in the
Transaction Log before starting it. When the client restarts it picks up
this log and notifies the server of the crash.

Causes

  - Client segfaults, could happen in native code such as Sleuth Kit or
    psutil.

  - Hard reboot while the machine was running an action where the client
    service didn’t have a chance to exit cleanly.

### Unexpected child process exit\!

This means the client exited, but the nanny didn’t kill it.

Causes

  - Uncaught exception in python, very unlikely due to the fact that we
    catch Exception for all client actions.

### Memory limit exceeded, exiting

This means the client exited due to exceeding the soft memory limit.

Causes

  - Client hits the soft memory limit. Soft memory limit is when the
    client knows it is using too much memory but will continue operation
    until it finishes what it is doing.

### Nanny Message - No heartbeat received

This means that the Nanny killed the client because it didn’t receive a
Heartbeat within the allocated time.

Causes

  - The client has hung, e.g. locked accessing network file

  - The client is performing an action that is taking longer than it
    should.
