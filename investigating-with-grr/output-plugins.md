# Output Plugins
This document outlines how to send flow and hunt results from GRR to other systems and formats for further analysis.

Every GRR installation supports
[many Output Plugins](https://github.com/google/grr/tree/master/grr/server/grr_response_server/output_plugins) by default
to save flow/hunt results in different formats or send the results to other systems.

## Splunk

GRR can send flow results as Events to Splunk's HTTP Event Collector. To set this up, add a new HTTP Event Collector in
Splunk's Data Input Settings. Events automatically get `grr` as default source and
`grr_flow_result` as default sourcetype unless you override this in Splunk's or GRR's configuration.

Configure GRR to send data to your Splunk instance by specifying the following values in your server configuration YAML file.
`url` refers to the absolute API URL of your Splunk installation, including scheme and port. `token` is the generated access
token from the Splunk HEC settings. More configuration options, including how to deal with Splunk Cloud's self-signed
certificates are found in
[config/output_plugins.py](https://github.com/google/grr/blob/master/grr/core/grr_response_core/config/output_plugins.py).
```yaml
Splunk.url: https://input-prd-p-123456788901.cloud.splunk.com:8088
Splunk.token: 97e96c19-9bf1-4618-a079-37c567b577dc
```

After restarting your server, you can send flow and hunt results to Splunk, by enabling `SplunkOutputPlugin` when launching a
flow/hunt. Here's an example event that will be sent to Splunk, where the analyst set `incident-123` as annotation for the
flow.

```js
{
    "annotations": ["incident-123"],
    "client": {
      "hostname": "max.example.com",
      "os": "Linux",
      "usernames": "max",
      // ...
    },
    "flow": {
      "name": "ClientFileFinder",
      "creator": "sherlock",
      "flowId": "23B01B77",
      // ...
    },
    "resultType": "FileFinderResult",
    "result": {
      "statEntry": {
        "stMode": "33261",
        "stSize": "1444",
        "pathspec": {
          "path": "/home/max/Downloads/rickmortyseason6earlyaccess.sh",
          // ...
        },
        // ...
      }
    }
  }
```

## BigQuery
Our blog contains a
[post explaining how to setup and use BigQuery](http://grr-response.blogspot.com/2015/11/using-bigquery-to-analyze-data.html).


