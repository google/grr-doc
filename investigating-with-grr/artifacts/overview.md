# Artifacts

## Outline

During a security investigation responders need to quickly retrieve common
pieces of information that include items such as logs, configured services, cron
jobs, patch state, user accounts, and much more. These pieces of information are
known as forensic artifacts, and their location and format vary drastically
across systems.

We have built a framework to describe forensic artifacts that allows them to be
collected and customised quickly using GRR. This collection was initially
contained inside the GRR repository, but we have now moved it out to [a separate
repository][artifact-repository] to make access simple for other tools.

## Goals

The goals of the GRR artifacts implementation are:

  - Describe artifacts with enough precision that they can be collected
    automatically without user input.

  - Cover modern versions of Mac, Windows, and Linux and common software
    products of interest for forensics.

  - Provide a standard variable interpolation scheme that allows artifacts to
    simply specify concepts like "all user home directories", `%TEMP%`,
    `%SYSTEMROOT%` etc.

  - Allow grouping across operating systems and products e.g. "Chrome
    Web History" artifact knows where the web history is for Chrome on Mac,
    Windows and Linux.

  - Allow grouping of artifacts into high level concepts like *persistence
    mechanisms*, and investigation specific meta-artifacts.

  - To create simple, shareable, non-GRR-specific human-readable definitions
    that allow people unfamiliar with the system to create new artifacts. i.e.
    not XML or a domain specific language.

  - The ability to write new artifacts, upload them to GRR and be able to
    collect them immediately.

[artifact-repository]: https://github.com/ForensicArtifacts/artifacts
