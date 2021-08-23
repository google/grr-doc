# What is GRR?

GRR Rapid Response is an incident response framework focused on remote live forensics.

The goal of GRR is to support forensics and investigations in a fast, scalable manner to allow analysts to quickly triage attacks and perform analysis remotely.

GRR consists of 2 parts: client and server.

**GRR client** is deployed on systems that one might want to investigate. On every such system, once deployed, GRR client periodically polls GRR frontend servers for work. "Work" means running a specific action: downloading file, listing a directory, etc.

**GRR server** infrastructure consists of several components (frontends, workers, UI servers, fleetspeak) and provides web-based graphical user interface and an API endpoint that allows analysts to schedule actions on clients and view and process collected data.

## Remote forensics at scale

GRR was built to run at scale so that analysts are capable of effectively collecting and processing data from large numbers of machines. GRR was built with following scenarios in mind:

* Joe saw something weird, check his machine *(p.s. Joe is on holiday in Cambodia and on 3G)*
* Forensically acquire 25 machines for analysis *(p.s. they're in 5 continents and none are Windows)*
* Tell me if this machine is compromised *(while you're at it, check 100,000 of them - i.e. "hunt" across the fleet)*


## GRR client features

* Cross-platform support for Linux, OS X and Windows clients.
* Live remote memory analysis using YARA library.
* Powerful search and download capabilities for files and the Windows registry.
* OS-level and raw file system access, using the SleuthKit (TSK).
* Secure communication infrastructure designed for Internet deployment.
* Detailed monitoring of client CPU, memory, IO usage and self-imposed limits.

## GRR server features

* Fully fledged response capabilities handling most incident response and
   forensics tasks.
* Enterprise hunting (searching across a fleet of machines) support.
* Fast and simple collection of hundreds of digital forensic artifacts.
* AngularJS Web UI and RESTful JSON API with client libraries in Python, PowerShell and Go.
* Powerful data export features supporting variety of formats and output plugins.
* Fully scalable back-end capable of handling large deployments.
* Automated scheduling for recurring tasks.
* Asynchronous design allowing future task scheduling for clients, designed to work with a large fleet of laptops.
