# GRR Client Protection

The open source agent does not contain protection against being disabled
by administrator/root on the machine. E.g. on Windows, if an attacker
stops the service, the agent will stop and will no longer be reachable.
Currently, it is up to the deployer of GRR to provide more protection
for the service.

## Obfuscation

If every deployment in the world is running from the same location and
the same code, e.g. `c:\program files\grr\grr.exe`, it becomes a pretty
obvious thing for an attacker to look for and disable. Luckily the
attacker has the same problem an investigator has in finding malware on
a system, and we can use the same techniques to protect the client. One
of the key benefits of having an open architecture is that customization
of the client and server is easy, and completely within your control.

For a test, or low security deployment, using the defaults open source
agents is fine. However, in a secure environment we strongly recommend
using some form of obfuscation.

This can come in many forms, but to give some examples:

  - Changing service, and binary names

  - Changing registry keys

  - Obfuscating the underlying python code

  - Using a packer to obfuscate the resulting binary

  - Implementing advanced protective or obfuscation functionality such
    as those used in rootkits

  - Implementing watchers to monitor for failure of the client

GRR does not include any obfuscation mechanisms by default. But we
attempt to make this relatively easy by controlling the build process
through the configuration file.

## Enrollment

In the default setup, clients can register to the GRR server with no
prior knowledge. This means that anyone who has a copy of the GRR agent,
and knows the address of your GRR server can register their client to
your deployment. This significantly eases deployment, and is generally
considered low risk as the client has no control or trust on the server.

However, it does introduce some risk, in particular:

  - If there are flows or hunts you deploy to the entire fleet, a
    malicious client may receive them. These could give away information
    about what you are searching for.

  - Clients are allowed to send some limited messages to the server
    without prompting, these are called Well Known flows. By default
    these can be used to send log messages, or errors. A malicious
    client using these could fill up logs and disk space.

  - If you have custom Well Known Flows that perform interesting
    actions. You need to be aware that untrusted clients can call them.
    Most often this could result in a DoS condition, e.g. through a
    client sending multiple install failure or client crash messages.

In many environments this risk is unwarranted, so we suggest
implementing further authorization in the Enrollment Flow using some
information that only your client knows, to authenticate it before
allowing it to become a registered client.

**Note** that this does not give someone the ability to overwrite data from
another client, as client name collisions are protected.
