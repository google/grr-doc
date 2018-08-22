# Installing via GRR Docker image

The GRR Docker image is is currently intended for evaluation/testing use, but
the plan is to support simple cloud deployment of a stable production image in
the future.

The instructions below get you a recent stable docker image. We also build an
[image](https://registry.hub.docker.com/u/grrdocker/grr/) automatically from the
latest commit in the github repository which is more up-to-date but isn’t
guaranteed to work. If you want bleeding edge you can use `grrdocker/grr:latest`
in the commands below.

## How to use the image

```bash
docker run \
  --name grr-server \
  -e EXTERNAL_HOSTNAME="localhost" \
  -e ADMIN_PASSWORD="demo" \
  -p 0.0.0.0:8000:8000 -p 0.0.0.0:8080:8080 \
  grrdocker/grr:v__GRR_VERSION__
```

Once initialization finishes point your web browser to localhost:8000 and login
with admin:demo. Follow the final part of the [quickstart](../quickstart.md)
instructions to download and install the clients.

EXTERNAL_HOSTNAME is the hostname you want GRR agents (clients) to poll back
to, “localhost” is only useful for testing.

ADMIN_PASSWORD is the password for the “admin” user in the webui.

The container will listen on port 8000 for the admin web UI and port 8080 for
client polls.

By default, GRR will be configured to connect to a MySQL instance that is
already installed in the container. If you would like to connect to a MySQL
instance running on the host instead (and have GRR's config's and data
persist beyond the life of the container) here's how you would go about it:

1. Copy over the initial configs for the server installation from GRR's image
to the host's filesystem:
    ```bash
    mkdir ~/grr-docker

    docker create --name grr-server grrdocker/grr:v__GRR_VERSION__

    docker cp grr-server:/usr/share/grr-server/install_data/etc ~/grr-docker

    docker rm grr-server
    ```

1. When started with [host networking](https://docs.docker.com/network/host/),
the container should be able to communicate with the host's MySQL instance:

    ```bash
    docker run \
      --network host \
      -e EXTERNAL_HOSTNAME="localhost" \
      -e ADMIN_PASSWORD="demo" \
      -e DISABLE_INTERNAL_MYSQL=true \
      -e GRR_MYSQL_HOSTNAME=127.0.0.1 \
      -e GRR_MYSQL_PASSWORD="${ROOT_MYSQL_PASS}" \
      -v ~/grr-docker/etc:/usr/share/grr-server/install_data/etc \
       grrdocker/grr:v__GRR_VERSION__
    ```

   If host networking is not an option (e.g for non-Linux hosts), you need
to configure the MySQL installation on the host to allow connections from
Docker before starting the container.

   Besides the environment variables given above, other
MySQL-related variables that can be specified include
`GRR_MYSQL_PORT` (default *0*), `GRR_MYSQL_DB` (default *grr*), and
`GRR_MYSQL_USERNAME` (default *root*).

Note that if you’re running boot2docker on OS X there are a few bugs with
[docker itself](https://github.com/boot2docker/boot2docker/issues/824) that you
will probably need to workaround. You’ll likely have to set up port forwards
for 8000 and 8080 as described
[here](https://github.com/boot2docker/boot2docker/blob/master/doc/WORKAROUNDS.md).

## Interactive mode

GRR containers can be started interactively with:

```bash
docker run -it grrdocker/grr:v__GRR_VERSION__ /bin/bash
```

GRR gets installed into a virtualenv in
`/usr/share/grr-server`. Thus, the easiest way to run any of the GRR binaries
inside the Docker container is to activate the virtualenv:

```bash
source /usr/share/grr-server/bin/activate
```

After that, commands such as `grr_server`, `grr_config_updater`, `grr_console`,
etc become available in the PATH.
