#!/usr/bin/env bash

# Alex Coleman
# 2018/09/23

set -e

if [ -z "$1" ]; then
  hostname="$HOSTNAME"
else
  hostname="$1"
fi

local_openssl_config="
[ req ]
prompt = no
distinguished_name = req_distinguished_name
x509_extensions = san_self_signed
[ req_distinguished_name ]
CN=$hostname
[ san_self_signed ]
subjectAltName = DNS:$hostname, DNS:localhost
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid:always,issuer
basicConstraints = CA:true
keyUsage = nonRepudiation, digitalSignature, keyEncipherment, dataEncipherment, keyCertSign, cRLSign
extendedKeyUsage = serverAuth, clientAuth, timeStamping
"

openssl req \
  -newkey rsa:2048 -nodes \
  -keyout "$hostname.key.pem" \
  -x509 -sha256 -days 3650 \
  -config <(echo "$local_openssl_config") \
  -out "$hostname.cert.pem"
openssl x509 -noout -text -in "$hostname.cert.pem"
