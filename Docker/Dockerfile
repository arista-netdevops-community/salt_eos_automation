#burnyd:salt_eos
FROM ubuntu:18.04

#Use the working directory where the salt infrastructure is located.
WORKDIR /srv/salt 

#Add the master config file & create master script 
ADD master /srv/salt
ADD createmaster.sh /srv/salt

#Create salt directories
RUN sh createmaster.sh

#Expose the port where the cherrypy api is running
EXPOSE 8999

#Keep the container alive forever with salt debug of the master
CMD tail -f /dev/null
