# Glossary

## AFF4

AFF4 was the data model used for storage in GRR that has since been
deprecated. You can read about the usage in the [GRR paper][grr-paper] linked
above and there is additional documentation on [Forensics Wiki][fw-aff4].

## Agent

A platform-specific program that is installed on machines that one might want to
investigate. It communicates with the GRR server and can perform client actions
at the server's request.

## Client

A system that has an agent installed. Also used to refer to the specific
instance of an agent running in that system.

## Client Action

A client action is an action that a client can perform on behalf of the server.
It is the base unit of work on the client. Client actions are initiated by the
server through flows. Example client actions are `ListDirectory`,
`EnumerateFilesystems`, `Uninstall`.

## Collection

A collection is a logical set of objects stored in the AFF4 database. Generally
these are a list of URNs containing a grouping of data such as artifacts or
events from a client.

## Datastore

The backend is where all AFF4 and scheduler data is stored. It is provided as an
abstraction to allow for replacement of the datastore without significant
rewrite. The datastore supports read, write, querying and filtering.

## Flow

A logical collection of server or client actions which achieve a given
objective. A flow is the core unit of work in the GRR server. For example a
`BrowserHistory` flow contains all the logic to download, extract and display
browser history from a client. Flows can call other flows to get their job done.
E.g. A `CollectBrowserHistory` flow might call `ListDirectory` and `GetFile` to
do it's work. A flow is implemented as a class that inherits from `GRRFlow`.

## Frontend server

Server-side component that sends and receives messages back and forth from
clients.

## Hunt

A hunt is a mechanism for managing the execution of a flow on a large number of
machines. A hunt is normally used when you are searching for a specific piece of
data across a fleet of machines. Hunts allow for monitoring and reporting of
status.

## Message

Transfer unit in GRR that transports information from a flow to a client and
vice versa.

## Worker

Once receiving a message from a client a worker will wake up the flow that
requested its results and execute it.

[grr-paper]: https://storage.googleapis.com/docs.grr-response.com/scalable_datastore.pdf
[fw-aff4]: http://www.forensicswiki.org/wiki/AFF4
