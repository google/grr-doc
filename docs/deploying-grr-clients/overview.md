This document describes getting clients up and running for
the first time.

# Getting started

Once we’ve got the GRR server installed and running we’ll
want to start deploying some clients.

To do so we’ll need to:

1.  Download the specific client version we need to install on the
    system.

2.  Decide on a deployment method.

3.  Perform the deployment and verify the results.

# Requirements

  - A number of machines (or VMs) to talk to the server. OSX, Windows and Linux
    clients are supported. Client and server can run on the same host for
    testing purposes.

## Deploying at scale

There shouldn’t be any special considerations for deploying GRR clients
at scale. If the server can’t handle the load, the clients should
happily back off and wait their turn. However, we recommend a staged
rollout if possible.

# Installing the Clients

## Downloading clients

If your server install went successfully, the clients should have been uploaded
to the server with working configurations, and should be available in
the Admin UI.

Look on the left for "Manage Binaries", the files should be in the
executables directory, under installers. The download button is the down
arrown in the toolbar.

The files are also accessible directly if you know the path via
/download. This is useful if you want to retrieve the file using command
line tools or a browser that isn’t supported (e.g.
    IE6).

    wget --user=admin --password=setecastronomy http://example.com:8000/download/windows/installers/grr-installer-3204.exe

If your server configuration has changed your clients will need to be
repacked with an updated config. For details see the server documentation.

Installation steps differ significantly depending on the operating system so we split
it into separate sections below.

Run the client on the target machine as administrator:

  - [Windows instructions](on-windows.md)
  - [OSX instructions](on-mac-os-x.md)
  - [Linux instructions](on-linux.md)

If an install is successful, it should appear in the search UI within a
few seconds.

After install, hit Enter in the search box in the top left corner of the
UI to see all of your clients that have enrolled with the server. If you
don’t see clients, follow the [troubleshooting
steps](troubleshooting.md).

# Uninstalling GRR

A quick manual on how to remove the GRR client completely from a machine is included in the platform-specific docs:

  - [Windows instructions](on-windows.md#uninstalling-grr)
  - [OSX instructions](on-mac-os-x.md#uninstalling-grr)
  - [Linux instructions](on-linux.md#uninstalling-grr)