# Running GRR UI behind Apache

Running apache as a reverse proxy in front of the GRR admin UI is a good
way to provide SSL protection for the UI traffic and also integrate with
corporate single sign on (if available), for authentication.

To set this up:

- Buy an SSL certificate, or generate a self-signed one if you’re only
testing.

- Place the public key into “/etc/ssl/certs/“ and ensure it’s world
readable

```docker
chmod 644 /etc/ssl/certs/grr_ssl_certificate_filename.crt
```

- Place the private key into “/etc/ssl/private” and ensure it is **NOT**
world readable

```docker
chmod 400 /etc/ssl/private/grr_ssl_certificate_filename.key
```

- Install apache2 and required modules

```docker
apt-get install apache2
a2enmod proxy
a2enmod ssl
a2enmod proxy_http
```

- Disable any default apache files currently enabled (probably
000-default.conf, but check for others that may interfere with GRR)

```docker
a2dissite 000-default
```

- Redirect port 80 HTTP to 443 HTTPS

- Create the file "/etc/apache2/sites-available/redirect.conf" and copy
the text below into it.

```docker
    <VirtualHost *:80>
        Redirect "/" "https://<your grr adminUI url here>"
    </VirtualHost>
```

- Create the file "/etc/apache2/sites-available/grr\_reverse\_proxy.conf"
and copy the text below into it.

```docker
<VirtualHost *:443>
SSLEngine On
SSLCertificateFile /etc/ssl/certs/grr_ssl_certificate_filename.crt
SSLCertificateKeyFile /etc/ssl/private/grr_ssl_certificate_filename.key
ProxyPass / http://127.0.0.1:8000/
ProxyPassReverse / http://127.0.0.1:8000/
</VirtualHost>
```

- Enable the new apache files

```docker
a2ensite redirect.conf
a2ensite grr_reverse_proxy.conf
```

- Restart apache

```docker
service apache2 restart
```

**NOTE**: This reverse proxy will only proxy the AdminUI. It will have
    no impact on the agent communications on port 8080. It is advised to
    restrict access to the AdminUI at the network level.
