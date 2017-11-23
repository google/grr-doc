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
