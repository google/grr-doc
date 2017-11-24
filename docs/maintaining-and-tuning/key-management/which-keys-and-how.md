# Key Management

GRR requires multiple key pairs. These are used to:

  - Sign the client certificates for enrollment.

  - Sign and decrypt messages from the client.

  - Sign code and drivers sent to the client.

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

To Encrypt and add a password to the code & driver signing certificates

- Copy the keys (PrivateKeys.executable\_signing\_private\_key &
  PrivateKeys.driver\_signing\_private\_key) from the current GRR
  configuration file, most likely

      - /etc/grr/server.local.yaml


- Save these two keys as new text files temporarily. You’ll need to
  convert the key text to the normal format by removing the leading
  whitespace and blank lines:

```docker
cat <original.exe.private.key.txt> | sed 's/^  //g' | sed '/^$/d' > <clean.exe.private.key>
cat <original.driver.private.key.txt> | sed 's/^  //g' | sed '/^$/d' > <clean.driver.private.key>
```

- Encrypt key and add a password

```docker
openssl rsa -des3 -in <clean.exe.private.key.txt> -out <exe.private.secure.key>
openssl rsa -des3 -in <clean.driver.private.key.txt> -out <driver.private.secure.key>
```

- Securely wipe all temporary files with cleartext keys.

- Replace the keys in the GRR config with the new encrypted keys (or
  store them offline). Ensure the server is restarted to load the
  updated configuration.

```docker
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

```docker
    PrivateKeys.executable_signing_private_key: %(<path_to_keyfile>|file)
```
