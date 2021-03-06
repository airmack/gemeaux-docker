# gemeaux-docker image
This is a docker image for [gemaux](https://github.com/brunobord/gemeaux) based on a fork by [airmack](https://github.com/airmack/gemeaux). 

The image will create the example app that is already included in the source code. 
The configuration, logfiles and the application  will be exposed in the host system (e.g. /srv/gemeaux/).
The service is exposed by default on the port 1965.
Every 30 seconds it is checked if the service is still availabel.

# How to access the service from the network
Although the port will be exposed on the host system, the tls-certificate will only work from localhost. 
To generate a valid tls-certificate one can run the helper script cert.sh in /srv/gemeaux/conf/.
The script will try to get the IPv4, IPv6 and hostname settings and create the tls-certificate in accordance.

# How to get started
The /srv/gemeaux/gmi/ directory is the root for the capsule. Any change within the static-folder should be directly propagated to the service. 
