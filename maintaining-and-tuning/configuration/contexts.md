# Configuration Contexts

The next important concept to understand is that of configuration
contexts. GRR consists of many components, which share most of their
configuration. Often, however, we want to specify slight differences
between each component. If we were to write a separate configuration
file say for building each client version (Currently, 3 operating systems, and 2
architectures) as well as for each component (e.g. worker, web UI,
frontend etc), we would end up with an unmaintainable mess of many
configuration files. It would make more sense to put most of the common
configuration parameters in the same file, and only specify the
different ones, depending on the component which is running.

GRR introduces the concept of running context. The context is a list of
attributes about the currently running component. When the code accesses
the configuration system, the configuration system considers the
currently running context and returns the appropriate value of the
required parameter.

For example, consider the parameter `Logging.filename` which specifies the
location of the log file. In a full GRR installation, we wish the GRR Admin
UI to log to `/var/log/grr/adminui.log` while the frontend should log to
`/var/log/grr/frontend.log`. We can therefore specify in the YAML config
file:

``` yaml
Logging.filename: /var/log/grr/grr_server.log

AdminUI Context:
  Logging.filename: /var/log/grr/adminui.log

Frontend Context:
  Logging.filename: /var/log/grr/httpserver.log

Client Context:
  Logging.filename: /var/log/grr/grr_client.log

  Platform:Windows:
    Logging.filename: c:\\windows\\system32\\grr.log
```

When the *AdminUI* program starts up, it populates its context with
`AdminUI Context`. This forces the configuration system to return the
value specific to this context. Note that other components, such as the
worker will set a context of *Worker Context*, which will not match any
of the above overrides. Therefore the worker will simply log to the
default of `/var/log/grr/grr_server.log`.

Note that it is possible to have multiple contexts defined at the same
time. So for example, GRR client running under windows will have the
contexts, `Client Context` and `Platform:Windows`, while a GRR client
running under Linux will have the context `Client Context` and
`Platform:Linux`. When several possibilities can apply, the option which
matches the most context parameters will be selected. So in the above
example, linux and osx clients will have a context like `Client Context`
and will select `/var/log/grr/grr_client.log`. On the other hand, a
windows client will also match the `Platform:Windows` context, and will
therefore select `c:\windows\system32\grr.log`.

The following is a non-exhaustive list of available contexts:

  - *AdminUI Context*, *Worker Context*, *Frontend Context* etc. Are
    defined when running one of the main programs.

  - *Test Context* is defined when running unit tests.

  - *Arch:i386* and *Arch:amd64* are set when running a 32 or 64 bit
    GRR client binary.

  - *Installer Context* is defined when the windows installer is active
    (i.e. during installation)

  - *Platform:Windows*, *Platform:Linux*, *Platform:Darwin* are set when
    running GRR client under these platforms.

The full list can be seen [here](https://github.com/google/grr/blob/master/grr/core/grr_response_core/config/contexts.py).
