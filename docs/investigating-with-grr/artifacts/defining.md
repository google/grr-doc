# Defining Artifacts

New artifacts should be added to the [forensic artifacts
repository](https://github.com/ForensicArtifacts/artifacts/tree/master/data).
The changes can be imported into grr by running `make` in the `grr/artifacts`
directory. This will delete the existing artifacts, checkout the latest version
of the artifact repository, and add all of the yaml definitions into GRR’s
directory. Running `python setup.py build` will have the same effect. The new
artifacts will be available once the server is restarted.

Artifacts can also be uploaded via the Artifact Manager GUI and used immediately
without the need for a restart. When developing a new artifact you can use the
`grr/artifacts/local` directory as a temporary home for testing (see next
section).

## Private Artifacts

Artifacts that are specific to your environment or need to remain private can be
added to the `grr/artifacts/local` directory. This directory will remain
untouched when you update the main artifacts repository. You can also use this
directory to test new artifacts before they are added to the main public
repository.

## GRR-Specific Artifacts aka "Flow Templates"

We currently support using the artifact format to call GRR-specific
functionality, such as invoking a GRR client action, listing processes or
running a rekall plugin. These "artifacts" are grr-specific so they remain in
the GRR repository under `artifacts/flow\_templates`, which is a temporary
working name. We intend to rework this functionality into a more general,
powerful, and configurable way to call GRR from YAML.
