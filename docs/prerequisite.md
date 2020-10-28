![Lab topology](images/index.jpg?raw=true)

*For this lab to work it is expected that the user has the following knowledge base.*

* Some history with Arista EOS
* Some history with Linux 
* Some history with networking as a general topic. 
* Some docker knowledge.

*Technical requirements.*

* Docker (This was tested on Docker CE 19.03.13)
* Arista cEOS lab. (4.23.2F) Please sign up for a arista login and use the software downloads page and instructions on how to import a cEOS lab docker image.
* [Docker-topo](https://github.com/networkop/docker-topo) Docker-topo allows a user to quickly spin up a cEOS lab environment that connects the docker networks together for the user in portable fashion allowing the user to add custom docker containers and networks that they chose. 
* Make sure that the config directory which stores the device configs is rw from the host to the ceos lab node.  I was brave and did a chomod -R 777 /config I am sure you do not have to open up the permissions to that level.  However, if you do not you will receive issues that the startup-config cannot be modified from cEOS. 
* If you are a mac user and use docker for mac you will need to share this directory to allow the host to mount to the container.

The base_lab.yml contains the general ground work for docker-topo. Which can be found within the root of the repo. 

#Starting the lab.
