# Specifying Windows Registry Paths

When specifying registry paths, GRR uses the following hive names (these
can also be found by looking at the registry folder under "Browse
Virtual Filesystem"):

    HKEY_CLASSES_ROOT
    HKEY_CURRENT_CONFIG
    HKEY_CURRENT_USER
    HKEY_DYN_DATA
    HKEY_LOCAL_MACHINE
    HKEY_PERFORMANCE_DATA
    HKEY_USERS

The Registry Finder flow uses the same path globbing
and interpolation system as described in [Specifying File Paths](specifying-file-paths.md).
Examples:

```docker
HKEY_USERS\%%users.sid%%\Software\Microsoft\Windows\CurrentVersion\Run\*
HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\RunOnce\*
```

RegistryFinder will retrieve the values of any keys specified and report
them in the registry data field. Default values will be retrieved and
reported in registry data of the parent key. E.g. for this registry
structure:

```docker
HKEY_LOCAL_MACHINE\Software\test:
  (Default) = "defaultdata"
  subkey = "subkeydata"
```

Collecting this:

```docker
HKEY_LOCAL_MACHINE\Software\test\*
```

Will give results like:
```docker
Path:           /HKEY_LOCAL_MACHINE/SOFTWARE/test
Registry data:  defaultdata

Path:           /HKEY_LOCAL_MACHINE/SOFTWARE/test/subkey
Registry data:  subkeydata
```