FROM php:apache

LABEL description="CPS Site Moi - PHP is an example of PHP site protected with two factor CPS smartcard access"
LABEL maintainer="bugeaud@gmail.com"

# Environment for the site
ENV CSM_SITE=www.example.net
ENV CSM_PATH=/app/cps-site-moi

# Create the APP directory and move to it
ADD --chown=www-data:www-data . $CSM_PATH

# Volume where the PKI data are located (CA, Cert & PrivKey at least)
VOLUME $CSM_PATH/pki

# Volume where the log are stored
VOLUME $CSM_PATH/log

# Ad some good practice options for Apache TLS
ADD https://raw.githubusercontent.com/certbot/certbot/master/certbot-apache/certbot_apache/options-ssl-apache.conf $CSM_PATH/conf/

WORKDIR $CSM_PATH/conf/

# Fetch the official IGC PKCS#7 stores for the CPS. Yes, HTTP is bad... but this is the only option at the time this is written
ADD http://igc-sante.esante.gouv.fr/AC/Chaine_de_certification-IGC-Sante.p7b IGC3-tous.p7b
ADD http://integrateurs-cps.asipsante.fr/fichiers/CERT-CPS2ter-2020-EXPL.p7b IGC2ter-tous.p7b

# Transform PKCS7 B CPS2Ter IGC to a single PEM
RUN openssl pkcs7 -in IGC2ter-tous.p7b -inform DER -print_certs -out IGC2ter-tous.pem
# Allow Classe 1 Persons only
RUN sed -n -e '/CN=GIP-CPS CLASSE-1/,/END CERTIFICATE/ p' IGC2ter-tous.pem >> ca.crt
# Implicit contatenate Class 1 & Person hierarchy
RUN sed -n -e '/OU=GIP-CPS PROFESSIONNEL/,/END CERTIFICATE/ p' IGC2ter-tous.pem >> all.crt

# Transform PKCS7 B CPS3 IGC to a single PEM
RUN openssl pkcs7 -in IGC3-tous.p7b -print_certs -out IGC3-tous.pem

# Allow IGC3 (IGC Santé for CPS3) for Standard and Fort class
RUN sed -n -e '/CN=AC IGC-SANTE STANDARD PERSONNES/,/END CERTIFICATE/ p' IGC3-tous.pem >> ca.crt
RUN sed -n -e '/CN=AC IGC-SANTE STANDARD PERSONNES/,/END CERTIFICATE/ p' IGC3-tous.pem >> all.crt
RUN sed -n -e '/CN=AC RACINE IGC-SANTE STANDARD/,/END CERTIFICATE/ p' IGC3-tous.pem >> all.crt

RUN sed -n -e '/CN=AC IGC-SANTE FORT PERSONNES/,/END CERTIFICATE/ p' IGC3-tous.pem >> ca.crt
RUN sed -n -e '/CN=AC IGC-SANTE FORT PERSONNES/,/END CERTIFICATE/ p' IGC3-tous.pem >> all.crt
RUN sed -n -e '/CN=AC RACINE IGC-SANTE FORT/,/END CERTIFICATE/ p' IGC3-tous.pem >> all.crt

WORKDIR $CSM_PATH/

# Copy the default secure site configuration
COPY conf/cps-secure.conf /etc/apache2/sites-available/

# Make sure TLS is enable
RUN a2enmod ssl

# Disable default site and enable the cps-secure site
RUN a2dissite 000-default
RUN a2ensite cps-secure

#EXPOSE 80
EXPOSE 443
