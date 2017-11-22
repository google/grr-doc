# On Windows

The Windows agents are special self extracting zipfiles. Just double
click or otherwise execute the binary. If you are not an administrator
it will prompt you for credentials. It should then install silently in
the background, unless you enabled the verbose
build.

## Windows deployment

The most straightforward way to deploy a GRR agent to a Windows machine
is to use
[PsExec](http://technet.microsoft.com/en-us/sysinternals/bb897553.aspx).
PsExec allows one to execute commands on a remote system if credentials
for a valid user are known.

To do so, start by downloading psexec and placing in a directory of your
choice, we’ll call it AGENT\_DIRECTORY here. Store the version of the
agent you want to download to the same directory.

Once you have both, you have to make sure you know the username and
password of an Administrator user in the remote system. Once all these
requirements are met, just start a cmd.exe shell and type:

    cd C:\AGENT_DIRECTORY\
    net use \\MACHINE\IPC$ /USER:USERNAME *
    psexec \\MACHINE -c -f -s agent-version.exe

> **Note**
>
> The NET USE command will ask for a password interactively, so it’s not
> suited for using in scripts. You could Switch the *\** for the
> PASSWORD instead if you want to include it in a script.

You’ll need to replace:

  - C:\\AGENT\_DIRECTORY\\ with the full path you chose.

  - MACHINE with the name of the target system.

  - USERNAME with the user with administrative privileges on the target
    system.

This will copy the agent-version.exe executable on the target system and
execute it. The installation doesn’t require user input.

The expected output is something along these lines:

    C:\> cd C:\AGENT_DIRECTORY\
    C:\> net use \\127.0.0.1\IPC$ /USER:admin *
    Type the password for \\127.0.0.1\IPC$:
    The command completed successfully

    C:\AGENT_DIRECTORY> psexec \\127.0.0.1 -c -f -s agent.exe
    PsExec v1.98 - Execute processes remotely
    Copyright (C) 2001-2010 Mark Russinovich
    Sysinternals - www.sysinternals.com

    The command completed successfully.

    agent.exe exited on 127.0.0.1 with error code 0.

    C:\AGENT_DIRECTORY>

For even less footprint on installation you could host the agent on a
shared folder on the network and use this psexec command instead:

    cd C:\AGENT_DIRECTORY\
    net use \\MACHINE\IPC$ /USER:USERNAME *
    psexec \\MACHINE -s \\SHARE\FOLDER\agent-version.exe

This requires the USERNAME on the remote MACHINE be able to log into
SHARE and access the shared folder FOLDER. You can do this either by
explicitly allowing the user USERNAME on that share or by using an
Anonymous share.

The best way to verify whether the whole installation process has worked
is to search for the client in the GUI.