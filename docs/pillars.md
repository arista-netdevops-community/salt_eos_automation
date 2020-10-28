Pillars are secrets/sensitive data which are stored as variables.  For example, to start the salt proxy minion the salt proxy minion has to know the switch it needs to proxy to as well as a username/password.

Running the lab we typically start with *salt-proxy --proxyid=base_lab_Leaf1 -d* what this does is run a proxy process using the proxyid of *base_lab_leaf1* salt-proxy itself will read the /srv/salt/pillars/top.sls file and find the proxies in which it needs to match *base_lab_leaf1* for the proxy info.

These are all pillars files.

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

To find the given pillar items per node you would issue the following.

```
salt 'base_lab_Leaf1' pillar.items
base_lab_Leaf1:
    ----------
    proxy:
        ----------
        driver:
            eos
        host:
            base_lab_Leaf1
        password:
            arista
        proxytype:
            napalm
        username:
            arista
    pyeapi:
        ----------
        host:
            base_lab_Leaf1
        password:
            arista
        transport:
            http
        username:
            arista
```