# Setting Up a Development Environment

> **NOTE:** This article describes setting up GRR development environment on Windows 11.

## Step 1. Checkout GRR sources.

Navigate to the root GRR directory (or clone the repository if you have not done
it yet):

```powershell
git clone https://github.com/google/grr
cd grr/
```

## Step 2. Set up Virtual Python environment.

Install required packages (ex. in admin powershell)
```powershell
choco install python --version=3.8.0 openjdk protoc
```
Install MSVC see https://visualstudio.microsoft.com/visual-cpp-build-tools/
Here i used the following entries found under the "Desktop Development with C++"
- MSVC v143 - VS 2022 C++ build tools
- Windows 10 SDK 10.0.19041.0
- C++ CMake tools for Windows
- Testing tools core features - Build Tools
- C++ AddressSanitizer

To create a virtual environment you execute the `python -m venv $DIR` command
where `$DIR` is the directory where you want it to be placed. The rest of the
manual will assume that the environment is created in `~/grr_venv` like
this:

```powershell
python -m venv ./grr_venv
```

After creating the environment you have to activate it:

```powershell
./grr_venv/Scripts/activate
```

It is also advised to make sure that we are running a recent version of `pip` and have latest versions of a few related packages:

```powershell
pip install --upgrade pip wheel setuptools six
```

For more information about creating and managing your virtual environments
refer to the [`venv` documentation](https://docs.python.org/3.9/library/venv.html).

Also potentially see [this windows/python compiler guide](https://wiki.python.org/moin/WindowsCompilers) for more info. 

## Step 3. Set up Node.js environment.

Because GRR offers a user interface component it also needs some JavaScript code
to be built with Node.js. Fortunately, this can be done with `pip` inside our
virtual environment so that your system remains uncluttered.

To install Node.js, execute:

```powershell
pip install nodeenv
nodeenv -p --prebuilt --node=14.19.1 
```

Because the `nodeenv` command modifies our virtual environment, we also need to
reinitialize it with:

```bash
./grr_venv/Scripts/activate
```

## Step 4. Install GRR dependencies.

GRR depends on a few libraries that have to be installed on a system. Run this command to ensure you have them:

>To be honest this could use a bit more research on my part. Most of this is done in step 1.

## Step 5. Install GRR packages.

GRR is split into multiple packages. For the development we recommend installing
all components. Assuming that you are in the root GRR directory run the
following commands:

> **NOTE**: order of the commands is important. Running these commands in wrong order will lead to PIP  fetching prebuilt GRR packages from PyPi. In such case, editing code in checked out GRR repository won't have any effect.

```powershell
pip install -e ./grr/proto; `
pip install -e ./grr/core; `
pip install -e ./grr/client; `
pip install -e ./api_client/python; `
pip install -e ./grr/client_builder; `
pip install -e ./grr/server/[mysqldatastore]; `
pip install -e ./colab; `
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

```powershell
pip install --no-cache-dir -f https://storage.googleapis.com/releases.grr-response.com/index.html grr-response-templates
```

## Step 7: Install MySQL

Skip this on windows. Could be done through a docker container in easiest fashion.
Something like the [mysql defaults](https://hub.docker.com/_/mysql)
````powershell
docker run --name some-mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql:latest
````

------------


# From here on my windows guide for running this stops. 
At this point we can build a windows client package.

```powershell
grr_client_build build --output mytemplates
```