# Installing GRR clients on Linux

For Linux you will see a deb and rpms, install the appropriate one.
For testing purposes you can run the client on the same machine as
the server if you like.

The process depends on your environment, if you have a
mechanism such as puppet, then building as a Deb package and deploying
that way makes the most sense. Alternatively you can deploy using ssh:

    scp client_version.deb host:/tmp/
    ssh host sudo dpkg -i /tmp/client_version.deb


## Uninstalling on Linux

This is a quick manual on how to remove the GRR client completely from a machine.

On Linux the standard system packaging (deb, pkg) is used by default.
Use the standard uninstall mechanisms for uninstalling.

```docker
dpkg -r grr
```

This might leave some config files lying around, if a complete purge is necessary, the list of files to delete is:

```docker
/usr/lib/grr/*
/etc/grr.local.yaml
/etc/init/grr.conf
```

The GRR service can be stopped using

```docker
sudo service grr stop
```
