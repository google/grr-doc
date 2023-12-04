#!/bin/bash
openssl ecparam -list_curves

# generate a private key for a curve
openssl ecparam -name prime256v1 -genkey -noout -out key.pem

# optional: generate corresponding public key
#openssl ec -in key.pem -pubout -out public-key.pem

# create a self-signed certificate
openssl req -new -x509 -key key.pem -out cert.pem -days 365 -subj "/C=AU/CN=fleetspeak-server" -addext "subjectAltName = DNS:fleetspeak-server"

export FRONTEND_PEM="$(cat cert.pem | sed 's/^/      /g' | sed ':a;N;$!ba;s/\n/\\n/g' | sed 's/\$/\\$/g')"
export FRONTEND_CERT=$(sed ':a;N;$!ba;s/\n/\\\\n/g' cert.pem)
export FRONTEND_KEY=$(sed ':a;N;$!ba;s/\n/\\\\n/g' key.pem)

echo $FRONTEND_PEM
echo $FRONTEND_CERT
echo $FRONTEND_KEY

sed -i "s@FRONTEND_CERTIFICATE@${FRONTEND_PEM}@" ./config/grr-server/server.local.yaml

sed -i 's@FRONTEND_CERTIFICATE@'"$FRONTEND_CERT"'@' ./config/fleetspeak-frontend/components.textproto
sed -i 's@FRONTEND_CERTIFICATE@'"$FRONTEND_CERT"'@' ./config/grr-client/config.textproto

sed -i 's@FRONTEND_KEY@'"$FRONTEND_KEY"'@' ./config/fleetspeak-frontend/components.textproto
