OS X licensing means we can’t just simply provide a build vm via vagrant
as we’ve done for linux. Creating a vagrant-ready VM is fairly simple
though.

# Client Build VM

Install [Vagrant](https://www.vagrantup.com/), buy VMware Fusion, and
buy the [Vagrant VMWare Fusion
plugin](https://www.vagrantup.com/vmware). It’s possible to get this to
work with VirtualBox, which is free, but it’s missing some useful
features such as shared folders.

Create a new [vagrant-ready OS X VM in VMWare
Fusion](http://ilostmynotes.blogspot.com/2015/02/building-os-x-vagrant-vmware-fusion-vm.html).
We use OS X 10.8 (Mountain Lion) as a base so we can install on systems
at least that old, the build scripts are tested and work on that
version. The essentials are:

  - Commandline Tools for XCode

  - PackageMaker.app for building .pkg’s

  - VMWare Tools

  - Vagrant ssh and sudo access

