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

## AFF4 deprecation

Starting from the version **3.3.0** GRR uses a new datastore format by default - **REL_DB**. REL_DB is backwards-incompatible with the now-deprecated AFF4 datastore format (even though they both use MySQL as a backend).

Use of AFF4-based deployments is now discouraged. REL_DB is expected to be much more stable and performant.

## Switching an AFF4-based deployment to use REL_DB

To check which datastore implementation you're using: go to "Setting" in the GRR AdminUI and check the "Database" section. If `Database.aff4_enabled` is set to `0` and `Database.enabled` is set to `1`, you're running REL_DB.

***Note (IMPORTANT!):*** *There's no established data migration process to migrate the data from AFF4 data storage to REL_DB. You'll lose all the historical data when you switch an existing deployment to use REL_DB. ***However, the clients, will continue to work without issues.*** They will show up in the new datastore first time they check in (normally every 10 minutes).*

To switch an existing GRR deployment to REL_DB.

1. Backup your MySQL database and GRR server configuration files *(this is a good idea for any kind of GRR upgrade, ideally you should also have regular backups set up)*.

1. Upgrade GRR to a version greater or equal than 3.3.0.0.

1. Run the following to update the GRR server configuration file:

   ```bash
   sudo grr_config_updater switch_datastore
   # Add at least one admin user to the empty REL_DB datastore.
   sudo grr_config_updater add_user --admin admin
   ```

4. Answer the questions asked by the tool.

5. Restart GRR server.

   ```
   sudo service grr-server restart
   ```

At this point GRR will run with an empty REL_DB datastore. Your clients will still be able to talk to the server and will appear in the AdminUI as soon as they check in (normally within 10 minutes).

## Switching back to AFF4-based deployment

If for some reason you had an issue with switching to REL_DB and would like to go back to using AFF4 datastore at your GRR deployment, edit your configuration file at `/etc/grr/server.local.yaml` and make sure you have the settings below set correctly (or simply restore the file to its backed up version):

```yaml
Database.aff4_enabled: True
Database.enabled: False
# Ignore the following line if you had custom
# Blobstore.implementation setting before.
Blobstore.implementation: MemoryStreamBlobStore
```
