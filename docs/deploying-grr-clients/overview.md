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

  - For Windows you will see a 32 and 64 bit installer. Run the
    installer as admin (it should load the UAC prompt if you are not
    admin). It should run silently and install the client to
    `c:\windows\system32\grr\%version%\`. It will also install a Windows
    Service, start it, and configure the registry keys to make it talk
    to the URL/server you specified during repack of the clients on the
    server.

  - For OSX you will see a pkg file, install the pkg. It will add a
    launchd item and start it.

  - For Linux you will see a deb and rpms, install the appropriate one.
    For testing purposes you can run the client on the same machine as
    the server if you like.

After install, hit Enter in the search box in the top left corner of the
UI to see all of your clients that have enrolled with the server. If you
don’t see clients, follow the [troubleshooting
steps](troubleshooting.md#i-dont-see-my-clients).