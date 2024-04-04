# Securing access to GRR server (important!)

GRR is a powerful system. However, with power comes responsibility and potential security risks.

If you're running GRR for anything besides simple demo purposes, it's extremely important to properly secure access to GRR server infrastructure. Because:

1. Anybody who has root access to your GRR server effectively becomes root on all systems running GRR client talking to your GRR server.

1. Anybody who has direct write access to GRR datastore effectively becomes root on all systems running GRR client talking to your GRR server.

Consequently, it's important to secure your GRR infrastructure. Please follow a security checklist below.

## GRR Security Checklist

1. Generate new CA/server keys on initial install. Back up these keys somewhere securely (see [Key Management](../maintaining-and-tuning/key-management/which-keys-and-how.md)).

1. Maximally restrict SSH access (or any other kind of direct access) to GRR server machines.

1. Make sure GRR web UI is not exposed to the Internet and is protected.

For a high security environment:

1. Make sure GRR's web UI is served through an Apache or Nginx proxy via HTTPS. If you're using any kind of internal authentication/authorization system, limit access to GRR web UI when configuring Apache or Nginx. See [user authentication](../maintaining-and-tuning/user-management/authentication.md) documentation.

1. If there're more than just a few people working with GRR, turn on [GRR approval-based access control](../maintaining-and-tuning/approval-based-workflow.md)

1. Regenerate code signing key with passphrases for additional security.

1. Run the http server serving clients on a separate machine to the workers.

1. Ensure the database server is using strong passwords and is well protected.

1. Produce obfuscated clients (repack the clients with a different *Client.name* setting)
