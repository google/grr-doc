# Overview

Depending on your use case, there are multiple ways of installing the
GRR server components. Most users will want to
[install a release deb](from-release-deb.md). The server deb includes
client templates that can be downloaded from GRR's Admin UI after installation.

Alternatively, GRR can be [installed from PIP](from-released-pip.md).

You can install also GRR from source as described
[here](from-source.md). You should then be able to modify GRR code and build
your own server/client installers.


## GRR components

GRR consists of a client and a few server components.

Whenever GRR server is installed using one of the methods mentioned above, all the server components are installed. This is a simple way to setup smaller GRR server installations: each component will run as a separate server process on the same machine. However, when scaling GRR server to run on multiple machines, each component can exist on its own machine in the data center and run separately.

GRR components are:

#### Client

The GRR client **is not a server component** but it comes bundled with GRR server. GRR client is deployed on corporate assets using the usual mechanism for software distribution and updates (e.g. SMS, apt). The client communicates with the front-end server using a HTTP POST requests. GRR client sends and receives GRR messages from the server. All communication with the front end servers is encrypted.

#### Datastore
The data store acts both as a central storage component for data, and as a communication mechanism for all GRR server components.

***Note on the AFF4 datastore deprecation***

*Starting from the version ***3.3.0.0*** GRR uses a new datastore format by default - ***REL_DB***. REL_DB is backwards-incompatible with the now-deprecated AFF4 datastore format (even though they both use MySQL as a backend).*

*Use of AFF4-based deployments is now discouraged. REL_DB is expected to be much more stable and performant. Please see [these docs](../maintaining-and-tuning/grr-datastore.md) if you're upgrading an older GRR version and would like to try out the new datastore.*

#### Front End Servers
The front end servers' main task is to decrypt POST requests from the client, un-bundle the contained messages and queue these on the data store. The front end also fetches any messages queued for the client and sends them to the client.

#### Worker
In order to remain scalable, the front end does not do any processing of data, preferring to offload processing to special worker components. The number of workers can be tuned in response to increased workload. Workers typically check queues in the data stores for responses from the client, process those and re-queue new requests for the clients (See Flows and Queues).

#### Web UI
GRR Web UI is the central application which enables the incident responder or forensic analyst to interact with the system. It allows for analysis tasks to be queued for the clients, and results of previous stored analysis to be examined. It also acts as an API endpoint: GRR API can be used for automation and integration with other systems.

