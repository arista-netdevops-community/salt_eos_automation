![BGP topology](images/basic_bgp.jpg?raw=true)

In this example we will render a configuration that will render configurations for all devices to create a full BGP configuration using the saltstack [state execution module](https://docs.saltstack.com/en/latest/ref/states/all/salt.states.module.html) called state.sls. 

##Make sure that all proxy minions are running.

```
root@a00c23e5231c:/srv/salt# salt '*' test.ping
base_lab_Leaf1:
    True
base_lab_Spine2:
    True
base_lab_Spine1:
    True
base_lab_Leaf2:
    True
```
Everything  to make the state work is located within the /srv/salt/states directory.  Since the file roots use that as a directory salt is able to serve those files to the minions.

## Salt state basic_bgp_render.sls
```
{% set hostname = grains.get('host') %}
render the output:
  file.managed:
    - name: /srv/salt/templates/intended/configs/{{ hostname }}.cfg
    - source: /srv/salt/templates/basic_bgp.j2
    - template: jinja
```

Taking a look at this the state this will take a device like base_lab_leaf1 and use the jinja template which is located within /srv/salt/templates/basic_bgp.j2 and will render this using Jinja and save the output within /srv/salt/templates/intended/configs/base_lab_Leaf1.cfg.  

Just a small snippet of the jinja2 template.

```
{% set hostname = grains.get('host') -%}
{% set template_location = '/srv/salt/templates/intended/structured_configs/' + hostname + '.yaml' -%}
{% import_yaml template_location as device_info -%}
{% if device_info['leaf_allowed_vlans'] is defined and device_info['leaf_allowed_vlans'] is not none -%}
{% for vlan in device_info['leaf_allowed_vlans'] -%}
vlan {{ vlan }}
```

## Checking to see if the template will render.
```
root@a00c23e5231c:/srv/salt# salt 'base_lab_Leaf1' slsutil.renderer /srv/salt/templates/basic_bgp.j2 'jinja'
base_lab_Leaf1:
vlan 130 
! 
vlan 131 
! 
vlan 140 
!
hostname base_lab_Leaf1
```

To explain how this works this salt command will taget base_lab_Leaf1 and use the [slsutil module and rendere function](https://docs.saltstack.com/en/master/ref/modules/all/salt.modules.slsutil.html#salt.modules.slsutil.renderer) just to make sure that this rendering will actually work.

Now that we know this will render correctly lets render all files.

### Rendering configuration 

## rendering the basic_bgp_render.sls state 
```
root@a00c23e5231c:/srv/salt# salt '*' state.sls basic_bgp_render 
base_lab_Spine1:
----------
          ID: render the output
    Function: file.managed
        Name: /srv/salt/templates/intended/configs/base_lab_Spine1.cfg
      Result: True
     Comment: File /srv/salt/templates/intended/configs/base_lab_Spine1.cfg is in the correct state
     Started: 15:20:53.617619
    Duration: 425.391 ms
     Changes:   
```

The config is currently located within the /srv/salt/templates/intended/configs/base_lab_Spine1.cfg ready to be pushed out to all the devices a long with spine2,leaf1 and leaf2.

```
root@a00c23e5231c:/srv/salt# ls -l templates/intended/configs/
total 32
-rwxr-xr-x 1 saltdev saltdev 7792 Nov 10 12:06 base_lab_Leaf1.cfg
-rwxr-xr-x 1 saltdev saltdev 7798 Nov 10 12:06 base_lab_Leaf2.cfg
-rwxr-xr-x 1 saltdev saltdev 2104 Nov 10 12:06 base_lab_Spine1.cfg
-rwxr-xr-x 1 saltdev saltdev 2104 Nov 10 12:06 base_lab_Spine2.cfg
```

### Using the pyeapi salt module to push config

We will use the [pyeapi salt state module](https://docs.saltstack.com/en/latest/ref/modules/all/salt.modules.arista_pyeapi.html) to push each of the configs to the devices.

Example of /srv/salt/states/push_config.sls

```
{% set hostname = grains.get('host') %}
pyeapi.config:
  module.run:
    - config_file: /srv/salt/templates/intended/configs/{{hostname}}.cfg
```
This is rather simple.  This state will simply push out the configuration for each device based off of its own hostname.

```
root@a00c23e5231c:/srv/salt# salt '*' state.sls push_config
base_lab_Spine2:
----------
          ID: pyeapi.config
    Function: module.run
      Result: True
     Comment: Module function pyeapi.config executed
     Started: 15:28:36.625957
    Duration: 2562.588 ms
     Changes:   
              ----------
              ret:
                  --- 
                  +++ 
                  @@ -1,23 +1,26 @@
                  +!
                  +transceiver qsfp default-mode 4x10G
                   !
                   service routing protocols model multi-agent
                   !
                   logging host 1.2.3.4 514
                   !
                  -hostname spine2
                  +hostname base_lab_Spine2
```

Truncated most of the push for length of each device.

### SSH or exec into either devices. 

```
base_lab_Leaf2#show ip bgp summary 
BGP summary information for VRF default
Router identifier 192.168.255.6, local AS number 65102
Neighbor Status Codes: m - Under maintenance
  Neighbor         V  AS           MsgRcvd   MsgSent  InQ OutQ  Up/Down State   PfxRcd PfxAcc
  10.0.0.6         4  65000              7         7    0    0 00:01:32 Estab   4      4
  10.1.0.6         4  65000              7         7    0    0 00:01:32 Estab   4      4
```