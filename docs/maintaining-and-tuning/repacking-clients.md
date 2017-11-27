# Repacking GRR clients

The client can be customized for deployment. There are two key ways of
doing this:

1.  Repack the released client with a new configuration.

2.  Rebuild the client from scratch (advanced users); see [Building custom client templates](building-custom-client-templates/).

Doing a rebuild allows full reconfiguration, changing names and
everything else. A repack on the other hand limits what you can change.
Each approach is described below.

## Repacking the Client with a New Configuration.

Changing basic configuration parameters can be done by editing the
server config file (/etc/grr/server.local.yaml) to override default
values, and then using the config\_updater to repack the binaries. This
allows for changing basic configuration parameters such as the URL the
client reports back to.

Once the config has been edited, you can repack all clients with the new
config and upload them to the datastore using
``` shell
$ grr_config_updater repack_clients
```

Repacking works by taking the template zip files, injecting relevant
configuration files, and renaming files inside the zip to match
requested names. This template is then turned into something that can be
deployed on the system by using the debian package builder on linux,
creating a self extracting zip on Windows, or creating an installer package on OSX.

After running the repack you should have binaries available in the UI
under manage binaries → installers and also on the filesystem under `grr/executables`.

## Repacking Clients: Signing installer binaries

You can also use the grr\_client\_build tool to repack individual
templates and control more aspects of the repacking, such as signing.
For signing to work you need to follow these instructions:

### Setting up for RPM signing

Linux RPMs are signed following a similar process to windows. A template
is built inside the vagrant VM and the host does the repacking and
signing.

To get set up for signing, first you need to create a gpg key that you
will use for signing ([here’s a decent
HOWTO](https://alexcabal.com/creating-the-perfect-gpg-keypair/)).

Then make sure you have rpmsign and rpm utilities installed on your host
system:

    sudo apt-get install rpm

Tell GRR where your public key is:

    sudo ln -s /path/to/mykey.pub /etc/alternatives/grr_rpm_signing_key

Set this config variable to whatever you used as your key name:

    ClientBuilder.rpm_gpg_name: my key name

That’s it, you can follow the normal build process.

### Setting up for Windows EXE signing

Windows licensing means we can’t just simply provide a build vm via
vagrant as we’ve done for linux. So there’s more hoops to jump through
here, but it’s as automated as possible.

#### Building Templates

First you need to make sdists from the GRR source (which requires a
protobuf compiler) and get them to the windows build machine. We do this
on linux with this script which uses google cloud storage to copy the
files to the windows machine (note you’ll need to use a different cloud
storage bucket name):

    BUCKET=mybucketname scripts/make_sdist_for_templates.sh

On your Windows/VM with git and the Google cloud SDK installed, run this
as admin:

```docker
mkdir C:\grr_src
git clone https://github.com/google/grr.git C:\grr_src
C:\grr_src\vagrant\windows\install_for_build.bat
```

Then as a regular user you can download the sdists and build the
templates from that:

```docker
C:\Python27-x64\python.exe C:\grr_src\vagrant\windows\build_windows_templates.py --grr_src=C:\grr_src --cloud_storage_sdist_bucket=mybucketname --cloud_storage_output_bucket=mybucketname
```

Download the built templates and components from cloud storage to your
linux vm ready for repacking. Put them under
`grr/executables/windows/templates`.

#### Setting Up For Windows EXE Signing

To make automation easier we now sign the windows installer executable
on linux using osslsigncode. To set up for signing, install
osslsigncode:

    sudo apt-get install libcurl4-openssl-dev
    wget http://downloads.sourceforge.net/project/osslsigncode/osslsigncode/osslsigncode-1.7.1.tar.gz
    tar zxvf osslsigncode-1.7.1.tar.gz
    cd osslsigncode-1.7.1/
    ./configure
    make
    sudo make install

Get your signing key into the .pvk and .spc format, example commands
below (will vary based on who you buy the signing cert from):

    openssl pkcs12 -in authenticode.pfx -nocerts -nodes -out key.pem
    openssl rsa -in key.pem -outform PVK -pvk-strong -out authenticode.pvk
    openssl pkcs12 -in authenticode.pfx -nokeys -nodes -out cert.pem
    cat Thawte_Primary_Root_CA_Cross.cer >> cert.pem
    openssl crl2pkcs7 -nocrl -certfile cert.pem -outform DER -out authenticode.spc
    shred -u key.pem

Link to wherever your key lives. This allows you to keep it on removable
media and have different people use different keys with the same grr
config.

    sudo ln -s /path/to/authenticode.pvk /etc/alternatives/grr_windows_signing_key
    sudo ln -s /path/to/authenticode.spc /etc/alternatives/grr_windows_signing_cert

## Repacking Clients - Follow-up

After doing the above, add the --sign parameter to the repack
    command:

```docker
grr_client_build repack --template path/to/grr-response-templates/templates/grr_3.1.0.2_amd64.xar.zip --output_dir=/tmp/test --sign
```

To repack and sign multiple templates at once, see the next section.

## Repacking Clients With Custom Labels: Multi-Organization Deployments

Each client can have a label "baked in" at build time that allows it to
be identified and hunted separately. This is especially useful when you
want to deploy across a large number of separate organisations. You
achieve this by creating a config file that contains the unique
configuration you want applied to the template. A minimal config that
just applies a label would contain:

    Client.labels: [mylabel]

and be written into repack\_configs/mylabel.yaml.

Then you can call repack\_multiple to repack all templates (or whichever
templates you choose) with this configuration and any others in the
repack\_configs directory. An installer will be built for each
    config:

```docker
grr_client_build repack_multiple --templates /path/to/grr-response-templates/templates/*.zip --repack_configs /path/to/repack_configs/*.yaml --output_dir=/grr_installers
```

To sign the installers (RPM and EXE), add --sign.

## Client Configuration.

Configuration of the client is done during the packing/repacking of the
client. The process looks like:

1.  For the client we are packing, find the correct context and
    platform, e.g. `Platform: Windows` `Client Context`

2.  Extract the relevant configuration parameters for that context from
    the server configuration file, and write them to a client specific
    configuration file e.g. `GRR.exe.yaml`

3.  Pack that configuration file into the binary to be deployed.

When the client runs, it determines the configuration in the following
manner based on `--config` and `--secondary_configs` arguments that are
given to it:

1.  Read the config file packed with the installer, default:
    `c:\windows\system32\GRR\GRR.exe.yaml`

2.  GRR.exe.yaml reads the Config.writeback value, default:
    `reg://HKEY_LOCAL_MACHINE/Software/GRR`

3.  Read in the values at that registry key and override any values from
    the yaml file with those values.

Most parameters are able to be modified by changing parameters and then
restarting GRR. However, some configuration options, such as
`Client.name` affect the name of the actual binary itself and therefore
can only be changed with a repack on the server.

Updating a configuration variable in the client can be done in multiple
ways:

1.  Change the configuration on the server, repack the clients and
    redeploy/update them.

2.  Edit the yaml configuration file on the machine running the client
    and restart the client.

3.  Update where Config.writeback points to with new values, e.g. by
    editing the registry key.

4.  Issue an UpdateConfig flow from the server (not visible in the UI),
    to achieve 3.

As an example, to reduce how often the client polls the server to every
300 seconds, you can update the registry as per below, and then restart
the service:

```docker
C:\Windows\System32\>reg add HKLM\Software\GRR /v Client.poll_max /d 300

The operation completed successfully.
C:\Windows\System32\>
```
