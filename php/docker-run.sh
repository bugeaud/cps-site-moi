#!/bin/bash

displayUsage() {
 echo "Run the CPS Site Moi Application that kickstarts a secured website using a CPS card."
 echo -e "\nUsage:\n $0 yoursitefqdn.example.com path-to/the-pki-data anotherpath-to/the-log-tobe\n"
}

# if less than two arguments supplied, display usage
if [  $# -ne 3 ] ; then
 displayUsage
 exit 1
fi

# check whether user had supplied -h or --help . If yes display usage
if [[ ( $# == "--help") ||  $# == "-h" ]] ; then
 displayUsage
 exit 0
fi

docker run -p 443:443 -e CSM_SITE=$1 -v $2:/app/cps-site-moi/pki -v $3:/app/cps-site-moi/log cps-site-moi-php:latest
