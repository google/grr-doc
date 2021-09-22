***Note on the AFF4 datastore deprecation***

*Starting from the version ***3.3.0.0*** GRR uses a new datastore format by default - ***REL_DB***. REL_DB is backwards-incompatible with the now-deprecated AFF4 datastore format (even though they both use MySQL as a backend).*

*Use of AFF4-based deployments is now discouraged. REL_DB is expected to be much more stable and performant. Please see [these docs](../maintaining-and-tuning/grr-datastore.md) if you're upgrading an older GRR version and would like to try out the new datastore.*

# Installing from source

Here's how to install GRR for development (from github HEAD):

First, install the prerequisites:

* Ubuntu:

```bash
sudo apt install -y fakeroot debhelper libffi-dev libssl-dev python-dev \
  python-pip wget openjdk-8-jdk zip git devscripts dh-systemd dh-virtualenv \
  libc6-i386 lib32z1 asciidoc libmysqlclient-dev
```

* Centos:

```bash
sudo yum install -y epel-release python-devel wget which java-1.8.0-openjdk \
  libffi-devel openssl-devel zip git gcc gcc-c++ redhat-rpm-config rpm-build \
  rpm-sign

sudo yum install -y python-pip
```

Next, upgrade pip and install virtualenv:

```bash
sudo pip install --upgrade pip virtualenv
```

Next, download the github repo and cd into its directory:

```bash
git clone https://github.com/google/grr.git

cd grr
```

Finally, create a virtualenv at $HOME/INSTALL and install GRR in the virtualenv:

```bash
virtualenv $HOME/INSTALL

travis/install.sh
```

You should now be able to run GRR commands from inside the virtualenv, e.g:

```bash
source $HOME/INSTALL/bin/activate

grr_config_updater initialize  # Initialize GRR's configuration

```

# Installing Python 3 GRR version from source

***Note on the Python 3 support in GRR***

*By now GRR codebase should be fully Python 3 compatible: unit and end-to-end tests are passing in a properly setup Python 3 GRR environment. However, the first Python 3 GRR release is expected in Dec. 2019. Until that's done, Python 3 support should be treated as experimental: unforeseen packaging issues not covered by our tests are possible.*

Here's how to install GRR for Python 3 development (from github HEAD, on Ubuntu Xenial):

First, install the prerequisites:

```bash
sudo apt install -y fakeroot debhelper libffi-dev libssl-dev python3-dev \
  python3-pip python3-venv wget openjdk-8-jdk zip git devscripts dh-systemd \
  dh-virtualenv libc6-i386 lib32z1 asciidoc libmysqlclient-dev
```

Next, download the github repo and cd into its directory:

```bash
git clone https://github.com/google/grr.git

cd grr
```

Next, create a virtualenv at $HOME/INSTALL:

```bash
python3 -m venv $HOME/INSTALL
```

Next, pre-install Python 3-compatible chipsec version into the virtualenv. Note that this will install chipsec Python code only, no driver will be built, meaning that Chipsec won't be function on GRR clients (this should be fixed soon).

```bash
source $HOME/INSTALL/bin/activate

pip install https://github.com/chipsec/chipsec/archive/python3-beta.zip --install-option="--skip-driver"
```

Finally, install GRR in the virtualenv:

```bash
travis/install.sh
```

You should now be able to run GRR commands from inside the virtualenv, e.g:

```bash
source $HOME/INSTALL/bin/activate

grr_config_updater initialize  # Initialize GRR's configuration

```

