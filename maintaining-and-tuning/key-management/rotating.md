# Rotating the keys

## Rotating Client Keys ##

The keys used by the fleetspeak client to talk to the server do not have to be / cannot be rotated since the client id depends directly on the private key. Just removing the fleetspeak state file results in the client generating a new key pair but the client will also get a new client id.

Client keys used for signing executables and drivers can be changed in the config as described in the [documentation about keys](which-keys-and-how.md) but

- Clients need to be repacked and redeployed so they can use the new keys.
- Old clients on the fleet will not be able to use the new keys anymore so there will be some issues during transition.


## Rotating Server Keys ##

Issuing a new server key can be done using the
```docker
grr_config_updater rotate_server_key
```
command. This will update the server configuration with a new private key that is signed by the same CA. Existing clients will not lose connectivity by changing those keys even though old clients might need to be restarted before they will accept the new server credentials.

**Note** Changing the server key will invoke GRRs certificate revocation process. All clients that have seen the new server certificate will from that point on refuse to accept the previous key so it's not possible to revert to the old key.

