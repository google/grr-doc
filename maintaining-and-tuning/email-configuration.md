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

## Custom Email addresses

When GRR sends an Email to a GRR user, the destination Email address defaults to `<username>@<Logging.domain>`. Starting with version [3.4.2.0](https://grr-doc.readthedocs.io/en/latest/release-notes.html#july-06-2020), GRR can alternatively use custom Email addresses. In this mode, GRR will store a separate Email address for each user in the data store. To enable this mode, set the following option in the GRR config:


```yaml
Email.enable_custom_email_address: true
```

The value of the custom Email addresses can be set in one of the following ways:

1. When using `RemoteUserWebAuthManager` for authentication, the Email address can be passed to GRR in the `X-Remote-Extra-Email` HTTP header. (The actual of the header is configurable using the `AdminUI.remote_email_header` option).

1. Using the GRR root API:

   ```bash
   grr_api_shell_raw_access  --exec_code "grrapi.root.CreateGrrUser(username='foo', email='foo@bar.org')"
   ```

   ```bash
   grr_api_shell_raw_access  --exec_code "grrapi.root.GrrUser('foo').Get().Modify(email='foo2@bar.org')"
   ```
