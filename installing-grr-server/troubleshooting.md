# Troubleshooting ("GRR server doesn't seem to run")

This page describes common issues encountered when installing the GRR
server components.

## ImportError: cannot import name jobs_pb2 or similar

If you see "ImportError: cannot import name jobs_pb2" or a similar error for any
other _pb2 file, you need to regenerate the protobuf files. Just run

```bash
python setup.py build
sudo python setup.py install
```

## The upstart/init.d scripts show no output

When I run an init.d script e.g. "/etc/init.d/grr-http-server start" it does not
show me any output.

Make sure that the "START" parameter in the corresponding default file,
e.g. "/etc/default/grr-http-server", has been changed to "yes".

## I cannot start any/some of the GRR services using the init.d scripts

When I run an init.d script e.g. "/etc/init.d/grr-http-server start" it
indicates it started the service although when I check with
"/etc/init.d/grr-http-server status" it says it is not running.

You can troubleshoot by running the services in the foreground, e.g. to run the
HTTP Front-end server in the foreground:

```bash
sudo grr_server --start_http_server --verbose
```

## Any/some of the GRR services are not running correctly

Check if the logs contain an indication of what is going wrong.

Troubleshoot by running the services in the foreground, e.g. to run the UI in
the foreground:

```bash
sudo grr_server --verbose --start_ui
```

## Cannot open libtsk3.so.3

error while loading shared libraries: libtsk3.so.3: cannot open shared object
file: No such file or directory

The libtsk3 library cannot be found in the ld cache. Check if the path to
libtsk3.so.3 is in /etc/ld.so.conf (or equivalent) and update the cache:

```bash
sudo ldconfig
```

## Protobuf
Travis jobs for GRR's github repository use
[this](https://github.com/google/grr/blob/master/travis/install_protobuf.sh)
script to install protobuf. Older versions of protobuf may not be compatible
with the GRR version you are trying to install.
