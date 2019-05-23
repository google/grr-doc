# Defining Artifacts

## Basics

GRR artifacts are defined in YAML. The main artifact repository is hosted on
[GitHub][artifact-repository]. You can browse [existing artifact definitions]
[artifact-samples] or read the exhaustive [syntax overview][artifact-syntax].

## Knowledgebase

We use a standard set of machine information collected from the host for
variable interpolation. This collection of data is called the [*knowledgebase*]
[artifact-knowledgebase] and is referenced with a `%%variable%%` syntax.

The artifact defines where the data lives. Once it is retrieved by GRR a
[parser][artifact-parsers] can optionally be applied to turn the collected
information into a more useful format, such as parsing a browser history file
to produce URLs.

## Uploading new definitions

New artifacts should be added to the [forensic artifacts repository]
[artifact-repository].

The changes can be imported into GRR by running `make` in the `grr/artifacts`
directory. This will delete the existing artifacts, checkout the latest version
of the artifact repository and add all of the YAML definitions into GRR’s
directory. Running `python setup.py build` will have the same effect. The new
artifacts will be available once the server is restarted.

Artifacts can also be uploaded via the Artifacts GUI and used immediately
without the need for a restart.

### Local definitions

Artifacts that are specific to your environment or need to remain private can be
added to the `grr/artifacts/local` directory. This directory will remain
untouched when you update the main artifacts repository. You can also use this
directory to test new artifacts before they are added to the main public
repository.

### Flow templates

We currently support using the artifact format to call GRR-specific
functionality, such as invoking a GRR client action or listing processes. Such
"artifacts" are called *flow templates* and since they are GRR-specific they
remain in the GRR repository in the `grr/artifacts/flow_templates` directory.

This is a temporary working name. We intend to rework this functionality into a
more general, powerful and configurable way to call GRR from YAML.

[artifact-repository]: https://github.com/ForensicArtifacts/artifacts
[artifact-samples]: https://github.com/ForensicArtifacts/artifacts/tree/master/data
[artifact-syntax]: https://github.com/ForensicArtifacts/artifacts/blob/master/docs/Artifacts%20definition%20format%20and%20style%20guide.asciidoc
[artifact-knowledgebase]: https://github.com/google/grr/blob/master/grr/proto/knowledge_base.proto
[artifact-parsers]: https://github.com/google/grr/tree/master/grr/parsers
