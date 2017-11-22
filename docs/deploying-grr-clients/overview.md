This document describes getting clients up and running for
the first time.

# Requirements

  - A number of machines (or VMs) to talk to the server. OSX, Windows and Linux
    agents are supported. Client and server can run on the same host for
    testing purposes.

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
steps](troubleshooting.md#i-dont-see-my-clients).