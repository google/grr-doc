# Building custom client templates

There’s no need to rebuild the client for testing or small deployments,
use [repacking](#repacking-the-client-with-a-new-configuration) instead.

OS X and Linux clients are built on every commit using travis (after
tests pass), and the results are stored on Google cloud storage. Windows
templates are [built on appveyor and the results are downloadable via
their website](https://ci.appveyor.com/project/destijl/grr). You can use
these templates directly, but be aware you are trusting the travis and
appveyor infrastructure to be secure.

If you want to build your own templates because you have customised
code, use the [vagrant](https://www.vagrantup.com/) build system. You’ll
need a copy of the GRR source:

    git clone https://github.com/google/grr.git

and the latest versions of [Vagrant](https://www.vagrantup.com/) and
VirtualBox installed. If you reboot the provided linux VM’s and get the
new kernel you’ll need to update the VirtualBox guest additions. You can
use [vagrant-vbguest](https://github.com/dotless-de/vagrant-vbguest) to
do this automatically, but you should download and verify the hash on
the guest additions yourself (vagrant-vbguest downloads over HTTP and
doesn’t verify hash).

OS X and windows require some extra work, see here for instructions:

  - [Building the OS X client](osxclient.md)

  - [Building the Windows client](windowsclient.md)

Once you have your vagrant VMs setup (only necessary for OS X, linux
will download VMs automatically), you can build templates for all linux
OSes just by running make. If you’re building for OS X as well, you’ll
run this once on linux and once on apple hardware. Windows requires more
work as described
[here](windowsclient.md#building-templates).

    cd vagrant
    make templates

To get clean VMs and re-run the provisioning for all linux and OS X VMs
you can use:

    make vmclean

Once you have templates built you need to follow the repacking
instructions above to turn them into installers.
