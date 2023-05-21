#!/bin/sh
#
# RUN FROM PROJECT ROOT.
# sh gateway/scripts/prod-defaults.sh

openssl req -config ./gateway/config/default-ssl-cert.conf -newkey rsa:4096 -nodes -keyout ./gateway/certs/default.key -x509 -days 365 -out ./gateway/certs/default.pem

openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:4096 -out ./gateway/config/account.key