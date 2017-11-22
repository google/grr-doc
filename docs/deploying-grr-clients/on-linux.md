# On Linux

For Linux you will see a deb and rpms, install the appropriate one.
For testing purposes you can run the client on the same machine as
the server if you like.

The process depends on your environment, if you have a
mechanism such as puppet, then building as a Deb package and deploying
that way makes the most sense. Alternatively you can deploy using ssh:

    scp agent_version.deb host:/tmp/
    ssh host sudo dpkg -i /tmp/agent_version.deb

On MacOS X, the same process applies, use puppet or equivalent if you
have, or use ssh.