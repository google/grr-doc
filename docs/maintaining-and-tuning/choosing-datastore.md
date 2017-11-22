# Choosing GRR datastore

When installing GRR, you can choose between *SQLiteDataStore* and *MySQLAdvancedDataStore*.

> NOTE: Database choice is something that's normally done when GRR is installed. There's no documented way of migrating an existing deployment from one datastore to another.


## SQLiteDataStore *(for small/demo deployments only)*

SQLiteDataStore is based on SQLite, meaning zero-effort setup and maintenance. However, its performance characteristics are not comparable with MySQL, it's unlikely to handle a big load well. With SQLiteDataStore you're also limited to running all GRR components on a single machine, because they all will have to access database file directly.

## MySQLAdvancedDataStore *(for production use)*

MySQLAdvancedDataStore requires a bit more effort to set up, as you need to create a database user for GRR and configure GRR with appropriate credentials. However, MySQLAdvancedDataStore is the datastore that can handle significant load and the only one that makes scalable GRR deployment possible: you can run individual GRR components (workers, frontends, admin UI) on separate machines and make them all connect to the same database running elsewhere.
