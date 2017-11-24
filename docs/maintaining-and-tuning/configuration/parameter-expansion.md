# Parameter Expansion

The GRR configuration file format allows for expansion of configuration
parameters inside other parameters. For example consider the following
configuration file:

```docker
Client.name: GRR

Nanny.service_name: "%(Client.name)service.exe"
Nanny.service_key_hive: HKEY_LOCAL_MACHINE
Nanny.service_key: Software\\%(Client.name)
Nanny.child_command_line: |
  %(child_binary) --config "%(Client.install_path)\\%(Client.binary_name).yaml"
```

The expansion sequence `%(parameter_name)` substitutes or expands the
parameter into the string. This allows us to build values automatically
based on other values. For example above, the `Nanny.service_name` will
be `GRRservice.exe` and the `service_key` will be set to `Software\GRR`

Expansion is very useful, but sometimes it gets in the way. For example,
if we need to pass literal % escape sequences. Consider the
Logging.format parameter which is actually a python format
string:

```docker
Logging.format: \%(levelname\)s \%(module\)s:\%(lineno\)s] \%(message\)s
Logging.format: %{%(levelname)s %(module)s:%(lineno)s] %(message)s}
```

- This form escapes GRR’s special escaping sequence by preceding both
  opening and closing sequences with the backslash character.

- This variation uses the literal expansion sequence *%{}* to declare
    the entire line as a literal string and prevent expansion.
