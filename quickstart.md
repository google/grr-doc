# Quickstart (have GRR running in 5 minutes)

This page describes how to get GRR clients and server components up and
running for the first time. If you have Docker installed, and just want to
experiment with a container that already has GRR set up, you can follow
the instructions given [here](installing-grr-server/via-docker.md). It takes
~2 minutes to download the image and initialize the server.

To start, install the GRR server deb as described
[here](installing-grr-server/from-release-deb.md).

On successful installation, you should have an admin interface running on port
8000 by default. Open the Admin UI in a browser, navigate to
Binaries -> Executables
(details [here](deploying-grr-clients/overview.md)) and download the installer
you need.

Next, run the client installer on the target machine (can be the same machine
as the one running the GRR server components) as root:

* For Windows you will see a 64 bit installer. Run the installer as
admin (it should load the UAC prompt if you are not admin). It should run
silently and install the client to `c:\windows\system32\grr\%version%\`. It
will also install a Windows Service, start it, and configure the registry keys
to make it talk to the URL/server you specified during repack of the clients on
the server.

* For OSX you will see a pkg file, install the pkg. It will add a launchd item
and start it.

* For Linux you will see a deb and rpms, install the appropriate one. For
testing purposes you can run the client on the same machine as the server if
you like.

After install, hit Enter in the search box in the top left corner of the UI to
see all of your clients that have enrolled with the server. If you don’t see
clients, follow the
[troubleshooting steps](deploying-grr-clients/troubleshooting.md).
