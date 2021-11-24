# Installing from a release server deb (recommended)

This is the recommended way of installing the GRR server components. GRR server
debs are built for Ubuntu 18.04 Bionic (x86-64). They may install on Debian or other
Ubuntu versions, but compatibility is not guaranteed.

1. MySQL is GRR's default database backend, and should be up and running
before installing GRR. The database framework can be run alongside GRR on the
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

2. Download the latest server deb from <https://github.com/google/grr/releases>:

    ```bash
    wget https://storage.googleapis.com/releases.grr-response.com/grr-server___GRR_DEB_VERSION___amd64.deb
    ```

3. Install the server deb, along with its dependencies, like below:

    ```bash
    sudo apt install -y ./grr-server___GRR_DEB_VERSION___amd64.deb
    ```

    The installer will prompt for a few pieces of information to get things set up.
    After successful installation, the `grr-server` and `fleetspeak-server` services should be running:

    ```bash
    root@grruser-bionic:/home/grruser# systemctl status grr-server
    ● grr-server.service - GRR Service
       Loaded: loaded (/lib/systemd/system/grr-server.service; enabled; vendor preset: enabled)
       Active: active (exited) since Wed 2017-11-22 10:16:39 UTC; 2min 51s ago
         Docs: https://github.com/google/grr
      Process: 10404 ExecStart=/bin/systemctl --no-block start grr-server@admin_ui.service grr-server@frontend.service grr-server@worker.service grr-server@worker2.service (code=exited, status=0/SUCCESS)
     Main PID: 10404 (code=exited, status=0/SUCCESS)
        Tasks: 0
       Memory: 0B
          CPU: 0
       CGroup: /system.slice/grr-server.service

    Nov 22 10:16:39 grruser-bionic systemd[1]: Starting GRR Service...
    Nov 22 10:16:39 grruser-bionic systemd[1]: Started GRR Service.

		root@grruser-bionic:/home/grruser# systemctl status fleetspeak-server
		● fleetspeak-server.service - Fleetspeak Server Service
			 Loaded: loaded (/lib/systemd/system/fleetspeak-server.service; disabled; vendor preset: enabled)
			 Active: active (running) since Thu 2021-08-12 18:35:13 UTC; 4s ago
				 Docs: https://github.com/google/fleetspeak
		 Main PID: 3555 (fleetspeak-serv)
				Tasks: 7 (limit: 4666)
			 CGroup: /system.slice/fleetspeak-server.service
							 └─3555 /usr/bin/fleetspeak-server --services_config /etc/fleetspeak-server/server.services.config --components_config /etc/fleetspeak-server/server.components.config

		Aug 12 18:35:13 grruser-bionic systemd[1]: Started Fleetspeak Server Service.
    ```

    In addition, administrative commands for GRR, e.g `grr_console` and
    `grr_config_updater` should be available in your PATH.
