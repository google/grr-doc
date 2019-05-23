# Email configuration

This section assumes you have already installed an MTA, such as [Postfix](http://www.postfix.org/) or [nullmailer](http://untroubled.org/nullmailer/).  After you have successfully tested your mail transfer agent, please proceed to the steps outlined below.

To configure GRR to send emails for reports or other purposes:

Ensure email settings are correct by running back through the configuration script if needed (or by checking `/etc/grr/server.local.yaml`):

``` bash
grr_config_updater initialize
```

Edit ```/etc/grr/server.local.yaml``` to include the following at the end of the file:

``` yaml
Worker.smtp_server: <server>
Worker.smtp_port: <port>
```

and, if needed,

``` yaml
Worker.smtp_starttls: True
Worker.smtp_user: <user>
Worker.smtp_password: <password>
```

After configuration is complete, restart the GRR worker(s). You can test this configuration by running *OnlineNotification" flow on any of the online clients (in the "Administrative" category). This flow sends an email to a given email address as soon as the client goes online. If the client is already online, the email will be sent next time it checks in (normally within 10 minutes).
