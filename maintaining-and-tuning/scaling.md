## Scaling GRR within a single server

For 3.1.0 and later, use a [systemd drop-in
override](http://askubuntu.com/questions/659267/how-do-i-override-or-configure-systemd-services)
to control how many copies of each component you run on each machine.
This can initially be done using:

```docker
sudo systemctl edit grr-server
```

which creates "/etc/systemd/system/grr-server.service.d/override.conf".
You’ll want to turn this into a template file and control via puppet or
similar. An example override that just runs 3 workers looks like:

    [Service]
    ExecReload=
    ExecReload=/bin/systemctl --no-block reload grr-server@worker.service grr-server@worker2.service grr-server@worker3.service
    ExecStart=
    ExecStart=/bin/systemctl --no-block start grr-server@worker.service grr-server@worker2.service grr-server@worker3.service
    ExecStop=
    ExecStop=/bin/systemctl --no-block stop grr-server@worker.service grr-server@worker2.service grr-server@worker3.service

When starting multiple copies of the UI and the web frontend you also
need to tell GRR which ports it should be using. So if you want 10 http
frontends on a machine you would configure your systemd drop-in to start
10 copies and then set Frontend.port\_max so that you have a range of 10
ports from Frontend.bind\_port. (I.E. set Frontend.bind\_port to 8080
and Frontend.port\_max to 8089) You can then configure your load
balancer to distribute across that port range. AdminUI.port\_max works
the same way for the UI.

## Large Scale Deployment

The [GRR server components](implementation.md#grr-component-overview)
should be distributed across multiple machines in any deployment where
you expect to have more than a few hundred clients, or even smaller
deployments if you plan on doing intensive hunting. The performance
needs of the various components are discussed
below, and some real-world example
deployment configurations are [described in the FAQ](../faq.md).

You should install the GRR package on all machines and use configuration
management (chef, puppet etc.) to:

  - Distribute the same grr-server.yaml to each machine

  - Control how many of each component to run on each machine (see next
    section for details)

For scaling the fleetspeak communication framework, see [the instructions in
the fleetspeak section](../fleetspeak/scaling.md).


## Component Performance Needs

  - **Worker**: you will probably want to run more than one worker. In a
    large deployment where you are running numerous hunts it makes sense
    to run 20+ workers. As long as the datastore scales, the more
    workers you have the faster things get done. We previously had a
    config setting that forked worker processes off, but this turned out
    to play badly with datastore connection pools, the stats store, and
    monitoring ports so it was removed.

  - **HTTP frontend**: The frontend http server can be a significant
    bottleneck. By default we ship with a simple http server, but this
    is single process, written in python which means it may have thread
    lock issues. To get better performance you will need to run multiple
    instances of the HTTP frontend behind a reverse HTTP proxy (i.e. Apache
    or Nginx). Assuming your datastore handles it, these should scale
    linearly.

  - **Web UI**: The admin UI component is usually under light load, but
    you can run as many as you want for redundancy (you'll need to run them
    behind Apache or Nginx to load-balance the traffic). The more concurrent
    GRR users you have, the more instances you need. This is also the
    API server, so if you intend to use the API heavily run more.
