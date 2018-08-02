#!/bin/sh
# Let's generate some certificate in the EHR folder
# Usage : ./docker-ehr-certbot-only.sh ~/cps-site-moi/security/tls/letsencrypt www.example.com contact@example.com
# 
# The server has to be accessible on standard HTTP (tcp/80) and HTTPS (tcp/443) ports.
# Once done,  make sure to backup & store in a safe place all the ~/ehr/decurity data.

docker run --rm \
    -p 80:80 \
    -p 443:443 \
    --name letsencrypt-cps-site \
    -v $1:/etc/letsencrypt \
    -e "LETSENCRYPT_EMAIL=$3" \
    -e "LETSENCRYPT_DOMAIN1=$2" \
    blacklabelops/letsencrypt install

