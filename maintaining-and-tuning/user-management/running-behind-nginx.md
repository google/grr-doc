# Running GRR behind Nginx

Running NGINX as a reverse proxy in front of GRR web UI is a good
way to provide SSL protection for the UI traffic and also integrate with
corporate single sign on system (if available), for authentication.


The instruction below is largely based on this excellent tutorial by Josh Reichardt: [How To Configure Nginx with SSL as a Reverse Proxy for Jenkins](https://www.digitalocean.com/community/tutorials/how-to-configure-nginx-with-ssl-as-a-reverse-proxy-for-jenkins)

Instructions below assume that you have a user capable of sudo-access and that you have GRR server already installed.

## Step One - Configure Nginx

### Install Nginx

Update your package lists and install Nginx:

``` bash
sudo apt-get update
sudo apt-get install nginx
```

You may want to check Nginx's version in case you run into issues later down the road.


``` bash
nginx -v
```

### Get a Certificate

Next, you will need to purchase or create an SSL certificate. These commands are for a self-signed certificate, but you should get an officially signed certificate if you want to avoid browser warnings.

Move into the proper directory and generate a certificate:

``` bash
cd /etc/nginx
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/cert.key -out /etc/nginx/cert.crt
```

You will be prompted to enter some information about the certificate. You can fill this out however you'd like; just be aware the information will be visible in the certificate properties. We've set the number of bits to 2048 since that's the minimum needed to get it signed by a CA. If you want to get the certificate signed, you will need to create a CSR.

### Edit the Configuration

Next, edit the default Nginx configuration file: */etc/nginx/sites-enabled/default*

Here is what the final config might look like; the sections are broken down and briefly explained below. You can update or replace the existing config file, although you may want to make a quick copy first.

``` text
server {
    listen 80;
    return 301 https://$host$request_uri;
}

server {

    listen 443;
    server_name localhost;

    ssl_certificate           /etc/nginx/cert.crt;
    ssl_certificate_key       /etc/nginx/cert.key;

    ssl on;
    ssl_session_cache  builtin:1000  shared:SSL:10m;
    ssl_protocols  TLSv1 TLSv1.1 TLSv1.2;
    ssl_ciphers HIGH:!aNULL:!eNULL:!EXPORT:!CAMELLIA:!DES:!MD5:!PSK:!RC4;
    ssl_prefer_server_ciphers on;

    access_log            /var/log/nginx/grr.access.log;

    location / {

      proxy_set_header        Host $host;
      proxy_set_header        X-Real-IP $remote_addr;
      proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header        X-Forwarded-Proto $scheme;

      # Fix the “It appears that your reverse proxy set up is broken" error.
      proxy_pass          http://localhost:8000;
      proxy_read_timeout  180;

      proxy_redirect      http://localhost:8000 https://localhost;
    }
}
```

In our configuration, the *cert.crt* and *cert.key* settings reflect the location where we created our SSL certificate.

The first section tells the Nginx server to listen to any requests that come in on port 80 (default HTTP) and redirect them to HTTPS.

``` text
server {
   listen 80;
   return 301 https://$host$request_uri;
}
```

*servername* and *proxyredirect* settings assume that you run Nginx on the same host with the GRR web UI server. This is suitable for demo purposes, but in a real-world scenario you may want to host Nginx and GRR processes on different machines and replace *localhost* inside *servername* and *proxyredirect* with your Nginx server's IP address or its intranet domain name.

**NOTE**: even when running behind a SSL-enabled Nginx server with authentication turned on, GRR web UI shouldn't be exposed to the Internet. Whoever has access to it has a root-level access to client machines in your GRR deployment.

Next we have the SSL settings. This is a good set of defaults but can definitely be expanded on. For more explanation, please read this [tutorial](https://www.digitalocean.com/community/tutorials/how-to-create-an-ssl-certificate-on-nginx-for-ubuntu-14-04).

``` text
...
  listen 443;
  server_name jenkins.domain.com;

  ssl_certificate           /etc/nginx/cert.crt;
  ssl_certificate_key       /etc/nginx/cert.key;

  ssl on;
  ssl_session_cache  builtin:1000  shared:SSL:10m;
  ssl_protocols  TLSv1 TLSv1.1 TLSv1.2;
  ssl_ciphers HIGH:!aNULL:!eNULL:!EXPORT:!CAMELLIA:!DES:!MD5:!PSK:!RC4;
  ssl_prefer_server_ciphers on;
  ...
```


The final section is where the proxying happens. It basically takes any incoming requests and proxies them to GRR web UI instance running on the same host listening to port 8000 on the local network interface (*localhost:8000*). Note that *localhost:8000" is the default address of GRR web UI when installed from GRR DEB package.

``` text
...
location / {

  proxy_set_header        Host $host;
  proxy_set_header        X-Real-IP $remote_addr;
  proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
  proxy_set_header        X-Forwarded-Proto $scheme;

  # Fix the “It appears that your reverse proxy set up is broken" error.
  proxy_pass          http://localhost:8000;
  proxy_read_timeout  180;

  proxy_redirect      http://localhost:8000 https://localhost;
}
...
```

Note that the second argument of *proxy_redirect* directive should be the publicly accessible address of your reverse proxy. We use *https://localhost* here for the sake of simplicity, but this can be replaced with an internal domain name or an IP address.

The first argument is the default host/port of AdminUI

**NOTE**: once again, we have to remind that GRR web UI shouldn't ever be exposed to the Internet. Whoever has access to GRR web UI potentially has root access to all GRR clients in your deployment.

## Step Two - Configure GRR

Edit */etc/grr/server.local.yaml* by setting the following option (a corresponding line should be in the file already):

``` text
AdminUI.url: https://localhost
```

The value of *AdminUI.url* should be equal to the second argument of Nginx's *proxy_redirect*. It must contain a URL that should be used by GRR users to access GRR web UI.

## Step Three - check that everything is working

Restart Nginx and GRR:
``` bash
sudo service grr-server restart
sudo service nginx restart
```

If you run the command above and see HTML code in the standard output, it means that you can reach GRR web UI.


At this point if you type *https://locahost* in your browser, you should see GRR's page protected by a Basic Auth dialog. You can also just use wget:

``` bash
wget --no-check-certificate --user=admin --password=password -O- https://localhost
```

Here *admin* is the username and *password* is the password of one of the registered GRR users. Use a username and a password that you specified when installing GRR.

Note that in this case it's GRR web UI process that triggers the Basic Auth check. In the current setup Nginx acts as a simple proxy that doesn't do any authentication and doesn't limit user's activity in any way. Whoever can access Nginx, can access GRR web UI running behind it.

## Step Four - make Nginx responsible for the authentication

GRR web UI supports setups where user authentication is delegated to the reverse proxy. In this kind of setups GRR web UI will simpy read the username from the X-Remote-User HTTP header and assume that the user has already passed the authentication stage and can be trusted.

Below is an example of doing such a setup.

Edit */etc/grr/server.local.yaml* and add the following:

``` text
AdminUI.webauth_manager: RemoteUserWebAuthManager
AdminUI.remote_user_trusted_ips:
  - 127.0.0.1
  - ::ffff:127.0.0.1
```

What happens here is that we switch from using *BasicWebAuthManager* (a default for *AdminUI.webauth_manager*) to *RemoteUserWebAuthManager*.

*BasicWebAuthManager* triggers Basic Authentication and checks passwords entered by users against the ones in GRR datastore. Only users that are explicitly created with *grr_config_updater* can log in if *BasicWebAuthManager* is used.

*RemoteUserWebAuthManager* is an entirely different thing. It doesn't do any authentication by itself. On the contrary, it expects the request to be already authenticated by a reverse proxy and X-Remote-User header to have a username of an authenticated user (the exact header name may be configured by GRR's *AdminUI.remote_user_header* option).

Given that *RemoteUserWebAuthManager* blindly trusts the value of X-Remote-User, it's very important to restrict the list of hosts that can send requests to GRR web UI when *RemoteUserWebAuthManager* is used. This is configured by *AdminUI.remote_user_trusted_ips* settings. This setting should contain IP address(es) of Nginx reverse proxy.

In this article we assume that GRR web UI and Nginx run on the same host, so we set  *AdminUI.remote_user_trusted_ips* to a localhost IP address in 2 notations, IPv4 and IPv6.

Now let's configure Nginx to do the Basic Auth itself. Change */etc/nginx/sites-enabled/default* by adding the following to *location* directive:

``` text
...
location / {
  ...
  auth_basic              "restricted site";
  auth_basic_user_file    /etc/nginx/.htpasswd;
  proxy_set_header        X-Remote-User $remote_user;
  ...
}
...
```

*proxy_set_header* directive sets X-Remote-User header (that is used by GRR web UI) to a username returned by Nginx's authentication directives (in this case: *auth_basic* and *auth_basic_user_file*).

*auth_basic* and *auth_basic_user_file* directives tell Nginx to request Baisc Authentication on a given location. Usernames and passwords are stored in the */etc/nginx/.htpasswd* file.

You can add a username to the file using this command. We are using *admin* as an example:


``` bash
sudo sh -c "echo -n 'admin:' >> /etc/nginx/.htpasswd"
```

Next, add an encrypted password entry for the username by typing:

``` bash
sudo sh -c "openssl passwd -apr1 >> /etc/nginx/.htpasswd"
```

Now restart both Nginx and GRR:

``` bash
sudo service grr-server restart
sudo service nginx restart
```

If you try accessing *https://localhost* using your browser now, you should see the Basic Authentication dialog. Enter username "admin" and the password that you've used right above and you should see GRR web UI. You can also just use wget:

``` bash
wget --no-check-certificate --user=admin --password=password -O- https://localhost
```

While this behavior looks similar to a default GRR behavior, it's drastically different under the hood. In a current setup the authentication is done by Nginx and GRR simply trusts the username that Nginx passes.

We used Basic Auth in Nginx for the sake of simplicity. However one of many Nginx authentication plugins can be used instead of *basic_auth* in this kind of setup.
