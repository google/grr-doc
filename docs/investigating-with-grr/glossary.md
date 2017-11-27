# Glossary

## AFF4

AFF4 is the data model used for storage in GRR, with some minor
extensions. You can read about the usage in the GRR paper linked above
and there is additional detail linked at
<http://www.forensicswiki.org/wiki/AFF4>

## Agent

A platform-specific program that is installed on machines that one might
want to investigate. It communicates with the GRR server and can perform
client actions at the server’s request.

## Client

A system that has an agent installed. Also used to refer to the specific
instance of an agent running in that system.

## Client Action

A client action is an action that a client can perform on behalf of the
server. It is the base unit of work on the client. Client actions are
initiated by the server through Flows. Example client actions are
ListDirectory, EnumerateFilesystems, Uninstall.

## Collection

A Collection is a logical set of objects stored in the AFF4 database.
Generally these are a list of URNs containing a grouping of data such as
Artifacts or Events from a client.

## DataStore

The backend is where all AFF4 and Scheduler data is stored. It is
provided as an abstraction to allow for replacement of the datastore
without significant rewrite. The datastore supports read, write,
querying and filtering.

## Flow

A logical collection of server or client actions which achieve a given
objective. A flow is the core unit of work in the GRR server. For
example a BrowserHistory flow contains all the logic to download,
extract and display browser history from a client. Flows can call other
flows to get their job done. E.g. A CollectBrowserHistory flow might
call ListDirectory and GetFile to do it’s work. A flow is implemented as
a class that inherits from GRRFlow.

## Frontend server

Server-side component that sends and receives messages back and forth
from clients.

## Hunt

A Hunt is a mechanism for managing the execution of a flow on a large
number of machines. A hunt is normally used when you are searching for a
specific piece of data across a fleet of machines. Hunts allow for
monitoring and reporting of status.

## Message

Transfer unit in GRR that transports information from a Flow to a client
and viceversa.

## Worker

Once receiving a message from a client a worker will wake up the Flow
that requested its results and execute it.

