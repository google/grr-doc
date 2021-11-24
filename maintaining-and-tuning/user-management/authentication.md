# Users in GRR

## Concept

GRR has a concept of users of the system. The GUI supports basic authentication and this verfication of user identity is used in all auditing functions (so for example GRR can properly record which user accessed which client, and who executed flows on clients). **There is no logout button. To change users you will need to invalidate your session.**

A GRR user will be created as an admin by default. This is only important if the [approval-based workflow](../approval-based-workflow.md) is turned on, since only "admin" users can approve hunts. We are aware of a bug that all users are created with admin permissions, however, the approval system is the authority for access across GRR, when enabled.  

To add the user joe as an admin:

```   
db@host:~$ sudo grr_config_updater add_user joe
Using configuration <ConfigFileParser filename="/etc/grr/grr-server.conf">
Please enter password for user 'joe':
Updating user joe

Username: joe
Password: set
```

To list all users:

```
db@host:~$ sudo grr_config_updater show_user
Using configuration <ConfigFileParser filename="/etc/grr/grr-server.conf">

Username: test
Is Admin: True
```

To update a user password:

```
db@host:~$ sudo grr_config_updater update_user joe --password
Using configuration <ConfigFileParser filename="/etc/grr/grr-server.conf">
Updating user joe

Username: joe
Is Admin: True
```
Available commands are (--admin is currently not functional in v3.3.0.0):

```
usage: grr_config_updater update_user [-h] [--helpfull] [--password] [--admin]
                                      username

positional arguments:
  username    Username to update.

optional arguments:
  -h, --help  show this help message and exit
  --helpfull  show full help message and exit
  --password  Reset the password for this user (will prompt for password).
  --admin     Make the user an admin, if they aren't already.
```
## Authentication

The AdminUI uses HTTP Basic Auth authentication by default, based on the passwords within
the user objects stored in the data store, but we **don't expect you to use this
in production** (see [Securing Access](../../installing-grr-server/securing-access.md) for more details).

There is so much diversity and customization in enterprise
authentication schemes that there isn't a good way to provide a solution that
works for a majority of users. Large enterprises most likely already have internal webapps
that use authentication, this is just one more. Most people have found the
easiest approach is to sit Apache (or similar) in front of the GRR Admin UI as
a reverse proxy and use an existing SSO plugin that already works for that
platform. Alternatively, with more work you can handle auth inside GRR by
writing a Webauth Manager (`AdminUI.webauth_manager` config option) that uses an
SSO or SAML based authentication mechanism.
