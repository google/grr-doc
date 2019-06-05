osquery
=======

[osquery](https://osquery.io/) is a utility created by Facebook that exposes system information through an SQL API. By writing SQL queries one can list processes, devices, network connections, users or browse directory structure. All that data is well-structured and described by the associated [schema](https://osquery.io/schema/). By mixing that with capabilities of SQL we get a really powerful tool for analysts.

Setup
-----

The osquery executable has to be available on the target client. Usually, it is as easy as downloading [a package](https://osquery.io/downloads/official/) from the official website for appropriate platform and putting it somewhere where GRR can access it, e.g. `/opt/osquery/`. Then, the location of the main osquery executable has to be specified in the `Osquery.path` option in the GRR configuration:

```yaml
(...)

Platform:Linux:
  (...)

  Osquery.path: '/opt/osquery/3.3/usr/bin/osqueryi'

(...)

Platform:Windows:
  (...)

  Osquery.path: 'C:\\Program Files\\osquery\\osqueryd.exe'

(...)
```

Note that it does not really matter whether you use `osqueryi` or `osqueryd`, both should work just fine.

*Make sure you repack/redeploy GRR clients after the Osquery.path configuration setting is updated.*


Investigating
-------------

To run a query on the desired client, simply start a new flow under "Collectors > Osquery". The flow itself is very simple with "query" field being the important one. For example, to run a simple query that lists all the processes, you can use the following:

```
SELECT * FROM processes;
```

After a moment, the client should yield an SQL table with all the desired results.

Of course, it is possible to use all SQL features, such as joins:

```
SELECT cmdline, total_size FROM osquery_info JOIN processes USING (pid);
```

Refer to the osquery [schema](https://osquery.io/schema/) documentation to discover what tables and columns are available.

#### Options

##### Timeout

The timeout field can be used to specify a time after which the query is killed if it is not able to produce any results. Usually, queries should return immediately and the default timeout should be more than enough. However, it is possible to write more sophisticated queries (e.g. ones that search through the file system) where it might make sense to increase it.

#### Ignore `stderr` errors

By default, GRR uses `stderr` output produced by osquery to determine whether the execution was successful or not (e.g. due to syntax errors in the specified query). However, occasionally osquery can also produce warning messages that will cause the entire flow to fail. In such cases, it might be desired to simply suppress them.

Note that this option should be used with caution and not be ticked if not needed—otherwise errors in the query might go unnoticed.
