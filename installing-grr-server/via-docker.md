# Installing via GRR Docker image

The GRR Docker image is currently intended for evaluation/testing use, but
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
  -e EXTERNAL_HOSTNAME=localhost \
  -e ADMIN_PASSWORD=demo \
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

### Advanced usage

#### Using configs on the host

The default config directory for GRR's server installation, specified by
the config option `Config.directory`, is
`/usr/share/grr-server/install_data/etc` (**inside** the container). You can
mount a directory on the host system over that directory, effectively
overriding the directory inside the container. Any changes made by GRR inside
that directory (notably, creating and modifying the server writeback file) will
be reflected on the host instead of inside the container. Here's how to
accomplish that:

1. Copy over the initial configs for the server installation from GRR's image
to the host's filesystem:
    ```bash
    mkdir ~/grr-docker

    docker create --name grr-server grrdocker/grr:v__GRR_VERSION__

    docker cp grr-server:/usr/share/grr-server/install_data/etc ~/grr-docker

    docker rm grr-server
    ```

1. Start a new container as usual with the command given previously, but with
this extra argument:

    ```bash
    -v ~/grr-docker/etc:/usr/share/grr-server/install_data/etc
    ```

#### Logging to the host

Note that verbose logging is disabled by default. You can enable verbose
logging by setting `Logging.verbose` in `grr-server.yaml`
(the primary GRR config) to `True` after copying the file to the host as
described above.

The default server logging directory, specified by the config option
`Logging.path`, is
`/usr/share/grr-server/lib/python2.7/site-packages/grr_response_core/var/log/`.
As with overriding the config directory used by GRR, you can mount a directory
on the host over that directory, like below:

```bash
-v /var/log/grr:/usr/share/grr-server/lib/python2.7/site-packages/grr_response_core/var/log
```

#### Using the host's MySQL instance.

By default, GRR is configured to connect to a MySQL instance that is
already installed in the container. An easy way of setting up the GRR container
to connect to an external MySQL instance instead involves enabling
[host networking](https://docs.docker.com/network/host/), by setting the
`docker run` argument `--network` to `host`. In addition, you should set
the following environment variables:

- `DISABLE_INTERNAL_MYSQL` to `true` (lowercase)
- `GRR_MYSQL_HOSTNAME` to `127.0.0.1`
- `GRR_MYSQL_PASSWORD` to the password of the DB user GRR will use, which by
default is `root`.

Here's an example:

    ```bash
    docker run \
      --name grr-server \
      --network host \
      -e EXTERNAL_HOSTNAME=localhost \
      -e ADMIN_PASSWORD=demo \
      -e DISABLE_INTERNAL_MYSQL=true \
      -e GRR_MYSQL_HOSTNAME=127.0.0.1 \
      -e GRR_MYSQL_PASSWORD="${ROOT_MYSQL_PASS}" \
       grrdocker/grr:v__GRR_VERSION__
    ```

It is worth noting that `host` networking disables publishing of ports,
which is why the `-p` arguments are left out from the command above.

If host networking is not an option (e.g for non-Linux hosts), you need
to configure the MySQL installation on the host to allow connections from
Docker before starting the container.

Besides the environment variables given above, other
MySQL-related variables that can be specified include
`GRR_MYSQL_PORT` (default **0**), `GRR_MYSQL_DB` (default **grr**), and
`GRR_MYSQL_USERNAME` (default **root**).

Note that if you’re running boot2docker on OS X there are a few bugs with
[docker itself](https://github.com/boot2docker/boot2docker/issues/824) that you
will probably need to work around. You’ll likely have to set up port forwards
for 8000 and 8080 as described
[here](https://github.com/boot2docker/boot2docker/blob/master/doc/WORKAROUNDS.md).

## Interactive mode

GRR containers can be started interactively with:

```bash
docker run -it grrdocker/grr:v__GRR_VERSION__ /bin/bash
```

GRR gets installed into a virtualenv in
`/usr/share/grr-server`. Thus, the easiest way to run any of the GRR binaries
inside the Docker container is by first activating the virtualenv:

```bash
source /usr/share/grr-server/bin/activate
```

After that, commands such as `grr_server`, `grr_config_updater`, `grr_console`,
etc become available in the PATH.

## Building custom docker images (Advanced)

It is advisable to read GRR's
[Dockerfile](https://github.com/google/grr/blob/master/Dockerfile) in order to
get an understanding of how GRR's CI workflows build docker images before
attempting this.

1. Check out GRR's source code:

    ```bash
    git clone https://github.com/google/grr
    ```

1. Make the changes you want to make to the Dockerfile, or related scripts.
It is important to note that by default, GRR gets installed in the image from
pre-built pip sdists hosted in Google Cloud Storage (so client or server code
changes you make in your local repository will not be applied to the custom
image).

1. Identify the commit for which you would like to fetch pre-built client
and server pip sdists. For HEAD, that would be the output of:

    ```bash
    git rev-parse HEAD
    ```

1. cd to the root of GRR's repository if not already there, then build your
custom image with:

    ```bash
    docker build \
      -t grrdocker/grr:custom \
      --build-arg GCS_BUCKET=autobuilds.grr-response.com \
      --build-arg GRR_COMMIT=${GRR_COMMIT_SHA} \
      .
    ```

    The image above will be tagged `grrdocker/grr:custom`, but you are free to
use whatever tag you like.
