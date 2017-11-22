# Troubleshooting ("I don't see my clients")

## Debugging the Agent Install

If the installer is failing to run, it should output a log file which
will help you debug. The location of the logfile is configurable, but by
default should be:

  - Windows: %WinDir%\\system32\\logfiles\\GRR\_installer.txt

  - Linux/Mac OSX: /tmp/grr\_installer.txt

To make debugging easier, we also support repacking the client with
verbosity enabled. This is particularly handy on Windows. To repack with
this enabled, on the server you can
    do:

    db@host:~ sudo grr_config_updater --verbose -p ClientBuilder.console=True
    repack_clients

Alternatively, you can set ClientBuilder.console: False inside your
server config file to have this setting always applied.

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

On each platform, the agent binary should support the following options:
--verbose:: This will set higher logging allowing you to see what is
going on. --debug:: If set, and an unhandled error occurs in the client,
the client will break into a pdb debugging shell.

    C:\Windows\system32>net stop "grr monitor"
    The GRR Monitor service is stopping.
    The GRR Monitor service was stopped successfully.

    C:\Windows\system32>c:\windows\system32\grr\2.5.0.5\grr.exe --config grr.exe.yaml --verbose

    test@test0:~$ sudo service grr-single-server stop
    [sudo] password for test:
    grr-single-server stop/waiting
    test@test0:~$ sudo /usr/sbin/grrd --config=/usr/lib/grr/grr_2.9.1.1_amd64/grr.yaml --verbose
    INFO:2013-10-02 14:32:07,756 logging:1611] Starting GRR Prelogging buffer.
    INFO:2013-10-02 14:32:07,791 logging:1611] Loading configuration from /usr/lib/grr/grr_2.9.1.1_amd64/grr.yaml

## Configuration Changes to Ease Debugging

If you are finding that it is slow to debug because the agent starts
backed off to 10 minutes and you have to wait, you should change the
configuration. In windows, set the registry key poll\_max to 10, then
restart the service. You can do this with regedit or via the Windows
command
    line:

    C:\Windows\system32>reg add HKLM\Software\GRR /v Client.poll_max /d 10
    The operation completed successfully.

    C:\Windows\system32>net stop "grr monitor"
    The GRR Monitor service is stopping.
    The GRR Monitor service was stopped successfully.

    C:\Windows\system32>net start "grr monitor"
    The GRR Monitor service is starting.
    The GRR Monitor service was started successfully.

## Changing Logging For Debugging

On all platforms, by default only hard errors are logged. A hard error
is defined as anything level ERROR or above, which is generally reserved
for unrecoverable errors. But because temporary disconnections are
normal, an agent failing to talk to the server doesn’t actually count as
a hard error.

In the client you will likely want to set: Logging.verbose: True

And depending on your configuration, you can play with syslog, log file
and Windows EventLog logging using parameters Logging.path, and
Logging.engines.