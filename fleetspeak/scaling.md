# Scaling a fleetspeak setup

The following diagram shows a standard, distributed fleetspeak setup:

<!-- https://docs.google.com/drawings/d/1BwQhwu5phznyvYd3ydUu7lIPX-NVutmTny77-jkp8u0/edit -->

![distributed fleetspeak](../images/distributed_fleetspeak.png)

The fleetspeak server setup consists of 2 components:

  - **Fleetspeak Server**: This component terminates the streaming HTTPS
    connections from the fleetspeak clients. Each fleetspeak client is
    connected to a particular server instance at a time.
  - **Fleetspeak Admin Server**: This component provides an administrative GRPC
    interface as well as an interface for the GRR server to send messages to
    clients.

Both components are included in the single binary `/usr/bin/fleetspeak-server`
and can be enabled respectively in the config file
`/etc/fleetspeak-server/server.components.config`. The binary is automatically
started by the systemd unit `fleetspeak-server`.

In the legacy GRR protocol, clients would periodically poll the server for
messages, leading to delays in message delivery. Fleetspeak on the other hand
uses persistent, streaming connections and thus can deliver messages without a
significant delay. For this mechanism to work, a simple, HTTP based
notification protocol between the server an admin server is necessary: if the
admin server submits a message for a particular client, it notifies the
respective server so that the server immediately delivers the message to the
client.

To run a fleetspeak in a distributed setup:

  - Install the GRR release deb on all machines.

  - Take the files `/etc/fleetspeak-server/server.services.config` and
    `/etc/fleetspeak-server/server.components.config` from a working
    installation, adapt them and distribute them to the target machines.

## Running the Fleetspeak Server component

To run a server component, keep the `https_config` section and remove the
`admin_config` section in the file
`/etc/fleetspeak-server/server.components.config`.

Add 2 more config options:

  - `notification_listen_address`: the IP address and port on which the server
    listens for notifications from the admin server.  This port is not meant
    to be publicly accessible, but will need to be reachable from other servers.

  - `notification_public_address` the IP address and port advertised to other servers.

The final config should look like:

```
mysql_data_source_name: "[...]"
https_config: <
  listen_address: "192.168.1.83:4443"
  certificates: "-----BEGIN CERTIFICATE-----\n [...]"
  key: "-----BEGIN EC PRIVATE KEY----- [...]"
>
notification_listen_address: "192.168.1.83:10000"
notification_public_address: "192.168.1.83:10000"
```

Next, configure a TCP/IP load balancer balancing traffic to the port specified
in `https_config.listen_address` on the respective server instances.

In case that your load balancer removes the client's IP address (i.e.
fleetspeak sees connections originating from the load balancer's IP), it's
recommended to use the [PROXY
protocol](https://www.haproxy.org/download/2.3/doc/proxy-protocol.txt). In this
case, add one more option in the file
`/etc/fleetspeak-server/server.components.config`:

```
proxy_protocol: true
```

To make GRR/fleetspeak clients use the distributed fleetspeak setup, run
`sudo grr_config_updater initialize` to repack the GRR clients. If the load balancer
listens on `1.2.3.4:4443`, answer the fleetspeak related questions as follows:

```
Use Fleetspeak (next generation communication framework)? [yN]:  [N]: y
Please enter your hostname e.g. grr.example.com [grr-server]: 1.2.3.4
Fleetspeak public HTTPS port [4443]: 4443
```

## Running the Fleetspeak Admin Server component

To run the admin server component, keep the `admin_config` section and remove
the `https_config` section in the file
`/etc/fleetspeak-server/server.components.config`.

Add one more config option:

  - `notification_use_http_notifier`: enables usage of the HTTP based notification protocol.

The final config should like:

```
mysql_data_source_name: "[...]"
admin_config: <
  listen_address: "192.168.1.83:4444"
>
notification_use_http_notifier:true
```

Next, configure a TCP/IP load balancer balancing traffic to the port specified
in `admin_config.listen_address` on the respective admin server instances.

To make the GRR server use the distributed admin server setup, edit the config
file `/etc/grr/server.local.yaml`. If the load balancer listens on
`1.2.3.4:4444`, set the following config option:

```
Server.fleetspeak_server: 1.2.3.4:4444
```
