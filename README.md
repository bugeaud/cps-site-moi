# cps-site-moi

Ce projet a pour objectif de faciliter la mise en place d'applications web protégées par carte à puce CPS.

Il existe en plusieurs variantes :
 - PHP (existant)  
 - Java (à venir)

En premier, il est indispensable d'obtenir un certificat pour le site anticipé.
La configuration actuelle vous propose d'utiliser Let's Encrypt (www.letsencrypt.org) comme fournisseur gratuit.

L'application CPS Site Moi va récupérer les racines de sécurité de l'IGC Santé.

Sur cette base vont être crées les listes suivantes :
 - ca.crt : liste de certificats acceptés comme racine de sécurité pour accèder au site
 - all.crt : liste de tous les certificats de l'IGC santé servant de référentiel pour la validation de chemin de certificats. 

Les certificats racines sélectionnés vont être indiqués comme acceptés par le site. La configuration actuelle n'autorise que des utilisateurs disposant de certificat signés par ces racines à se connecter. 

# Site PHP protégé par CPS

Dans le répertoire php se trouve une coquille d'exemple d'application PHP.

Base de site protégé par une CPS en accès double facteur via Apache HTTP.

La page par défaut affiche l'ensemble des entête HTTP transmis à l'application.

Plusieurs scriptes sont disponible afin de faciliter l'utilisation :
- php/docker-build.sh : Construction de l'application Docker de CPS Site Moi
- php/docker-run.sh : Lancement de l'application Docker PHP de CPS Site Moi

Pour lancer le docker-run.sh, trois parapètres sont requis :
- Le nom du site (doit être identique à celui indiqué dans le certificat serveur)
- Le chemin du répertoire "etc" contenant les données de Let's Encrypt : il doit comporter un répertoire live contenant un sous répertoire dont le nom est identique au nom du site. Ce dernier contient les fichiers privkey.pem, cert.pem & fullchain.pem utilisés à minima)
- Un chemin ou stocker les fichiers de log (le répertoire doit exister)

Par exemple :
> cd php
> ./docker-run www.example.com  ~/cps-site-moi/security/tls/letsencrypt/etc/ ~/cps-site-moi/log/

# Utilisation de let's encrypt

Afin d'effectuer une demande, le site Let's Encrypt va nécessiter les informations suivantes :
 - Un répertoire où stocker les informations de sécurité : assurez vous que le répertoire existe
 - Adresse complète du site web (FQDN) : indiquer votre adresse cible telle que www.example.org par exemple
 - Adresse couriel de contact

Par exemple, pour le site www.example.com et l'adresse contact@example.com ainsi qu'un chemin dans votre répertoire maison, il est possible de faire :

> ./docker-ehr-certbot-only.sh ~/cps-site-moi/security/tls/letsencrypt www.example.com contact@example.com

En résultat, l'application Let's Encrypt vous fournira dans le répertoire ~/cps-site-moi/security/tls/letsencrypt/etc/live/www.example.com/ :
- Clé privée : privkey.pem
- Certificat contenant la clé publique : cert.pem
- Chaine de certificats : chain.pem
- Chaine complète de certificats : fullchain.pem 

Attention, ce répertoire "live" ne contient que des liens symboliques sur les fichiers du répertoire "archive" de "etc" : vous devez archiver l'ensemble du répertoire "etc" pour vous assurer d'une sauvegarde effective.
