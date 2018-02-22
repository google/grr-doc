# Installing GRR clients on Mac OS X

For OSX you will see a pkg file, install the pkg. It will add a
launchd item and start it.

See [Linux instructions](on-linux.md). They apply also to OSX.

On OSX you can also use the Uninstall GRR flow.

## Uninstalling on Mac OS X

This is a quick manual on how to remove the GRR client completely from a machine.

On OSX, pkg uninstall is not supported. The files to delete are:

```docker
/usr/local/lib/grr/*
/etc/grr.local.yaml
/Library/LaunchDaemons/com.google.code.grr.plist
```

The service can be stopped using

```docker
sudo launchctl unload /Library/LaunchDaemons/com.google.corp.grr.plist
```
