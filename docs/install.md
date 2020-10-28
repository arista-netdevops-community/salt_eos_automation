## To start the lab 

#### Import the ceoslab file 
`
docker import cEOS-lab-4.23.2F.tar.xz ceosimage:4.23.2f 
`

#### Create the docker salt container for this lab
`
docker create --name salt -dit -v $PWD/salt_files/:/srv/salt -p 8999:8999 --network=base_lab_net-0 burnyd/salt
`
#### Install docker-topo
`
pip install git+https://github.com/networkop/docker-topo.git
`

#### Run docker topo and salt Docker container.
`
docker-topo --create base.yml && docker-topo --create base_lab.yml && docker start salt
`

###### This will create the infrastructure described within the base_lab.yml file 

#### Examining the lab 
```
docker ps 

CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                                                                 NAMES
79d74ab70901        ceosimage:4.23.2F   "/sbin/init systemd.…"   28 seconds ago      Up 25 seconds       0.0.0.0:8801->80/tcp, 0.0.0.0:9001->443/tcp, 0.0.0.0:7001->6030/tcp   base_lab_Leaf2
0eeaa096e20e        ceosimage:4.23.2F   "/sbin/init systemd.…"   31 seconds ago      Up 28 seconds       0.0.0.0:8800->80/tcp, 0.0.0.0:9000->443/tcp, 0.0.0.0:7000->6030/tcp   base_lab_Leaf1
296b86bea528        ceosimage:4.23.2F   "/sbin/init systemd.…"   33 seconds ago      Up 31 seconds       0.0.0.0:8803->80/tcp, 0.0.0.0:9003->443/tcp, 0.0.0.0:7003->6030/tcp   base_lab_Spine2
111f7ce06ede        ceosimage:4.23.2F   "/sbin/init systemd.…"   35 seconds ago      Up 33 seconds       0.0.0.0:8802->80/tcp, 0.0.0.0:9002->443/tcp, 0.0.0.0:7002->6030/tcp   base_lab_Spine1
37a2dfecbdfb        70133de29164        "/bin/sh -c 'tail -f…"   40 seconds ago      Up 40 seconds ago         0.0.0.0:8999->8999/tcp                                                salt
```

#### Console into the lab Start the salt-minions and accept the keys.
```
docker exec -it salt bash 

service salt-master start

salt-proxy --proxyid=base_lab_Spine2 -d
salt-proxy --proxyid=base_lab_Spine1 -d
salt-proxy --proxyid=base_lab_Leaf1 -d
salt-proxy --proxyid=base_lab_Leaf2 -d
```

#### List the salt keys (salt-key -L) and accept the salt-keys from the minions (salt-key -A)
```
salt-key -L

Accepted Keys:
Denied Keys:
Unaccepted Keys:
base_lab_Leaf1
base_lab_Leaf2
base_lab_Spine1
base_lab_Spine2

salt-key -A
The following keys are going to be accepted:
Unaccepted Keys:
base_lab_Leaf1
base_lab_Leaf2
base_lab_Spine1
base_lab_Spine2
```

#### Provide a test ping for all minions (salt '*' test.ping)
```
Proceed? [n/Y] Y
Key for minion base_lab_Leaf1 accepted.
Key for minion base_lab_Leaf2 accepted.
Key for minion base_lab_Spine1 accepted.
Key for minion base_lab_Spine2 accepted.

salt '*' test.ping
base_lab_Leaf2:
    True
base_lab_Spine2:
    True
base_lab_Spine1:
    True
base_lab_Leaf1:
    True
```

#### Destroy the lab 
`
docker-topo --destroy base.yml && docker-topo --create base_lab.yml && docker stop salt
`


