![GRR logo](images/grr_logo_real_sm.png)

## What is GRR?

GRR Rapid Response is an incident response framework focused on remote live forensics.

The goal of GRR is to support forensics and investigations in a fast, scalable manner to allow analysts to quickly triage attacks and perform analysis remotely.

## High-level overview

GRR consists of 2 parts: client and server.

**GRR client** is deployed on systems that one might want to investigate. On every such system, once deployed, GRR client periodically polls GRR frontend servers for work. "Work" means running a specific action: downloading file, listing a directory, etc.

**GRR server** infrastructure consists of several components (frontends, workers, UI servers) and provides web-based graphical user interface and an API endpoint that allows analysts to schedule actions on clients and view and process collected data.

## GRR on GitHub

GRR is open source and is developed on GitHub: [github.com/google/grr](https://github.com/google/grr)

## Contacts

* GitHub issues: [github.com/google/grr/issues](https://github.com/google/grr/issues)
* GRR Developers mailing list: [grr-dev](https://groups.google.com/forum/#!forum/grr-dev)
* Follow us [on twitter](https://twitter.com/grrresponse) for announcements of GRR user meetups. We use a [gitter chat room](https://gitter.im/google/grr) during meetups.



