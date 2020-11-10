Salt proxies are used a proxy for devices within salt that cannot run an agent locally on the minion.  For example, network switches that cannot run a minion or VMware ESXi that cannot run a linux process for the minion directly within the hypervisor.  When it comes to proxies the proxy should not have to be ran at all times because the only time we really care about the proxy is when we are truly using salt events like rendering configuration or general salt events.

That being said the salt [super proxy](https://salt-sproxy.readthedocs.io/en/latest/) was born(sproxy).  The idea behind the sproxy is that it will not always run in a different location or on the master consuming memory.  The sproxy will only run when the client is then targetting a salt aspect.  

## Installing sproxy services

```
pip3 install salt-sproxy
```
 
check to see if the master is running 

```
service salt-master status
```

If not start the salt-master with the following
```
service salt-master start 
```

## Accept 1 proxy minion 

```
salt-proxy --proxyid=base_lab_Leaf1 -d

root@a00c23e5231c:/srv/salt# salt-key -A
The following keys are going to be accepted:
Unaccepted Keys:
base_lab_Leaf1
Proceed? [n/Y] Y

root@a00c23e5231c:/srv/salt# salt-key -L
Accepted Keys:
base_lab_Leaf1
Denied Keys:
Unaccepted Keys:
Rejected Keys:

root@a00c23e5231c:/srv/salt# salt '*' test.ping
base_lab_Leaf1:
    True


```

Everything seems to work and we have a proxy running for base_lab_Leaf1.  We do not have a proxy running for the other 3 devices.

This is where sproxy comes into place.  Because we have a pillar file setup for the other devices sproxy will read the pillar file and know that it typically is a proxy minion.  Lets test this out with base_lab_Leaf2.  Keep in mind the master DOES NOT know that this proxy minion exsits.

```
root@a00c23e5231c:/srv/salt# salt-sproxy 'base_lab_Leaf2' test.ping
base_lab_Leaf2:
    True
root@a00c23e5231c:/srv/salt# salt-sproxy 'base_lab_Leaf2' net.cli 'show version'
base_lab_Leaf2:
    ----------
    comment:
    out:
        ----------
        show version:
             cEOSLab
            Hardware version:    
            Serial number:       
            System MAC address:  0242.c083.e816
            
            Software image version: 4.23.2F
            Architecture:           i686
            Internal build version: 4.23.2F-15405360.4232F
            Internal build ID:      4cde5c53-3642-4934-8bcc-05691ffd79b3
            
            cEOS tools version: 1.1
            
            Uptime:                 2 weeks, 5 days, 17 hours and 13 minutes
            Total memory:           32970568 kB
            Free memory:            18791272 kB
            
    result:
        True
```

So the sproxy will run every time the command is listed then it will turn down every time it is finished.  Right now this will work with either a master config or with what is called a roster file.  This makes sproxy a very attractive use case for things like one time rendering the way a typical ansible playbook would work.


