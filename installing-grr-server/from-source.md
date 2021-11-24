# Installing from source

Here's how to install GRR from source (from github HEAD). This method is useful when you intend to do some development or when you need to build GRR for an architecture not supported by the binary distribution (i.e. arm64 or PowerPC).

For the instructions below, we assume that Ubuntu 18 is used.

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
wget https://go.dev/dl/go1.17.3.linux-amd64.tar.gz
sudo bash -c "rm -rf /usr/local/go && tar -C /usr/local -xzf go1.17.3.l
inux-amd64.tar.gz"
export PATH=$PATH:/usr/local/go/bin
```


## Building Fleetpseak

Fleetspeak is a communication middleware (effectively, a client and a server)
used by GRR to communicate with endpoints. GRR is tightly integrated with
Fleetspeak and expects Fleetspeak binaries to be present in
`fleetspeak-server-bin` and `fleetspeak-client-bin` PIP packages.

Create and activate a Python virtualenv at $HOME/INSTALL:

```bash
python3 -m venv $HOME/INSTALL
source $HOME/INSTALL/bin/activate
pip install --upgrade pip setuptools wheel
```

Next, build `fleetspeak-server-bin` and `fleetspeak-client-bin` Python packages. 
These packages are effectively Python PIP package wrappers around Fleetspeak
binaries.

```bash
# Check out Fleetspeak.
git clone https://github.com/google/fleetspeak.git
# This is needed for Protobuf builds.
pip install grpcio-tools

cd fleetspeak/
pip install -e fleetspeak_python/
./fleetspeak/build.sh 
./fleetspeak/build-pkgs.sh 

python fleetspeak/server-wheel/setup.py bdist_wheel --package-root fleetspeak/server-pkg/debian/fleetspeak-server/ --version __FLEETSPEAK_PIP_VERSION__
pip install dist/fleetspeak_server_bin-__FLEETSPEAK_PIP_VERSION__-py2.py3-none-linux_x86_64.whl

python fleetspeak/client-wheel/setup.py bdist_wheel --package-root fleetspeak/client-pkg/debian/fleetspeak-client/ --version __FLEETSPEAK_PIP_VERSION__
pip install dist/fleetspeak_client_bin-__FLEETSPEAK_PIP_VERSION__-py2.py3-none-linux_x86_64.whl

cd ..
```

Now, when you do `pip freeze`, you should see `fleetspeak-server-bin` and `fleetspeak-client-bin` installed inside the virtualenv:

```bash
$ pip freeze
...
fleetspeak-client-bin @ file:///home/foo/fleetspeak/dist/fleetspeak_client_bin-__FLEETSPEAK_PIP_VERSION__-py2.py3-none-linux_x86_6
4.whl
fleetspeak-server-bin @ file:///home/foo/fleetspeak/dist/fleetspeak_server_bin-__FLEETSPEAK_PIP_VERSION__-py2.py3-none-linux_x86_64.whl
...
```

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

Please check [Installing from a release server deb](./from-release-deb.md) for
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
