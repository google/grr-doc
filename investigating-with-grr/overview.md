
# Overview

Once set up and configured, the GRR user interface is a web
interface which allows the analyst to search for connected client (agent)
machines, examine what data has been collected from the machines and issue
requests to collect additional data.

The GRR server also provides access to this functionality through a JSON API.
Client libraries to support scripting from python or go are provided.

## Starting Points

Depending on the type of client data that the analyst is interested in, there
are several places that they might start.

### Virtual File System

The [virtual file system](vfs/virtual-file-system/) shows the files, directories,
and registry entries which have already been collect from a client. It shows
when the entry was collected, and provides some buttons to collect additional
buttons of this sort.

This is a natural starting point for ad-hock examination of an individual
machine.

### Flows

A [Flow](flows/what-are-flows.md) performs one or more operations on a client
machine, in order to collect or check for data. For example, the data collection
buttons shown by the [virtual file system](vfs/virtual-file-system/) start flows to
collect specific files and directories. However, flows can do many other
things - from searching a directory for files containing a particular substring,
to recording the current network configuration. The administrative interface
shows for each client the flows which have been launched against it also the
flow's status and any results returned.

When an analyst would like to collect a specific bit of information about a
machine, they will need to directly or indirectly run a flow.

### Hunts

A [Hunt](hunts/what-are-hunts.md) is a mechanism to run a Flow on a number of
clients. For example, this makes it possible to check if any Windows machine in
the fleet has a file with a particular name in a particular location.

### Artifacts
An [Artifact](artifacts/overview.md) is a way to collect and name a group of
files or other data that an analyst might want to collect as a unit. For
example, an artifact might try to collect all the common linux persistence
mechanisms.
