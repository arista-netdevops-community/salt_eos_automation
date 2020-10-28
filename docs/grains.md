Salt [grains](https://docs.saltstack.com/en/latest/ref/modules/all/salt.modules.grains.html) are meta data about a salt minion in which you can use to etheir render configs or target devices based off things like different operating systems or ethernet nics.

## showing grains.

```
#Salt master 
salt 'base_lab_Leaf2' grains.items 

base_lab_Leaf2:
    ----------
    cpuarch:
        x86_64
    cwd:
        /
    dns:
        ----------
        domain:
        ip4_nameservers:
            - 127.0.0.11
        ip6_nameservers:
        nameservers:
            - 127.0.0.11
        options:
            - ndots:0
        search:
        sortlist:
    fqdns:
        - a8519e13fd15
    gpus:
    host:
        base_lab_Leaf2
    hostname:
        leaf2
    hwaddr_interfaces:
        ----------
        eth0:
            02:42:ac:19:00:02
    id:
        base_lab_Leaf2
    interfaces:
        - Ethernet1
        - Ethernet2
        - Ethernet3
        - Ethernet4
        - Loopback0
        - Loopback1

```

## Targeting minions based off of grains.

Targeting all minions that have eos as a OS.

```
salt  -G 'os:eos' cmd.run 'uname'
base_lab_Leaf2:
    Linux
base_lab_Leaf1:
    Linux
base_lab_Spine1:
    Linux
base_lab_Spine2:
    Linux
```