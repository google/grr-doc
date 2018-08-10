# Installing from a release server deb (recommended)

This is the recommended way of installing the GRR server components. GRR server
debs are built for Ubuntu Xenial. They may install on Debian or other Ubuntu
versions, but compatibility is not guaranteed.

1. MySQL is GRR's default database backend, and should be up and running
before installing GRR. The database framework can be run alongside GRR on the
same machine, or on a remote machine. Here's how you would install the
community edition of MySQL from Ubuntu repositories:

    ```bash
    apt install -y mysql-server
    ```

    If you have never installed MySQL on the machine before, you will be
    prompted for a password for the 'root' database user. Typically, you will
    want to create a new database user for GRR afterwards and give that user
    access an empty repository that the GRR server installation will use.
    However, if you want, you may provide the credentials for the root
    user to GRR instead.

2. Download the latest server deb from <https://github.com/google/grr/releases>:

    ```bash
    wget https://storage.googleapis.com/releases.grr-response.com/grr-server___GRR_DEB_VERSION___amd64.deb
    ```

3. Install the server deb, along with its dependencies, like below:

    ```bash
    sudo apt install -y ./grr-server___GRR_DEB_VERSION___amd64.deb
    ```

    The installer will prompt for a few pieces of information to get things set up.
    After successful installation, the `grr-server` service should be running:

    ```bash
    root@grruser-xenial:/home/grruser# systemctl status grr-server
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

    Nov 22 10:16:39 grruser-xenial systemd[1]: Starting GRR Service...
    Nov 22 10:16:39 grruser-xenial systemd[1]: Started GRR Service.
    ```

    In addition, administrative commands for GRR, e.g `grr_console` and
    `grr_config_updater` should be available in your PATH.
