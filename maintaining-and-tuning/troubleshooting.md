# Troubleshooting
Please check the output of your system's service logs and/or GRR logging directory (default: 
`/usr/share/grr-server/lib/python2.7/site-packages/grr_response_core/var/log/`) for more information regarding failures.

## The upstart/init.d scripts show no output

When I run an init.d script e.g. "/etc/init.d/grr-http-server start" (deprecated) it
does not show me any output.

Make sure that the "START" parameter in the corresponding default file,
e.g. "/etc/default/grr-http-server", has been changed to "yes".

## I cannot start any/some of the GRR services using the service scripts

When I run an init.d script e.g. "/etc/init.d/grr-http-server start" (deprecated) it
indicates it started the service although when I check with
"/etc/init.d/grr-http-server status" it says it is not running.

You can troubleshoot by running the services in the foreground, e.g. to
run the HTTP Front-end server in the foreground:

``` bash
sudo grr_server --component [frontend|adminui|worker] --verbose
```

## Any/some of the GRR services are not running correctly

Check if the logs contain an indication of what is going wrong.

Troubleshoot by running the services in the foreground, e.g. to run the
UI in the foreground:

``` bash
sudo grr_server --component [frontend|adminui|worker] --verbose
```
## deprecated


## Cannot open libtsk3.so.3

error while loading shared libraries: libtsk3.so.3: cannot open shared
object file: No such file or directory

The libtsk3 library cannot be found in the ld cache. Check if the path
to libtsk3.so.3 is in /etc/ld.so.conf (or equivalent) and update the
cache:

``` bash
sudo ldconfig
```
