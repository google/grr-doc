# Docker Images
The recommended way to run the Docker containers is running them in the
provided [Docker Compose setup](<via-docker-compose.md>).

## GRR Docker Image

The GRR Docker image is available in the Github container registry of the GRR repository: [https://github.com/google/grr/pkgs/container/grr](https://github.com/google/grr/pkgs/container/grr).

The image contains binaries for all GRR server components as well as the client templates.

The client templates need to be "repacked" into installers using a configuration file.
The binary to do that is included in the image.
Installers can be created for Linux, Windows and MacOS and are standalone binaries running both GRR and Fleetspeak client components.


#### Available Binaries
Binaries to start the different GRR components, create new certificates, repack templates etc.
are included in the GRR Docker image.
All available binaries are in the `$PATH` in the Docker container and can also be found
inside the container in `/usr/share/grr-server/bin`.
Most binaries require a [configuration file](#configuration-files), which can be set with the
`-config / --config` command line argument. Also see examples in [How to use the image](#how-to-use-the-image).

##### Configuration files

GRR uses [GrrConfigManager](https://github.com/google/grr/blob/v3.4.7.2/grr/core/grr_response_core/lib/config_lib.py#L445)
which is based on [configparser](https://docs.python.org/3/library/configparser.html) to configure GRR components and binaries.
A basic configuration for [server](https://github.com/google/grr/blob/v3.4.7.4-release/docker_config_files/server/grr.server.yaml),
[client](https://github.com/google/grr/blob/v3.4.7.4-release/docker_config_files/client/grr.client.yaml) and
[e2e testing](https://github.com/google/grr/blob/v3.4.7.4-release/docker_config_files/testing/grr.testing.yaml) are provided.
They can be mounted in the container:
```bash
$ docker run -it \
    --entrypoint /bin/bash \  # open a shell
    -v $(pwd)/docker_config_files:/configs \  # mount the docker_config_files folder to /configs
    ghcr.io/google/grr:latest
```
Additional configuration options can be added, i.e. additional options for the server configuration can be found
[here](https://github.com/google/grr/blob/v3.4.7.4-release/grr/core/grr_response_core/config/server.py) for the
server or [here](https://github.com/google/grr/blob/v3.4.7.4-release/grr/core/grr_response_core/config/client.py)
for the client.
(We are working on a better documentation for the available config options.)


### Fleetspeak Docker Image

The Fleetspeak Docker image is available in the Github container registry of the Fleetspeak repository: [https://github.com/google/fleetspeak/pkgs/container/fleetspeak](https://github.com/google/fleetspeak/pkgs/container/fleetspeak).


### Versioning (Fleetspeak and GRR)
Docker containers are tagged with the version number whenever a new GRR/Fleetspeak version is released on GitHub.
Additionally, the`latest` tag is set to the image of the last released GRR version.
It is recommended to use the `latest` image to stay up to date and have a stable image.

There is also a new Docker image built every time an update is pushed to the repository, these are tagged by their branch name.
Several pushes might happen to the `master` branch between releases, which might not be stable versions,
so it is only recommended to use the `master`-tag when a all changes from the tip-of-tree should be included
and no stable version is required.


## How to use the image

- Run for example the Admin-UI server component:

```bash
$ docker run -it \
     -v /<path/to/your/grr_config.yaml>:/configs \ # <-- Mount your server configuration.
     ghcr.io/google/grr:latest \
     "-component" "admin_ui" \                     # <-- Specify the component to run.
     "-config" "/configs/grr_config.yaml"          # <-- Link the mounted configuration.
```

#### Logging to the host

Note that verbose logging is disabled by default. You can enable verbose
logging by setting `Logging.verbose` in the config file to `True`.
Additionally the logging location can be specified via different options, e.g.:

```
Logging.verbose: true
Logging.engines: file,stderr
Logging.path: /tmp/grr-client
Logging.filename: /tmp/grr-client/grr-client.log
```

To persist the logs to the host a volume/folder can be mounted to the `Logging.path` folder.

#### Connecting to a MySQL Instance Running on the Host Machine

In the Docker Compose stack a MySQL instance is running in a different Docker container running in the same network. 

To connect e.g. to an already configured MySQL instance on your host machine, you need to update the mounted config file with the connection information:

```
Mysql.host: host.docker.internal # Docker version 20.10 or above
Mysql.port: <port>
Mysql.database_name: <name>
Mysql.database_password: <password>
Mysql.database_username: <user>
Mysql.database: <name>
Mysql.password: <password>
Mysql.username: <user>
```

If host networking is not an option (e.g for non-Linux hosts), you need
to configure the MySQL installation on the host to allow connections from
Docker before starting the container.


## Note
Note that if you’re running boot2docker on OS X there are a few bugs with
[Docker itself](https://github.com/boot2docker/boot2docker/issues/824) that you
will probably need to work around. You’ll likely have to set up port forwards
for 8000 and 8080 as described
[here](https://github.com/boot2docker/boot2docker/blob/master/doc/WORKAROUNDS.md).

## Interactive mode

GRR containers can be started interactively with:

```bash
docker run -it ghcr.io/google/grr:v__GRR_VERSION__ /bin/bash
```

## Building custom Docker images (Advanced)

It is advisable to read GRR's
[Dockerfile](https://github.com/google/grr/blob/master/Dockerfile) in order to
get an understanding of how GRR's CI workflows build Docker images before
attempting this.

1. Check out GRR's source code:

    ```bash
    git clone https://github.com/google/grr
    ```

1. Make the changes you want to make to the Dockerfile, or related scripts.
GRR gets installed from the local checkout, so any changes you make will
take effect after *rebuilding* the image.
GRR is installed with pip's editable mode on a copy of the code, so any code changes you make inside
the container take effect in the running container, but are not persisted
when the container stops.

1. `cd` to the root of GRR's repository if not already there, then build your
custom image with:

```bash
docker build \
  -t ghcr.io/google/grr:custom \
  .
```

The image above will be tagged `ghcr.io/google/grr:custom`, but you are
free to use whatever tag you like.
