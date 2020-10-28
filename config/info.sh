#Find a way to start the proxy minions every time like systemctl
#test rendering
#salt 'spine*' slsutil.renderer /srv/salt/templates/spines.j2 'jinja' 

#Render configs
#salt 'spine*' state.sls render_config
#push via napalm
#API testing to deploy everything from the api? 
#sudo salt spine2 net.load_template salt://templates/intended/configs/spine2.cfg test=True debug=true 
#salt 'spine1' pyeapi.run_commands 'show version' 'show interfaces'
#Make sure config file has full permissions dur dur
#salt 'base_lab_Leaf2' pillar.items --out=yaml
Structure:
 - Why salt
  - Purpose of this repo
  - prerequeqesists  
  - Salt components

 - install
   - docker-topo explain 
   - ceos explain 
   - Dockerfile explain 


 - Salt File structure 
   - base/pillar roots
   - /srv/salt directories  
   - grains,pillars, etc
   - .sls files 
   - top.sls 
   - Minion discovery

 - proxy minions / agents 
 - How the bus works / ZeroMQ bus 
 - Grains
 - Pillars
 - States
 - reactors
 - Mines
 - Forumlas
 - salt api 
 - Sproxy 
 - Salt mines  

docker-topo --create base_lab.yml && docker run --name salt -dit -v $PWD/salt_files/:/srv/salt -p 8999:8999 --network=base_lab_net-0 70133de29164

ed65fe96aef0
"Echo start the salt master"
service salt-master start && service salt-api start

echo "Start spine proxies"
salt-proxy --proxyid=base_lab_Spine2 -d
salt-proxy --proxyid=base_lab_Spine1 -d
salt-proxy --proxyid=base_lab_Leaf1 -d
salt-proxy --proxyid=base_lab_Leaf2 -d


# Salt links
https://docs.saltstack.com/en/getstarted/fundamentals/ # Salt fundamentals 
https://docs.saltstack.com/en/latest/topics/troubleshooting/yaml_idiosyncrasies.html
https://github.com/mirceaulinic/salt-sproxy
https://docs.saltstack.com/en/latest/ref/states/index.html#state-system-reference #Salt references 
https://docs.saltstack.com/en/latest/glossary.html #Salt glossary 
