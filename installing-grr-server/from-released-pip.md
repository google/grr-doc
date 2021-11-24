# Installing from released PIP packages

If the templates included in release server debs are not
compatible with the platform you would like to run them on,
you have the option of installing GRR from PIP on your target platform, then
building your own.

First, install the prerequisites:

* Ubuntu:

```bash
apt install -y debhelper dpkg-dev python-dev python-pip rpm zip
```

* Centos:

```bash
yum install -y epel-release python-devel wget which libffi-devel \
  openssl-devel zip git gcc gcc-c++ redhat-rpm-config

yum install -y python-pip
```

Next, upgrade pip and install virtualenv:

```bash
sudo pip install --upgrade pip virtualenv
```

Next, create a virtualenv and install the GRR client-builder package:

```bash
virtualenv GRR_ENV

source GRR_ENV/bin/activate

pip install grr-response-client-builder
```

Once that is done, you can build a template for your platform with:

```bash
grr_client_build build --output mytemplates
```

and repack it with:

```bash
grr_client_build repack --template mytemplates/*.zip --output_dir mytemplates
```

If you would like to experiment with GRR's server components, you will need
to first install the `grr-response-server` pip package. Administrative
commands such as as `grr_server` and `grr_config_updater` will be added to
the virtualenv. You can then launch the server components as follows:

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

Note that GRR requires Python 3.6+, so for platforms with older default Python
versions (e.g Centos 6), you need to build a newer version of Python from source
and use that for creating the virtualenv.
