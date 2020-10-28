   ![salteos](images/salteos.jpg?raw=true,p align="center")

The purpose of this repo is to demonstrate the power of salt with arista eos to orchestrate, automate and react to events within the network.

Salt is a event drivien automation platform.  This is different than the conventional network automation configuration platform tool as salt is able to not only generate configurations or automate certain software.  Salt is also able to react to events with its ZeroMQ messaging system which sends constant events from the salt master to the salt minions.

Salt was created in 2011 to stop a lot of manual work on servers.  So a person would typically log into a linux server and apply application configuration to a device manually.  Obviously, like network devices doing everything by hand is extremely time consuming.  Salt started off as a configuration management only simply having a agent on each of the linux machines which then talked back to the master. Salt is written in 100% python which is extremely nice because a lot of salt can be modified to the users needs. Salt supports many different templating languages the most popular is Jinja. 

The general idea of salt is that everything is done within the master node(s).  The master like the name suggests controls the minions.  The master does remote execution which means it will send data to run through the minion to be remotely executed.  In the state of the minion agent EOS opens up a unix socket which the device talks back to itself upon.  Salt can be installed within a few minutes within [this link](https://docs.saltstack.com/en/latest/topics/tutorials/walkthrough.html).


##Common questions
#Salt vs Saltstack.

Salt is the open source version of saltstack open for any developement.

#What ports need to be open for the salt master and salt minions to talk?

UCP/TCP port 4505 and 4506.

#How is this differnt than Ansible, Chef and Puppet?
Salt accomplishes the same thing as the other popular configuration management tools ie it will apply configuration, render templates etc.  However, what is extremely unique to salt is that it has a modern ZeroMQ bus between minions and master node(s).  So anything that happens within the salt minion is sent to the salt master as a sort of event.  These events can even be sent externally to logging systems or salt can react to events that happen over the network bus.  The idea is that instead of a human constantly creating playbooks or making changes the system operates autonomously.  Salt like other configuration management systems has 3rd party integration into devices other than networking devices ie VMware, AWS etc.  


#How does the minion talk to the master?
With the salt agent the minion will talk to the salt master over the ZeroMQ bus over TCP ports 4506.  The interesting part of the way salt works is that since it is a secure connection that the master has to accept there is no username/password that is required for the salt agent to talk to the master. This also means every time a device is brought online the master has to accept it.  This can be automated but also allows for a secure connection instead of a constant api connection where a username and password are needed.

#What is the network driver within salt?
One of the many advantages of saltstack is that it can communicate to the minions through the ZeroMQ bus in a datastructure in which it understands.  In that datastructure the master simply passes data in the bus instructing the minion to use a module which is installed on the minion and pass data into it.  The drivers that are commonly used are [Napalm or net module](https://docs.saltstack.com/en/latest/ref/modules/all/salt.modules.network.html) and [pyeapi](https://docs.saltstack.com/en/latest/ref/modules/all/salt.modules.arista_pyeapi.html)
