Salt typically applies a best [practices rule](https://docs.saltstack.com/en/latest/topics/best_practices.html) that puts all of the salt structure within the /srv/salt directory similar to this repo.


```
|-- _grains
|-- pillar
|-- reactors
|-- states
|-- templates
```

## _grains

Grains are any custom grains which are sent from the salt master to the salt minions. 

## pillar

Pillars are secrets which are stored as variables.  For example, to start the salt proxy minion the salt proxy minion has to know the switch it needs to proxy to as well as a username/password.

## reactors

Reactors are exactly what they sound like.  Anything which is sent back and forth within the salt ZeroMQ bus you can react to.  So for example, salt often includes Key value pairs within the ZeroMQ bus.  You can key off of anything you want and send the data to a external system.  So if you have a switch which is provsioning you can then react on that to tell a external system say slack to tell the channel the switch is currently provisioning. 

## states

States are exactly what they sound like.  A state is the state of a given salt minion.  For example, a state might be a one time configuration to configure a server for things like apache and mysql.  In our lab there is a state to render configuration and a state to then push the configuration.  States are a deterministic way to push a state to a salt minion.

## templates

Templates hold templates of certain devices.  In all of our examples templates hold the jinja2 templates for each of the configurations.

## .sls extensions

Salt uses the .sls extension whithin any salt file.  So for example, any of the state files will end with a .sls for example */srv/salt/states/push_vlans.sls* which is a state module to push vlans to a device with the [pyeapi module](https://docs.saltstack.com/en/latest/ref/modules/all/salt.modules.arista_pyeapi.html).

Salt has methods in which is finds its state files in which it calls the [file roots](https://docs.saltstack.com/en/latest/ref/file_server/file_roots.html) which is configerable via the [salt master file](https://docs.saltstack.com/en/latest/ref/configuration/master.html) which in our docker salt container can be found within the /etc/salt/master.  There is also pillar_roots which is the same concept of where to check for pillars. 

```
file_roots:

  base:
    - /srv/salt
    - /srv/salt/states
    - /srv/salt/pillar
    - /srv/salt/states
    - /srv/salt/templates/
    - /srv/salt/reactor/

pillar_roots:
  base:
    - /srv/salt
    - /srv/salt/templates
    - /srv/salt/pillar
    - /srv/salt/states

```

Salt in all actuallity is just a giant file server on the master serving up files to the minions over the ZeroMQ bus and rendering each one to the minions. 

# top.sls & pillar items

Salt uses the concept of [top.sls](https://docs.saltstack.com/en/master/ref/configuration/master.html#std-conf_master-state_top) which is more or less a manifest for each minion and what states or items each minions will receive.  We will get into that on the next portion talking about proxy minions. 

A top example using general servers would be as follows.

```
#top.sls
base:
  '*'
    - apache
  'os:Fedora':
    - match: grain
    - mysql

#apache.sls
apache:
  pkg:
    - installed 

#mysql.sls
mysql:
  pkg:
    - installed 
```

In the following example everything denoted with the * will recieve the apache package.  Only the operating systems with Fedora will receive mysql and apache.  So if we were to have a minion with any form of Debian/Ubuntu it would not receive the mysql package.