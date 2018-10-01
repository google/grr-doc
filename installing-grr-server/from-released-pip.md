# Installing from released PIP packages

If the templates included in release server debs are not
compatible with the platform you would like to run them on,
you have the option of installing GRR from PIP on your target platform, then
building your own installers.

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

Next, create a virtualenv and install the GRR server and template packages:

```bash
virtualenv GRR_ENV

source GRR_ENV/bin/activate

pip install grr-response-server grr-response-client

pip install --no-cache-dir -f https://storage.googleapis.com/releases.grr-response.com/index.html grr-response-templates
```

During installation of `grr-response-server`, administrative commands e.g
`grr_console` and `grr_config_updater` will be added to the virtualenv. After
installation, you will need to initialize the GRR configuration with
`grr_config_updater initialize`. Once that is done, you can build a template
for your platform with:

```bash
grr_client_build build --output mytemplates
```

and repack it with:

```bash
grr_client_build repack --template mytemplates/*.zip --output_dir mytemplates
```

If you would like to experiment with the Admin UI or other server components,
you can launch them from within the virtualenv as follows:

```bash
grr_server --component admin_ui --verbose
```

Note that GRR requires Python 2.7+, so for platforms with older default Python
versions (e.g Centos 6), you need to build a newer version of Python from source
and use that for creating the virtualenv.
