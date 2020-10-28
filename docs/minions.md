Salt has two typical ways of deployment for network nodes minion nodes. 

* Salt native minion - This is a minion install on the switch operating system itself in the form of a extension just like a linux server.
* Salt proxy minion - This is a service which will run either on the master or somewhere externally which will proxy for example, all api request to the switch back to the master and over the ZeroMQ bus.  The reasoning for this is a lot of people do not like to run the actual salt minion on the network OS.

If you recall all the minions work in a master/minion style of functionality.  So the minion will start up discover the salt master and the master then has to accept the key from the minon.

![Lab topology](images/salteos.jpg?raw=true)

## Salt discovery

Upon a salt minion being installed it needs to find the salt master.  The default way is having a dns lookup for the hostname of *salt* this is also configurable within the minion config file under /etc/salt/minion

```
#/etc/salt/minion
master: 1.2.3.4
```

The salt minion will then try to negotiate a secure connection to 1.2.3.4 once the connection is made the salt master will have to accept the connection.  This can either be manual or automatic.  The good part about salt versus other configuration management platforms is that salt does not require a username/password. 

![minios](images/minions-accept.jpg?raw=true)

In this example the salt minion is brought online.  Once online it has to find its master.  In a manual mode the master issues a 'salt-key -L' which will scan for new nodes.  The 'salt-key -A' command will accept all new minion nodes.

## Salt native minion 

![minions](images/nativeminion.jpg?raw=true)

A salt native minion is the typical way of installing a linux minion that will sit on the device and communicate with the underlying host itself and send the data back to the master.  At the time of writing this the native minion is almost GA and will be out at any point.  Right now the minion will use either pyeapi or napalm to configure the device.

## Salt native minion 

![minions](images/proxyminions.jpg?raw=true)

Running the lab we typically start with *salt-proxy --proxyid=base_lab_Leaf1 -d* what this does is run a proxy process using the proxyid of *base_lab_leaf1* salt-proxy itself will read the /srv/salt/pillars/top.sls file and find the proxies in which it needs to match *base_lab_leaf1* for the proxy info.

```
#/srv/salt/pillar/top.sls
base:
  base_lab_Spine1:
    - base_lab_Spine1
  base_lab_Spine2:
    - base_lab_Spine2
  base_lab_Leaf1:
    - base_lab_Leaf1
  base_lab_Leaf2:
    - base_lab_Leaf2

#base_lab_Leaf1.sls
proxy:
  proxytype: napalm
  driver: eos
  host: base_lab_Leaf1
  username: arista
  password: arista

pyeapi:
  username: arista
  password: arista
  transport: http
```

The top file will command the proxy to pickup the pillars for base_lab_Leaf1.sls which allows the execution modules of both proxy modules for pyeapi and napalm.  So the execution modules for either will work ie *salt 'base_lab_Leaf1.sls' net.arp' will display the arp packets.  Since napalm is the same as the net execution module.


