# Installing from source

Here's how to install GRR from source (from github HEAD). This method is useful when you intend to do some development or when you cannot or don't want to run Docker or install from pip packages.

For the instructions below, we assume that Ubuntu 22 is used.

## Prerequisites

First, install the prerequisites:

```bash
sudo apt-get update
sudo apt install -y fakeroot debhelper libffi-dev libssl-dev python3-dev \
  python3-pip python3-venv wget openjdk-8-jdk zip git devscripts dh-systemd \
  dh-virtualenv libc6-i386 lib32z1 asciidoc libmysqlclient-dev
  
# Go (version 1.13 or newer) is needed to build Fleetspeak. If you already
# have Go installed on your system, you can skip this part.
# We use amd64 version here, you might need to download another Go
# distribution matching your architecture (see https://go.dev/dl/).
wget https://go.dev/dl/go1.22.2.linux-amd64.tar.gz
sudo bash -c "rm -rf /usr/local/go && tar -C /usr/local -xzf go1.22.2.linux-amd64.tar.gz"
export PATH=$PATH:/usr/local/go/bin
```


## Fleetpseak

[Fleetspeak][fleetspeak] is a communication middleware (effectively, a client and a server)
used by GRR to communicate with endpoints.

Follow the [guide][fleetspeak-guide] on how to install, configure services and run the Fleetspeak server.

[fleetspeak]: https://github.com/google/fleetspeak
[fleetspeak-guide]: https://github.com/google/fleetspeak/blob/master/docs/guide.md
Create and activate a Python virtualenv at $HOME/INSTALL:


## Building GRR

Next, you need to build GRR. Download the GitHub repo and cd into its directory:

```bash
git clone https://github.com/google/grr.git
cd grr
```

### If your goal is development

Run the following script to install GRR into the virtualenv:

```bash
./travis/install.sh
```

Please check [Setting up your own MySQL database](installing-and-running-grr/via-docker-compose.html#setting-up-your-own-mysql-database) for
instructions on how to configure MySQL server.

You should now be able to run GRR commands from inside the virtualenv,
particularly, you can trigger GRR server configuration.

```bash
source $HOME/INSTALL/bin/activate
grr_config_updater initialize  # Initialize GRR's configuration
```

Then, to run individual GRR components (for a Fleetspeak-enabled configuration):

```bash
# To run fleetspeak server.
grr_server --component fleetspeak_server --verbose
# To run AdminUI.
grr_server --component admin_ui --verbose
# To run the worker.
grr_server --component worker --verbose
# To run the frontend.
grr_server --component frontend --verbose
```

### If your goal is to build a custom GRR client template

In this case you don't need a full blown GRR server setup. Run the following:

```bash
./travis/install_client_builder.sh
```

This will install necessary PIP packages into your virtualenv to run the
`grr_client_build` command. See
[Building custom client templates](../maintaining-and-tuning/building-custom-client-templates.md)
for how to use it.
