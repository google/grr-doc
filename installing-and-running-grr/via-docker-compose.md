# Running GRR in a Docker Compose Stack (Recommended)

Running GRR via docker compose will start every [GRR component](<overview.md>) in a separate Docker container. 
All that is needed is install docker, docker compose and git, then get the code, generate certificates and start the stack.
Follow the instructions below!


## Setup the environment
- [Install Docker](#install-docker)
- [Install docker compose](#install-docker-compose)
- [Install Git](#install-git)
- [Clone the GRR repository](#clone-the-grr-repository)
- [Generate certificates and keys](#generate-certificates-and-keys)

### Install docker
Ensure that you have a recent version of ```docker``` installed. You will need a minimum version of ```19.03.0+```.

Version ```20.10``` is well tested, and has the benefit of included ```compose```.
The user account running the examples will need to have permission to use Docker on your system.

Full instructions for installing Docker can be found on the [Docker website](https://docs.docker.com/get-docker/).  

### Install docker compose
The examples use [Docker compose configuration version 3.8](https://docs.docker.com/compose/compose-file/compose-versioning/#version-38).

You will need to a fairly recent version of [Docker Compose](https://docs.docker.com/compose/).  

### Install Git
The GRR repository is managed using [Git](https://git-scm.com/).

You can [find instructions for installing Git on various operating systems here](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git).  

### Clone the GRR repository
If you have not cloned the GRR repository already, clone it with:

```
git clone https://github.com/google/grr
```

### Generate certificates and keys 

Running the following script will generate a set of keys and certificates required for running the docker compose stack.
This step is only needed on initial startup as the keys are persisted.

```
./docker_config_files/init_certs.sh
```
This script writes all necessary keys as `.pem` files to disk they can be found in the `docker_config_files`
folder. The [GRR code signing keys](<../maintaining-and-tuning/key-management/which-keys-and-how.html#communication-security>)
are read directly from the generated files when the docker compose stack is running.
The [fleetspeak communication keys and certificates](<../maintaining-and-tuning/key-management/which-keys-and-how.html#communication-security>)
however replace placeholders in the fleetspeak config files when executing this script.
As a consequence running the script a second time will only replace the GRR code signing keys. 

More context about the keys and certs can be found in the [key management docs](<../maintaining-and-tuning/key-management/index.md>).


## Run the GRR Docker Compose Stack

### Starting the Stack

```bash
docker compose up -d
```
(From the main grr folder containing the `compose.yaml`)
This will download all images and start the stack.

When all services are started/healthy you can access the UI in your browser via the following URL:
```
127.0.0.1:8000
```

The port 8000 is forwarded from the compose stack, if this port is already used on your system,
update the docker-compose file in the `ports` secion of the `grr-admin-ui` service.

Try searching for any client by searching for `.`, this should show one online client. 


### Stopping the Stack

```bash
docker compose down
```
(From the main grr folder containing the `compose.yaml`)
Stops all running containers. 

The stack uses mounted volumes to persist state , to also delete these run:

```bash
docker compose down --volumes
```

### Debugging

- You can access the **logs** via:
  ```
  docker compose logs <optional container names>
  ```

- To see all **running containers** you can run:
  ```
  docker ps
  ```
  This should show one container for every listed `service` in the `compose.yaml` file.

-  **Connect to a container**:
   ```
   docker exec -it <container name> /bin/bash
   ```
   The container names for every service can be found under `container_name` in the
   `compose.yaml` file or in the output of `docker ps`.


- To inspect the **database** you can connect to the mysql database via
  ```bash
  mysql -h localhost -P 3306 -u grru -pgrrp grr
  ```
  Username, password and DB name for the mysql database can also be found in
   `docker_config_files/mysql/.env`.

## Repacking Client Installers

The client templates need to be repacked into installer to be installed on a
client. The repacking adds some configuration to the templates that is
provided by the GRR server and needs to be available before startup.

In the docker compose stack, the templates are
[repacked](https://github.com/google/grr/blob/master/docker_config_files/server/repack_clients.sh)
using the [server config files](https://github.com/google/grr/blob/master/docker_config_files/server/grr.server.yaml)
in the grr-admin-ui container on startup and stored in a mounted volume.
The client container has access to the same volume and starts up and
[installs the created installer](https://github.com/google/grr/blob/master/docker_config_files/client/install_client.sh)
whenever repacking is completed.


## Setting up your own MySQL database

MySQL is GRR's default database backend, and should be up and running
before starting GRR server components. The database framework can be run alongside GRR on the
same machine, or on a remote machine. Here's how you would install the
community edition of MySQL from Ubuntu repositories:

```bash
apt install -y mysql-server
```

If you have never installed MySQL on the machine before, you will be
prompted for a password for the 'root' database user. After installation
completes, you need to change the `max_allowed_packet` setting, otherwise
GRR will have issues writing large chunks of data to the database. Put
the following into `/etc/mysql/my.cnf`:

```
[mysqld]
max_allowed_packet=40M
log_bin_trust_function_creators=1
```

Then restart the MySQL server:

```
service mysql restart
```

You will typically want to create a new database
user for GRR and give that user access an empty database that
the GRR server installation will use:

```bash
mysql -u root -p
```

```bash
mysql> CREATE USER 'grr'@'localhost' IDENTIFIED BY 'password';

mysql> CREATE DATABASE grr;

mysql> GRANT ALL ON grr.* TO 'grr'@'localhost';

mysql> CREATE USER 'fleetspeak'@'localhost' IDENTIFIED BY 'password';

mysql> CREATE DATABASE fleetspeak;

mysql> GRANT ALL ON fleetspeak.* TO 'fleetspeak'@'localhost';
```
Please note: GRR is senstive to the MySQL's `max_allowed_packet` setting.
Make sure it's not lower than 20971520. Creation of a new user is optional
though since GRR can use the credentials of the root user to connect to
MySQL.

The MysSQL database needs to be accessible from the docker compose stack.
Then adjust the config files in the `docker_config_files/` directory to be able to connect to your database.
And remove the database from the docker compose stack.
