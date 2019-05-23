# Emergency Pushing of Code and Binaries

GRR offers functionality to deploy custom code or binaries to the
whole fleet quickly. It goes without saying that this functinality
can lead to problems and should therefore be used with care - we
recommend using this as a last resort means in case things have gone
terribly bad and not relying on this functionality for normal
operations.

Binaries and python code can be pushed from the server to the
clients to enable new functionality.
The code that is pushed from the server must be signed by the
corresponding private key for `Client.executable_signing_public_key` for
python and binaries. These signatures will
be checked by the client to ensure they match before the code is used.

What is actually sent to the client is the code or binary wrapped in a
protobuf which will contain a hash, a signature and some other
configuration data.

To sign code requires use of config\_updater utility. In a secure
environment the signing may occur on a different box from the server,
but the examples below show the basic example.

## Deploying Arbitrary Python Code.

To execute an arbitrary python blob, you need to create a file with
python code that has the following attributes:

  - Code in the file must work when executed by exec() in the context of
    a running GRR client.

  - Any return data that you want sent back to the server can be
    stored encoded as a string in a variable called
    "magic\_return\_str". Alternatively, GRR collects all output from
    print statements and puts them into the magic\_return\_string.

E.g. as a simple example. The following code modifies the clients
poll\_max setting and pings test.com.

``` python
import commands
status, output = commands.getstatusoutput("ping -c 3 test.com")
config_lib.CONFIG.Set("Client.poll_max", 100)
config_lib.CONFIG.Write()
magic_return_str = "poll_max successfully set. ping output %s" % output
```

This file then needs to be signed and converted into the protobuf format
required, and then needs to be uploaded to the data store. You can do
this using the following command line.

``` docker
grr_config_updater upload_python --file=myfile.py --platform=windows
```

The uploaded files live by convention in python\_hacks\<platform> and are
viewable in the "Binaries" section of the Admin UI.

The ExecutePythonHack Flow is provided for executing the file on a
client. This is visible in the Admin UI under Administrative flows if
Advanced Mode is enabled.

**Note**: Specifying arguments to a PythonHack is possible as well
through the py\_args argument, this can be useful for making the hack
more generic.

## Deploying Executables.

The GRR Agent provides an ExecuteBinaryCommand Client Action which
allows us to send a binary and set of command line arguments to be
executed. Again, the binary must be signed using the executable
signing key (config option PrivateKeys.executable\_signing\_private\_key).

To sign an exe for execution use the config updater
script.

``` docker
db@host:$ grr_config_updater upload_exe --file=/tmp/bazinga.exe --platform=windows
Using configuration <ConfigFileParser filename="/etc/grr/grr-server.conf">
Uploaded successfully to /config/executables/windows/installers/bazinga.exe
db@host:$
```

This file can then be executed with the LaunchBinary flow which is in
the Administrative flows if Advanced Mode is enabled.
