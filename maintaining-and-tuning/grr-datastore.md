# GRR datastore

GRR needs a database backend in order to run. Previously, GRR supported
SQLite and MySQL databases, but support for SQLite was dropped after
GRR [v3.2.3.2](https://grr-doc.readthedocs.io/en/v3.2.3/release-notes.html) was
released. MySQL is now GRR's only supported database backend.

For users that were using the obsoleted *SQLiteDataStore*, please note that
GRR does not have functionality for migrating data to the MySQL datastore.
