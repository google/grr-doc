# Securing access to GRR server (important!)

GRR is a powerful system. However, with power comes responsibility and potential security risks.

If you're running GRR for anything besides simple demo purposes, it's extremely important to properly secure access to GRR server infrastructure. Because:

1. Anybody who has root access to your GRR server effectively becomes root on all systems running GRR client talking to your GRR server.

1. Anybody who has direct write access to GRR datastore (no matter if it's SQLite or MySQL) effectively becomes root on all systems running GRR client talking to your GRR server.

Consequently, it's important to secure your GRR infrastructure:

1. Maximally restrict SSH access (or any other kind of direct access) to machines that run GRR server infrastructure.

1. Make sure GRR web UI is not accessible from the Internet.

1. Make sure GRR's web UI is served through an Apache or Nginx proxy via HTTPS. If you're using any kind of internal authentication/authorization system, limit access to GRR web UI when configuring Apache or Nginx. See [user authentication](../maintaining-and-tuning/user-management/authentication.md) documentation.

1. If there're more than just a few people working with GRR, turn on [GRR approval-based auditing](../maintaining-and-tuning/approval-based-auditing.md)

1. GRR keys are well-protected and backed up in a secure fashion (see [Key Management](../maintaining-and-tuning/key-management/which-keys-and-how.md)). You may also
regenerate code signing keys with passphrases for additional security.
