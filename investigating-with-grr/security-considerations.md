# Security Considerations

As described in [Client-Server Communication](client-server-communication.md),
communication between the GRR client and server is secure against eavesdropping
and impersonation. Furthermore, the server's record of flows run and files
downloaded is not changed after the fact. It is intended to provide a secure
archive of data that has been gathered from machines.

## Root Privileges

The GRR client agent normally runs as root, and by design is capable of reading any
data on the system. Furthermore some flows can use significant resources on
client (e.g. searching a large directory recursively) and in fact the GRR agent
does have the ability to download and execute server provided code, though the
code does need to be signed.

For these reasons, access to the GRR server should be considered tantamount to
have root access to all GRR client machines. While we provide auditing and
authorization support to mitigate the risks of this, the risks inherient in this
should be understood when configuring and using GRR.
