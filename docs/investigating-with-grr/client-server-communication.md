# Client-Server Communication

When a Flow needs to request information from a client, it queues up a message
for the client. GRR clients poll the GRR server approximately every 10 minutes,
and it will receive the message and begin responding to the request at the next
poll.

After a client performs some work, it will normally enter 'fast-poll' mode in
which it polls much more rapidly. Therefore when an analyst requests data from a
machine, it might initially take some minutes to respond but additional requests
will be noticed more quickly.

## Protocol

The client poll is an HTTP request. It passes a signed and encrypted payload and
expects the same from the GRR server. The client signs using its client
key. This key is created on the client when first run, and the GRR ID is
actually just a fingerprint of this key.

This means that no configuration is required by the client to establish an
identity, but that clients cannot eavesdrop on or impersonate other clients.
