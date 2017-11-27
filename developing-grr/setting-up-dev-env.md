# Setting Up a Development Environment

Navigate to the root GRR directory (or clone the repository if you have not done
it yet):

```docker
git clone https://github.com/google/grr
cd grr/
```

### Virtual environment

We strongly recommend setting up a Python virtual environment for the
development in order to prevent your everyday environment from being corrupted
with a work-in-progress code. If you are feeling adventurous you might omit all
the steps related to the virtual environment.

Make sure that you have `virtualenv` installed. It should be available in
repositories of all popular Linux distributions. For example, to install it on
Ubuntu-based distros simply run:

```bash
sudo apt install virtualenv
```

To create a virtual environment you just execute the `virtualenv $DIR` command
where `$DIR` is the directory where you want it to be placed. The rest of the
manual will assume that the environment is created in `~/.virtualenv/GRR` like
this:

```bash
virtualenv ~/.virtualenv/GRR
```

After creating the environment you have to activate it:

```bash
source ~/.virtualenv/GRR/bin/activate
```

It is also advised to make sure that we are running a recent version of `pip`:

```bash
pip install --upgrade pip
```

For more information about creating and managing your virtual environments
refer to the [`virtualenv` documentation](https://virtualenv.pypa.io).

### Node.js environment

Because GRR offers a user interface component it also needs some JavaScript code
to be built with Node.js. Fortunately, this can be done with `pip` inside our
virtual environment so that your system remains uncluttered.

To install Node.js simply do:

```bash
pip install nodeenv
nodeenv -p --prebuilt
```

Because the `nodeenv` command modifies our virtual environment, we also need to
reinitialize it with:

```bash
source ~/.virtalenv/GRR
```

### Installing GRR packages

GRR is split into multiple packages. For the development we recommend installing
all components. Assuming that you are in the root GRR directory run the
following commands:

```bash
pip install -e .
pip install -e ./grr/config/grr-response-server
pip install -e ./grr/config/grr-response-client
pip install -e ./grr/config/grr-response-test
```

The `-e` (or `--editable`) flag passed to `pip` makes sure that the packages
are installed in a "development" mode and any changes you make in your working
directory are directly reflected in your virtual environment, no reinstalling
is required.

**Note**: Some prerequisites might be necessary as described in
[installing from released pip packages](../installing-grr-server/from-released-pip/).

### Testing

Now you are ready to start the GRR development. To make sure that everything is
set-up correctly follow the [testing guide](`running-tests.md`).
