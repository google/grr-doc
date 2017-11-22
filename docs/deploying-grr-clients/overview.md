This document describes getting clients up and running for
the first time.

# Requirements

  - A number of machines (or VMs) to talk to the server. OSX, Windows and Linux
    clients are supported. Client and server can run on the same host for
    testing purposes.

## Deploying at scale

There shouldn’t be any special considerations for deploying GRR clients
at scale. If the server can’t handle the load, the clients should
happily back off and wait their turn. However, we recommend a staged
rollout if possible.

# Install the Clients

The pre-packaged clients should be visible in the GRR web UI (see the "Installing GRR Server" section of the docs for instructions on running the web UI) under Manage
Binaries → executables → Windows → installers. Download the client you
need.

Run the client on the target machine as administrator:

  - [Windows instructions](on-windows.md)
  - [OSX instructions](on-mac-os-x.md)
  - [Linux instructions](on-linux.md)

After install, hit Enter in the search box in the top left corner of the
UI to see all of your clients that have enrolled with the server. If you
don’t see clients, follow the [troubleshooting
steps](troubleshooting.md).

# Uninstalling GRR

A quick manual on how to remove the GRR client completely from a machine is included in the platform-specific docs:

  - [Windows instructions](on-windows.md#uninstalling-grr)
  - [OSX instructions](on-mac-os-x.md#uninstalling-grr)
  - [Linux instructions](on-linux.md#uninstalling-grr)