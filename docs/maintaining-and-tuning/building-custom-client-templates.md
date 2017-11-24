# Building custom client templates

After
[installing the GRR server components](../installing-grr-server/overview.md),
you can build client templates with

```bash
grr_client_build build --output mytemplates
```

and repack them with

```bash
grr_client_build repack --template mytemplates/*.zip --output_dir mytemplates
```

The first step needs to be done on the client target platform while the repacking step happens on your GRR server machine that knows about the proper configuration (i.e., crypto credentials for the clients to use).

We have fully automated client builds for Linux, OSX and Windows. The scripts we use are mostly in [the Vagrant directory](https://github.com/google/grr/tree/master/vagrant) on GitHub. Duplicating what we do there might give you custom clients with little effort.