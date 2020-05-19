# Monitoring
This page outlines how to set up monitoring for the GRR components. GRR keep tracks of many metrics
which can be used to create charts about GRR's performance, health, and workload.

When `Monitoring.http_port` is configured, each GRR component exports metrics at 
`http://<host>:<port>/metrics`. The export is human-readable plain-text and follows the 
[Open Metrics standard](https://openmetrics.io/). More importantly however,
[Prometheus](https://prometheus.io) can parse the metrics.


## Example Setup
This example will walk you through a basic Prometheus setup. For this example, the GRR Frontend,
Worker, and Admin UI will be launched on your local machine. Please refer to
[Installing GRR Server](../installing-grr-server) for a real-world setup.

1. Install GRR, for example from [pip](../installing-grr-server/from-released-pip.html).

1. Run the GRR components locally. Execute each of the three commands in a separate terminal:

    ```bash
    grr_server --component admin_ui -p Monitoring.http_port=44451
    
    grr_server --component frontend -p Monitoring.http_port=44452
    
    grr_server --component worker -p Monitoring.http_port=44453
    ```
    
    Note: Custom monitoring port assignment is only required because the ports would clash when
    running multiple GRR components on one machine. Prometheus requires to know which type of
    component listens on which ports. If you use `Monitoring.http_port_max`, make sure that only one
    type of GRR components (e.g. only workers) listen on a given range of ports. 

1. Open [http://localhost:44451/metrics](http://localhost:44451/metrics) in your browser. You should
see a plain-text list of metrics.

1. [Install Prometheus](https://prometheus.io/docs/prometheus/latest/getting_started/), e.g. by
downloading and unpacking the archive file.

1. Configure Prometheus to scrape GRR. Save the following configuration as `prometheus.yml` in
the Prometheus folder.
    ```yaml
    global:
      scrape_interval: 15s
     
    scrape_configs:
      - job_name: 'grr_admin_ui'
        static_configs:
        - targets: ['localhost:44451']
    
      - job_name: 'grr_frontend'
        static_configs:
        - targets: ['localhost:44452']
    
      - job_name: 'grr_worker'
        static_configs:
        - targets: ['localhost:44453']
      ```

1. Start Prometheus, by running the following command from the Prometheus folder:
    ```bash
    ./prometheus --config.file=prometheus.yml
    ```

1. Open [http://localhost:9090/targets](http://localhost:9090/targets) in your browser. After a
couple seconds, you should see three targets (`grr_admin_ui`, `grr_frontend`, `grr_worker`), each
having 1 instance up.

1. Open the Expression Browser by clicking on Graph
([http://localhost:9090/graph](http://localhost:9090/graph)). On this page, click on the Graph tab
(next to Console). Then, try any of the example queries to query GRR metrics. Be aware that you
might only see very few data points, very low values, or no data at all since GRR is not under any
real workload and has 0 connected clients in this example.


## Example Queries
To get you started, this page contains some example queries. These queries give you a good insight
on GRRs health and workload.

### QPS rate for the Frontend
```
rate(frontend_request_count_total{job="grr_frontend"}[1m])
```

### Latency for requests to the Frontend
```
rate(frontend_request_latency_sum{job="grr_frontend"}[5m]) /
rate(frontend_request_latency_count{job="grr_frontend"}[5m])
```

### Active Tasks running on the Frontend
```
frontend_active_count
```

### Rate of successful flows on the Worker
```
rate(grr_flow_completed_count_total{job="grr_worker"}[5m])
```

### Rate of failed flows on the Worker
```
rate(grr_flow_errors_total{job="grr_worker"}[5m])
```

### Threadpool latency in the Worker
```
rate(threadpool_working_time_sum{job="grr_worker"}[5m]) /
rate(threadpool_working_time_count{job="grr_worker"}[5m])
```

### Threadpool queueing time in Worker
```
rate(threadpool_queueing_time_sum{job="grr_worker"}[5m]) /
rate(threadpool_queueing_time_count{job="grr_worker"}[5m])
```

### Number of outstanding tasks in the Worker
```
threadpool_outstanding_tasks{job="grr_worker"}
```

### Number of threads running on the Worker
```
threadpool_threads{job="grr_worker"}
```

### Rate of client crashes reported to the Worker
```	
rate(grr_client_crashes_total{job="grr_worker"}[5m])
```


## Real-World Setup
Although Prometheus can display basic charts using the
[expression browser](https://prometheus.io/docs/visualization/browser/), we recommend the usage of
a dedicated visualization software, e.g.
[Grafana](https://prometheus.io/docs/visualization/grafana/). 

To set up metric-based alerts, refer to
[Prometheus Alerting](https://prometheus.io/docs/alerting/overview/) and
[Grafana Alerting](https://grafana.com/docs/grafana/latest/alerting/).

Prometheus supports automatic
[Service Discovery](https://prometheus.io/docs/prometheus/latest/configuration/configuration/) for
many types of infrastructure. Depending on your hosting setup and size of your GRR installation,
this can be an improvement over manually hardcoding hostnames in the Prometheus configuration.

### Security Considerations
A minimal HTTP service, based on [prometheus_client](https://github.com/prometheus/client_python/)
is listening at `Monitoring.http_port` for each GRR component. This HTTP service exports read-only
metrics under `/metrics` and `/varz` and does **not enforce any access control**. People with
access to it can read aggregated metrics about your GRR installation. With these metrics, facts
about the number of workers, flow activity, and service health can be derived. Make sure to limit
access to the port, for example by employing a firewall. Furthermore, read
[Prometheus Security](https://prometheus.io/docs/operating/security/).
