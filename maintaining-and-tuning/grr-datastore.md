# GRR datastore

GRR needs a database backend in order to run. Previously, GRR supported
SQLite and MySQL databases, but support for SQLite was dropped after
GRR [v3.2.3.2](https://grr-doc.readthedocs.io/en/v3.2.3/release-notes.html) was
released. MySQL is now GRR's only supported database backend.

For users that were using the obsoleted *SQLiteDataStore*, please note that
GRR does not have functionality for migrating data to the MySQL datastore. No
need to fret though - a client re-deployment will not be necessary. Existing
clients will still be able to talk to the GRR server when starting off with a
new database. Client re-enrollment and interrogation should happen
automatically.
