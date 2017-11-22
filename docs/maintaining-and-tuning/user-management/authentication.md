# GRR user concept

GRR has a concept of users of the system. The GUI supports authentication and this verfication of user identity is used in all auditing functions (So for example GRR can properly record which user accessed which client, and who executed flows on clients).

A GRR user may be marked as "admin". This is only important if the [approval-based workflow](../approval-based-auditing.md) is turned on, since only "admin" users can approve hunts.

To add the user joe as an admin:

``` bash
db@host:~$ sudo grr_config_updater add_user joe
Using configuration <ConfigFileParser filename="/etc/grr/grr-server.conf">
Please enter password for user 'joe':
Updating user joe

Username: joe
Labels:
Password: set
```

To list all users:

``` bash
db@host:~$ sudo grr_config_updater show_user
Using configuration <ConfigFileParser filename="/etc/grr/grr-server.conf">

Username: test
Labels:
Password: set

Username: admin
Labels: admin
Password: set
```

To update a user (useful for setting labels or for changing passwords):

``` bash
db@host:~$ sudo grr_config_updater update_user joe --add_labels admin,user
Using configuration <ConfigFileParser filename="/etc/grr/grr-server.conf">
Updating user joe

Username: joe
Labels: admin,user
Password: set
```

## Authentication

The AdminUI uses HTTP Basic Auth authentication by default, based on the passwords within
the user objects stored in the data store, but we **don't expect you to use this
in production** (see [Securing Access](../installing-grr-server/securing-access.md) for more details).

There is so much diversity and customization in enterprise
authentication shemes that there isn't a good way to provide a solution that
works for a majority of users. But you probably already have internal webapps
that use authentication, this is just one more. Most people have found the
easiest approach is to sit Apache (or similar) in front of the GRR Admin UI as
a reverse proxy and use an existing SSO plugin that already works for that
platform. Alternatively, with more work you can handle auth inside GRR by
writing a Webauth Manager (`AdminUI.webauth_manager` config option) that uses an
SSO or SAML based authentication mechanism.
