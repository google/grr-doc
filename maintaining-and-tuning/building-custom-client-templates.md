# Building custom client templates

## Building the templates

Note: templates have to be built on a target platform (i.e. if you need a
Windows 10 GRR client template, you have to build on Windows 10).

After
[installing the GRR server components](../installing-grr-server/overview.md),
you can build client templates with

```bash
grr_client_build build --output mytemplates
```

If you can't install prebuilt Debian or PIP packages, you'd need to install
GRR from source. You might choose to install the full server or just
the packages needed to build the templates. Please see
[Installing from source](../installing-grr-server/from-source.md) for details.


## Repacking the templates

The templates are generic GRR client builds that have to be repacked to be used
with a particular GRR server deployment. Repacking is a process that injects
server-specific configuration (like the frontend address, labels, etc).

While templates have to be built on the client target platform, repacking
has to be done on your GRR server, as GRR server contains the configuration
(i.e., crypto credentials for the clients to use).

```bash
grr_client_build repack --template mytemplates/*.zip --output_dir mytemplates
```

## Samples

We have fully automated client builds for Linux, OSX and Windows. The scripts
we use are mostly in the [Travis](https://github.com/google/grr/tree/master/travis)
and [Appveyor](https://github.com/google/grr/tree/master/appveyor)
directories on GitHub. Duplicating what we do there might give you custom clients
with little effort.
