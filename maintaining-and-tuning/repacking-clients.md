# Repacking GRR clients

The client can be customized for deployment. There are two key ways of
doing this:

1.  Repack the released client with a new configuration.

2.  Rebuild the client from scratch (advanced users); see [Building custom client templates](building-custom-client-templates.md).

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
under Binaries → installers and also on the filesystem under `grr/executables`.

## Repacking Clients: Signing installer binaries

You can also use the grr\_client\_build tool to repack individual
templates and control more aspects of the repacking, such as signing.
For signing to work you need to follow these instructions:

### Linux RPM signing

Linux RPMs are signed following a similar process to windows. A template
is built inside a docker container / Vagrant VM and the host does the
repacking and signing.

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

### Windows EXE signing

The easiest way to get a properly signed Windows GRR installer is to rebuild the client template and repack it on a dedicated Windows machine.

To do that:

* Edit your `/etc/grr/server.local.yaml` by configuring Windows signing and verification commands:
  ```
  ClientBuilder.signtool_signing_cmd: |
    C:\Program Files \(x86\)\Windows kits\10\App Certification Kit\signtool.exe sign /f Sample.CodeSigning.pfx
  ClientBuilder.signtool_verification_cmd: |
    C:\Program Files \(x86\)\Windows kits\10\App Certification Kit\signtool.exe verify /pa /all  
  ```
  
   *Note:* these are sample commands using a sample certificate file. In your case commands might depend on your setup. Please consult the [Windows documentation](https://docs.microsoft.com/en-us/windows/win32/seccrypto/using-signtool-to-sign-a-file) for details about code signing.
   
* Install [Python 3.7](https://www.python.org/ftp/python/3.7.8/python-3.7.8-amd64.exe) on the Windows box.
* Install Windows [SignTool](https://docs.microsoft.com/en-us/windows/win32/seccrypto/signtool). It's available as part of [Windows SDK](https://go.microsoft.com/fwlink/p/?linkid=2120843).
* Copy your server configuration files to the Windows box:
  * /etc/grr/server.local.yaml
  * /usr/share/grr-server/install_data/etc/grr-server.yaml
  
  Make sure that server.local.yaml is transferred and stored securely - it contains sensitive keys.
* In the console run:
  ```
  C:\Python37\python.exe -m venv temp_venv
  .\temp_venv\Scripts\activate
  pip install grr-response-client-builder
  ```
  
  This will install the GRR client builder from PIP. Alternatively, you can checkout GRR from GitHub and build it from source (see our [Appveyor configuration](https://github.com/google/grr/blob/2c1e6fce9ea0db9285b5b909b72b0778c677b9a5/appveyor/windows_templates/appveyor.yml) as a starting point).
  
* To build the client template, run (while in the virtualenv):

  ```
  grr_client_build --verbose build --output templates --config grr-server.yaml --secondary_config server.local.yaml
  ```
  
* To sign the built template, run:
  
  ```
  grr_client_build --verbose sign_template --template templates\GRR_3.4.0.1_amd64.exe.zip --output_file templates\GRR_3.4.0.1_amd64_signed.exe.zip --config grr-server.yaml --secondary_config server.local.yaml
  ```
  
* To repack the signed template, run:

  ```
  grr_client_build repack --template templates\GRR_3.4.0.1_amd64_signed.exe.zip --sign --signed_template --output_dir repacked --config grr-server.yaml --secondary_config server.local.yaml
  ```
  
 * The resulting signed installer will be put into the `repacked` folder.
 
 
### MacOS PKG signing

The easiest way to get a properly signed MacOS GRR installer is to rebuild the client template and repack it on a dedicated MacOS machine.

* Edit your `/etc/grr/server.local.yaml` to reference the certificate name and, optionally, the keychain:
  ```
  ClientBuilder.signing_cert_name: "My certificate name"
  ```
  
  Optionally you can also specify a keychain file to use (if not specified, a default one of `%(HOME|env)/Library/Keychains/MacApplicationSigning.keychain` will be used):
  ```
  ClientBuilder.signing_keychain_file: "%(HOME|env)/Library/Keychains/My.keychain"
  ```

* Copy your server configuration files to the MacOS box:
  * /etc/grr/server.local.yaml
  * /usr/share/grr-server/install_data/etc/grr-server.yaml
  
  Make sure that server.local.yaml is transferred and stored securely - it contains sensitive keys.

* Execute following commands:
  ```
  python3 -m venv temp_venv
  source temp_venv/bin/activate
  # you might need to run "xcode-select --install" in order for the next command to succeed
  export MACOSX_DEPLOYMENT_TARGET=10.10
  CFLAGS=-stdlib=libc++ pip install grr-response-client-builder
  ```
 
 * Build the client template (it will get signed along the way):
   ```
   grr_client_build --verbose build --output templates --config grr-server.yaml --secondary_config server.local.yaml
   ```
   
 * Repack it (this command technically doesn't need MacOS to be executed, can be done on the GRR server side):
   ```
   grr_client_build --verbose repack --template templates/grr_3.4.0.1_amd64.xar.zip --output_dir repacked --config grr-server.yaml --secondary_config server.local.yaml
   ```
 * The resulting installer with all contents signed will be placed into the `repacked` folder. If you want the installer itself to be signed, use the productsign utility (see this [article](https://simplemdm.com/certificate-sign-macos-packages/), for example).
 
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
