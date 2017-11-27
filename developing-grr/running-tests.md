# Running the tests

For running tests GRR uses the [pytest](https://pytest.org) framework.

### Prerequisites

Make sure you have correctly set-up the
[development environment](setting-up-dev-env.md), especially the part about
installing the `grr-response-test` package.

This setup is sufficient for running most of the tests. However, GRR also has
a UI component written in [Angular](https://angular.io/). For testing that part
we use [Selenium](http://seleniumhq.org) and
[ChromeDriver](https://sites.google.com/a/chromium.org/chromedriver/) which need
to be installed first. You can skip this part if you do not need to execute UI
tests but we strongly recommend to run them as well.

On Debian-based distros simply install `chromium-driver` package:

```bash
sudo apt install chromium-driver
```

If there is no `chromium-driver` available in your repositories you may try
installing Chromium browser and then downloading latest `chromium-driver` binary
from [the official website](https://sites.google.com/a/chromium.org/chromedriver/downloads).
After downloading unpack it somewhere and add it to your `$PATH` or just move it
to `/usr/bin`.

### Running the whole test suite

To run all the tests, navigate to the root GRR directory and simply execute:

```bash
pytest
```

This will automatically discover and execute all test cases.

### Running tests in parallel

To use pytest to run tests in parallel, install the pytest-xdist plugin

```docker
pip install pytest-xdist
```

and run

```docker
pytest -n <number of cores to use>
```

### Running the tests selectively

Running all the tests is reasonable when you want to test everything before
publishing your code, but it is not feasible during development. Usually you
just want to execute only tests in a particular directory, like so:

```bash
pytest grr/server/aff4_objects
```

Or just a particular file:

```bash
pytest grr/server/aff4_objects/filestore_test.py
```

Or just a particular test class:

```bash
pytest grr/server/aff4_objects/filestore_test.py::HashFileStoreTest
```

Or even just a single test method:

```docker
pytest grr/server/aff4_objects/filestore_test.py::HashFileStoreTest::testListHashes
```

### Ignoring test cases

Some kind of tests are particularly slow to run. For example, all UI tests are
based on running a real web browser instance and simulating its actions which is
painfully sluggish and can be very annoying if we want to test non-UI code.

In this case we can skip all tests in particular directory using the `--ignore`
flag, e.g.:

```bash
pytest --ignore=grr/gui/selenium_tests
```

This will run all the tests except the Selenium ones.

### Benchmarks

Benchmarks are not really testing the code correctness so there is no point in
running them every time we want to publish our code. This is why the test suite
will not run them by default. However, sometimes they can be useful for testing
the performance and sanity of our system.

In order to run the test suite including the benchmarks, pass the `--benchmark`
option to the test runner:

```bash
pytest --benchmark
```

### Debugging

If our tests are failing and we need to fix our code the
[Python Debugger](https://docs.python.org/3/library/pdb.html) can come in handy.

If you run pytest with `--pdb` flag then upon a failure the program execution
will be halted and you will be dropped into the PDB shell where you can
investigate the problem in the environment it occurred.

If you set breakpoints in your code manually using `pdb.set_trace()` you will
notice a weird behaviour when running your tests. This is because pytest
intercepts the standard input and output writes, breaking the PDB shell. To deal
with this behaviour simply run tests with `-s` flag - it will prevent pytest
from doing that.

### More information

The functionalities outlined in this guide are just a tip of the pytest
capabilities. For more information consult pytest's man page, check
`pytest --help` or visit the [pytest homepage](https://pytest.org).
