#!/bin/bash

set -ex

openssl ecparam -list_curves

# Generate key pair .pem files, which is linked in the GRR client and 
# server configs (client.yaml, server.local.yaml).
openssl genrsa -out config/private-key.pem
openssl rsa -in config/private-key.pem -pubout -out config/public-key.pem

# Create a CA/trusted private key and cert for Fleetspeak.
openssl ecparam -name prime256v1 -genkey -noout \
    -out fleetspeak-ca-key.pem
openssl req -new -x509 -days 365 -subj "/CN=Fleetspeak CA"\
   -key fleetspeak-ca-key.pem \
   -out fleetspeak-ca-cert.pem \

# Create keys for CA signed key and cert for fleetspeak. Resulting files are also
# copied in the envoy container, see containers/envoy/Dockerfile).
openssl ecparam -name prime256v1 -genkey -noout \
    -out fleetspeak-key.pem
openssl req -new -x509 -days 365 -subj "/CN=Fleetspeak CA" -addext "subjectAltName = DNS:fleetspeak-server" \
   -key fleetspeak-key.pem \
   -out fleetspeak-cert.pem \
   -CA fleetspeak-ca-cert.pem \
   -CAkey fleetspeak-ca-key.pem

# Replace placeholders in fleetspeak and grr-client textproto files.
TRUSTED_FLEETSPEAK_CERT=$(sed ':a;N;$!ba;s/\n/\\\\n/g' fleetspeak-ca-cert.pem)
FLEETSPEAK_KEY=$(sed ':a;N;$!ba;s/\n/\\\\n/g' fleetspeak-key.pem)
FLEETSPEAK_CERT=$(sed ':a;N;$!ba;s/\n/\\\\n/g' fleetspeak-cert.pem)

sed -i 's@FLEETSPEAK_CERT@'"$FLEETSPEAK_CERT"'@' ./config/fleetspeak-frontend/components.textproto
sed -i 's@FLEETSPEAK_KEY@'"$FLEETSPEAK_KEY"'@' ./config/fleetspeak-frontend/components.textproto
sed -i 's@TRUSTED_FLEETSPEAK_CERT@'"$TRUSTED_FLEETSPEAK_CERT"'@' ./config/grr-client/config.textproto
