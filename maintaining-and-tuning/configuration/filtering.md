# Filtering

The configuration system may be extended to provide additional
functionality accessible from the configuration file. For example
consider the following configuration file:

``` yaml
Logging.path: "%(HOME|env)/grr.log"
```

This expansion sequence uses the *env* filter which expands a value
from the environment. In this case the environment variable *HOME*
will be expanded into the `Logging.path` parameter to place the log
file in the user’s home directory.

There are a number of additional interesting filters. The *file* filter
allows including other files from the filesystem into the configuration
file. For example, some people prefer to keep their certificates in
separate files rather than paste them into the config file:

``` yaml
CA.certificate: "%(/etc/certificates/ca.pem|file)"
```

It is even possible to nest expansion sequences. For example this
retrieves the client’s private key from a location which depends on the
client name:

``` yaml
Client.private_key: "%(/etc/grr/client/%(Client.name)/private_key.pem|file)"
```
