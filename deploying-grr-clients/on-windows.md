# Installing GRR clients on Windows

## MSI installer

Since version 3.4.5.1, GRR provides a new MSI based installer for the client on
Windows.

The client can be installed either by double-clicking the installer or by using
the
[`msiexec`](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/msiexec)
command.

The client can be removed via the "Apps and features" setting in the control
panel or by using `msiexec`.

## Legacy self-extracting .exe installer

For Windows you will see a 64 bit installer. Run the installer as admin (it
should load the UAC prompt if you are not admin). It should run silently and
install the client to `c:\windows\system32\grr\%version%\`. It will also
install a Windows Service, start it, and configure the registry keys to make it
talk to the URL/server you specified during repack of the clients on the
server.

The Windows clients are special self extracting zipfiles. Just double
click or otherwise execute the binary. If you are not an administrator
it will prompt you for credentials. It should then install silently in
the background, unless you enabled the verbose
build.

The most straightforward way to deploy a GRR client to a Windows machine
is to use
[PsExec](http://technet.microsoft.com/en-us/sysinternals/bb897553.aspx).
PsExec allows one to execute commands on a remote system if credentials
for a valid user are known.

To do so, start by downloading psexec and placing in a directory of your
choice, we’ll call it CLIENT\_DIRECTORY here. Store the version of the
client you want to download to the same directory.

Once you have both, you have to make sure you know the username and
password of an Administrator user in the remote system. Once all these
requirements are met, just start a cmd.exe shell and type:

```docker
cd C:\CLIENT_DIRECTORY\
net use \\MACHINE\IPC$ /USER:USERNAME *
psexec \\MACHINE -c -f -s client-version.exe
```

**Note**: The `NET USE` command will ask for a password interactively,
so it’s not suited for using in scripts. You could Switch the `*` for
the PASSWORD instead if you want to include it in a script.

You’ll need to replace:

  - C:\\CLIENT\_DIRECTORY\\ with the full path you chose.

  - MACHINE with the name of the target system.

  - USERNAME with the user with administrative privileges on the target
    system.

This will copy the client-version.exe executable on the target system and
execute it. The installation doesn’t require user input.

The expected output is something along these lines:

```docker
C:\> cd C:\CLIENT_DIRECTORY\
C:\> net use \\127.0.0.1\IPC$ /USER:admin *
Type the password for \\127.0.0.1\IPC$:
The command completed successfully

C:\CLIENT_DIRECTORY> psexec \\127.0.0.1 -c -f -s client.exe
PsExec v1.98 - Execute processes remotely
Copyright (C) 2001-2010 Mark Russinovich
Sysinternals - www.sysinternals.com

The command completed successfully.

client.exe exited on 127.0.0.1 with error code 0.

C:\CLIENT_DIRECTORY>
```

For even less footprint on installation you could host the client on a
shared folder on the network and use this psexec command instead:

```docker
cd C:\CLIENT_DIRECTORY\
net use \\MACHINE\IPC$ /USER:USERNAME *
psexec \\MACHINE -s \\SHARE\FOLDER\client-version.exe
```

This requires the USERNAME on the remote MACHINE be able to log into
SHARE and access the shared folder FOLDER. You can do this either by
explicitly allowing the user USERNAME on that share or by using an
Anonymous share.

The best way to verify whether the whole installation process has worked
is to search for the client in the GUI.

### Uninstalling
On Windows the client does not have a standard uninstaller. It is
designed to have minimal impact on the system and leave limited traces
of itself such that it can be hidden reasonably easily. Thus it was
designed to install silently without an uninstall.

Disabling the service can be done with the Uninstall GRR flow, but this does
not clean up after itself by default.

Cleaning up the client is a matter of deleting the service and the
install directory, then optionally removing the registry keys and
install log if one was created.

On Windows, GRR lives in

```docker
%SystemRoot%\system32\grr\*
```

The service can be stopped with

```docker
sc stop "grr monitor"
```

Or via the task manager.

The GRR config lives in the registry, for a full cleanup, the path

```docker
HKEY_LOCAL_MACHINE\Software\GRR
```

should be deleted.

Removing the GRR client completely from a machine:

```docker
sc stop "grr monitor"
sc delete "grr monitor"
reg delete HKLM\Software\GRR
rmdir /Q /S c:\windows\system32\grr
del /F c:\windows\system32\grr_installer.txt
```
