Installing from source
========================

This guide will walk you through the process of installing GRR from sources and
making it communicate through Fleetspeak, rather than its old custom
communication protocol.

At the end you should have a working single-machine setup with both the server
and the client communicating with each other. Follow other documentation pages
to learn how to adapt this setup to real deployments.

Installation
------------

### System

Because we are going to install everything from sources, there are some
dependencies required to be installed on your system first.

Since GRR is written in Python, the fundamental requirement is to have it
available on your system. GRR needs at least Python 3.6. On recent Debian-based
distros it should be enough to install the `python3-dev` package:

    $ sudo apt install python3-dev

Moreover, both GRR and Fleetspeak use MySQL (or MariaDB) as its RDBMS, so make
sure it is also installed. The package that GRR uses to communicate with MySQL
depends on the MySQL client library, so you should set it up as well. On Debian
distros it is `libmysqlclient-dev` or `libmariadbclient-dev`:

    $ sudo apt install libmysqlclient-dev

Finally, GRR uses [Closure Compiler][closure] to process its JavaScript files.
While installing Closure Compiler is handled for you in one of the build
scripts, it requires a Java Runtime Environment to run. [OpenJDK][openjdk]
should work just fine, so on Debian distros it is enough to install it like:

    $ sudo apt install openjdk-13-jre

[closure]: https://developers.google.com/closure/compiler
[openjdk]: http://openjdk.java.net/

### Fleetspeak

Install [Fleetspeak][fleetspeak] and follow the [guide][fleetspeak-guide] to
learn how to configure services and run the Fleetspeak server and the Fleetspeak
client.

[fleetspeak]: https://github.com/google/fleetspeak
[fleetspeak-guide]: https://github.com/google/fleetspeak/blob/master/docs/guide.md

### GRR

Use Git to clone the GRR repository to your workstation and enter into it:

    $ git clone https://github.com/google/grr
    $ cd grr/

For the rest of the guide we will assume that the working directory is the root
GRR folder, placed in your home folder (`/home/username/grr`), so remember to
adapt to your specific setup.

To avoid cluttering the filesystem, we will also use Python's virtual
environment:

    $ python3 -m venv venv

Before proceeding with installing GRR packages themselves, you also need to
install `grpcio-tools` and `protobuf` packages (for compiling Protocol Buffers
files) and `nodeenv` (for compiling JavaScript files):

```bash
$ venv/bin/pip install grpcio-tools protobuf nodeenv
$ venv/bin/nodeenv -p --prebuilt --node=12.16.1
```

Once your virtual environment is ready, install all the required GRR Python
packages:

    $ source venv/bin/activate
    (venv) $ pip install -e grr/proto/
    (venv) $ pip install -e grr/core/
    (venv) $ pip install -e grr/client/
    (venv) $ pip install -e grr/client_builder/
    (venv) $ pip install -e api_client/python/
    (venv) $ pip install -e grr/server/[mysqldatastore]
    (venv) $ deactivate

If you encounter any problems related to `mysqlclient` during the installation of `grr/server` when using MariaDB, then try the following:

    (venv) $ pip install mysqlclient
    (venv) $ pip install -e grr/server/
    (venv) $ deactivate

Configuration
-------------

### MySQL / MariaDB

We need to create a GRR database along with an associated user. In this guide
the database will be named `grr`, the user will be named `grr-user` and will
be identified by password `grr-password`. We also need to increase the max
allowed packet size to 40 MiB.

Fire up the MySQL console as an administrative user, e.g.:

    $ mysql --user root

Then, use the following commands:

    mysql> CREATE USER `grr-user` IDENTIFIED BY 'grr-password';
    mysql> CREATE DATABASE `grr`;
    mysql> GRANT ALL PRIVILEGES ON `grr`.* TO `grr-user`;
    mysql> SET GLOBAL max_allowed_packet = 40 * 1024 * 1024;

### GRR

Now you should initialize the GRR configuration. GRR comes with a tool for this
and handles most of the things for you:

    $ venv/bin/grr_config_updater initialize

Use the MySQL credentials that you configured previously. It should be fine to
keep the rest of the things at the default values (but skip client repacking).

Now you need to configure GRR to work with Fleetspeak. Pick an unused port, e.g.
`1138` on which your GRR service will run.

Add the following lines to the GRR config file in
`grr/core/install_data/etc/server.local.yaml` (where `localhost:1138` uses the
port you picked and `localhost:9091` is the address your Fleetspeak admin server
binds to):

```yaml
Client.fleetspeak_enabled: true
Server.fleetspeak_message_listen_address: "localhost:1138"
Server.fleetspeak_server: "localhost:9091"
```

### Fleetspeak

#### Server

Add the following definition to your Fleetspeak server-side service
configuration file (using appropriate port you chose for GRR):

```
services {
  name: "GRR"
  factory: "GRPC"
  config: {
    [type.googleapis.com/fleetspeak.grpcservice.Config] {
      target: "localhost:1138"
      insecure: true
    }
  }
}
```

#### Client

Define a new service text file with the following contents:

```
name: "GRR"
factory: "Daemon"
config: {
  [type.googleapis.com/fleetspeak.daemonservice.Config]: {
    argv: "/home/username/grr/venv/bin/python"
    argv: "-m"
    argv: "grr_response_client.grr_fs_client"
  }
}
```

Running
-------

Start the Fleetspeak server and all the GRR components in separate terminals:

    $ venv/bin/python -m grr_response_server.gui.admin_ui

    $ venv/bin/python -m grr_response_server.bin.worker

    $ venv/bin/python -m grr_response_server.bin.fleetspeak_frontend

Finally, start the Fleetspeak client. After a moment, it should successfully
register with GRR and you should be able to see it in the GRR UI. In your web
browser, using appropriate client identifier, navigate to:

    http://localhost:8000/#/clients/C.<your_fleetspeak_client_id>/host-info

You should see a page with details about your client. GRR should automatically
schedule initial interrogation flow, which should complete within couple of
minutes. You can also try some simpler flows, for example listing all processes
(`ListProcesses` in *Processes* category), to verify that everything works as
expected.
