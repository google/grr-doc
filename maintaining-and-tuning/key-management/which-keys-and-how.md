# Cryptographic Keys

## Communication Security.

GRR uses fleetspeak for communication, which in turn uses TLS.

The fleetspeak server uses a CA and server public key pair generated on
server install. The CA certificate is deployed to the client so that it
can ensure it is communicating with the correct server. If these keys
are not kept secure, anyone with MITM capability can intercept
communications and take control of your clients. Additionally, if you
lose these keys, you lose the ability to communicate with your clients.

**Note**: The fact that the client uses a CA certificate to verify the server
ensures only that the client doesn't accidentally connect to the wrong
server and protects for example from privilege escalation attacks using
a malicious fleetspeak server. This feature does not stop clients that do not
have the CA certificate from connecting to your server - it's for
example possible to use a modified client that just doesn't do this
check. Such clients would the be able to see for example IOCs that you
send to all clients in a hunt.

## Code Signing and CA Keys.

In addition to the CA and Server key pairs, GRR maintains a set of code
signing signing keys. By default GRR aims to provide only
read-only actions, this means that GRR is unlikely to modify evidence,
and cannot trivially be used to take control of systems running the
agent.

**Note** that read only access many not give direct code exec,
but may well provide it indirectly via read access to important keys
and passwords on disk or in memory!

However, there are a number of use cases where it makes
sense to have GRR execute arbitrary code as explained in the section
[Deploying Custom Code](#deploying-custom-drivers-and-code).

As part of the GRR design, we decided that administrative control of the
GRR server shouldn’t trivially lead to code execution on the clients. As
such we embed a strict [allowlist of
commands](https://github.com/google/grr/search?q=IsExecutionWhitelisted)
that can be executed on the client and we have a separate set of keys
for code signing. For a binary to be run, the code has to be signed by
the specific key and the client will confirm this signature before
execution.

This mechanism helps give the separation of control required in some
deployments. For example, the Incident Response team need to analyze
hosts to get their job done, but deployment of new code to the platfrom
is only done when blessed by the administrators and rolled out as part
of standard change control. The signing mechanism allows Incident
Response to react fast with new code if necessary, but only with the
blessing of the Signing Key held by the platform administrator.

In the default install, the driver and code signing private keys are not
passphrase protected. In a secure environment we strongly recommended
generating and storing these keys off the GRR server and doing offline
signing every time this functionality is required, or at a minimum
setting passphrases which are required on every use. We recommend
encrypting the keys in the config with PEM encryption, config\_updater
will then ask for the passphrase when they are used. An alternative is
to keep a separate offline config that contains the private keys.

## Key Generation

As state above, GRR requires multiple key pairs. These are used to:

  - Sign the client certificates for enrollment.

  - Sign and decrypt messages from the client.

  - Sign code and binaries sent to the client.

These keys can be generated using the config\_updater script normally
installed in the path as grr\_config\_updater using the generate\_keys
command.

``` shell
db@host:$ sudo grr_config_updater generate_keys
Generating executable signing key
..............+++
.....+++
Generating driver signing key
..................................................................+++
.............................................................+++
Generating CA keys
Generating Server keys
Generating Django Secret key (used for xsrf protection etc)
db@host:$
```

## Adding a Passphrase

To Encrypt and add a password to the code & driver signing certificates

- Copy the keys (PrivateKeys.executable\_signing\_private\_key &
  PrivateKeys.driver\_signing\_private\_key) from the current GRR
  configuration file, most likely

      - /etc/grr/server.local.yaml


- Save these two keys as new text files temporarily. You’ll need to
  convert the key text to the normal format by removing the leading
  whitespace and blank lines:

``` bash
cat <original.exe.private.key.txt> | sed 's/^  //g' | sed '/^$/d' > <clean.exe.private.key>
cat <original.driver.private.key.txt> | sed 's/^  //g' | sed '/^$/d' > <clean.driver.private.key>
```

- Encrypt key and add a password

``` bash
openssl rsa -des3 -in <clean.exe.private.key.txt> -out <exe.private.secure.key>
openssl rsa -des3 -in <clean.driver.private.key.txt> -out <driver.private.secure.key>
```

- Securely wipe all temporary files with cleartext keys.

- Replace the keys in the GRR config with the new encrypted keys (or
  store them offline). Ensure the server is restarted to load the
  updated configuration.

``` text
 PrivateKeys.executable_signing_private_key: '-----BEGIN RSA PRIVATE KEY-----

   Proc-Type: 4,ENCRYPTED

   DEK-Info: DES-EDE3-CBC,8EDA740783B7563C


   <start key text after *two* blank lines…>

   <KEY...>

   -----END RSA PRIVATE KEY-----'
```

**Note** In the YAML encoding,there **must** be an extra line between the encrypted PEM header and the encoded key. The key is double-spaces and indented two spaced exactly like all other keys in configuration file.

Alternatively, you can also keep your new, protected keys in files on
the server and load them in the configuration using the file filter like
this:

``` text
    PrivateKeys.executable_signing_private_key: %(<path_to_keyfile>|file)
```
