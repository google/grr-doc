# Setting Up a Development Environment

> **NOTE:** This article describes setting up GRR development environment on Ubuntu 18 (Xenial) or Debian 10 (buster). Most of the instructions below are applicable to other Linux distributions as well as to Mac OS X, although some details may differ from platform to platform.

## Step 1. Checkout GRR sources.

Navigate to the root GRR directory (or clone the repository if you have not done
it yet):

```bash
git clone https://github.com/google/grr
cd grr/
```

## Step 2. Set up Virtual Python environment.

Make sure that you have `venv` installed. It should be available in
repositories of all popular Linux distributions. For example, to install it on
Ubuntu-based distros, run:

```bash
sudo apt install python3-venv
```

To create a virtual environment you execute the `python3 venv $DIR` command
where `$DIR` is the directory where you want it to be placed. The rest of the
manual will assume that the environment is created in `~/grr_venv` like
this:

```bash
python3 -m venv ~/grr_venv
```

After creating the environment you have to activate it:

```bash
source ~/grr_venv/bin/activate
```

It is also advised to make sure that we are running a recent version of `pip` and have latest versions of a few related packages:

```bash
pip install --upgrade pip wheel setuptools six
```

For more information about creating and managing your virtual environments
refer to the [`venv` documentation](https://docs.python.org/3.9/library/venv.html).

## Step 3. Set up Node.js environment.

Because GRR offers a user interface component it also needs some JavaScript code
to be built with Node.js. Fortunately, this can be done with `pip` inside our
virtual environment so that your system remains uncluttered.

To install Node.js, execute:

```bash
pip install nodeenv
nodeenv -p --prebuilt --node=12.14.1
```

Because the `nodeenv` command modifies our virtual environment, we also need to
reinitialize it with:

```bash
source ~/grr_venv/bin/activate
```

## Step 4. Install GRR dependencies.

GRR depends on a few libraries that have to be installed on a system. Run this command to ensure you have them:

```bash
sudo apt-get install libssl-dev python3-dev python-pip wget openjdk-8-jdk zip dh-systemd libmysqlclient-dev
```

> Depending on the distribution, the set of packages providing these functionalities can be a bit different—please, refer to your distribution package repository. Useful replacement suggestions are also often provided by package managers themselves.

## Step 5. Install GRR packages.

GRR is split into multiple packages. For the development we recommend installing
all components. Assuming that you are in the root GRR directory run the
following commands:

> **NOTE**: order of the commands is important. Running these commands in wrong order will lead to PIP  fetching prebuilt GRR packages from PyPi. In such case, editing code in checked out GRR repository won't have any effect.

```bash
pip install -e ./grr/proto && \
pip install -e ./grr/core && \
pip install -e ./grr/client && \
pip install -e ./api_client/python && \
pip install -e ./grr/client_builder && \
pip install -e ./grr/server/[mysqldatastore] && \
pip install -e ./colab && \
pip install -e ./grr/test
```

The `-e` (or `--editable`) flag passed to `pip` makes sure that the packages
are installed in a "development" mode and any changes you make in your working
directory are directly reflected in your virtual environment, no reinstalling
is required.

> If running `pip install -e ./grr/server/[mysqldatastore]` results in the following error: `OSError: mysql_config not found`, it means that the MySQL/MariaDB installation from Step 4 was incorrect. Make sure you are using the correct package, for example `libmariadbclient-dev-compat` instead of `libmariadb-dev`.

> If running `pip install -e ./grr/server/[mysqldatastore]` results in an error caused by `mysqlclient` such as `_mysql.c:1911:41: error: 'MYSQL' has no member named 'reconnect'`, try ommitting `[mysqldatastore]` and installing it manually with `pip install mysqlclient`.

## Step 6. Install prebuilt GRR client templates.

If you want to repack GRR clients, you'll need a prebuilt GRR client templates package with templates for Linux/Mac/Windows. This should be installed using the following command:

```bash
pip install --no-cache-dir -f https://storage.googleapis.com/releases.grr-response.com/index.html grr-response-templates
```

## Step 7: Install MySQL

The GRR server components need to connect to a running MySQL instance in order
to run:

```bash
apt install -y mysql-server
```

## Step 8. Initialize GRR.

To initialize the development GRR setup, run:

```bash
grr_config_updater initialize
```

## Step 9. Run GRR components.

You can use one of the commands below to run specific GRR server components.

Fleetspeak server: `fleetspeak_server`

Admin UI: `grr_admin_ui`

Frontend: `grr_frontend`

Worker: `grr_worker`

You can also run a local GRR client by executing `fleetspeak_client` command.

Adding `--verbose` flag to any of these commands would force GRR components to output debug information to stderr.

## Testing

Now you are ready to start the GRR development. To make sure that everything is
set-up correctly follow the [testing guide](running-tests.md).
