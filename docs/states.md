States are exactly what they sound like.  A state is the state of a given salt minion.  For example, a state might be a one time configuration to configure a server for things like apache and mysql.  In our lab there is a state to render configuration and a state to then push the configuration.  States are a deterministic way to push a state to a salt minion.

Lets look at one of the states for the basic bgp configuration lab.

```
#/srv/salt/states/basic_bgp_render.sls
render the output:
  file.managed:
    - name: /srv/salt/templates/intended/configs/{{ hostname }}.cfg
    - source: /srv/salt/templates/basic_bgp.j2
    - template: jinja
```

Taking this state line by line. 

*render the output:* - This can be anything just the name of the state.

*file.managed:* - Using the [file module](https://docs.saltstack.com/en/latest/ref/modules/all/salt.modules.file.html) to later pass in name, source and template.

*name: /srv/salt/templates/intended/configs/{{ hostname }}.cfg* - This is telling the [file module](https://docs.saltstack.com/en/latest/ref/modules/all/salt.modules.file.html) to save any rendered config to that path name.  So for example if we run the state *salt 'leaf1' state.sls basic_bgp_render* this will then output the file to */srv/salt/templates/intended/configs/leaf1*

*- source: /srv/salt/templates/basic_bgp.j2* - This is the source of the bgp template we are rendering.

*- template: jinja* - use the jinja2 templating engine.

## Running the sale state

To run any salt state the state.sls execution module has to be ran.

*Note do not include the .sls extension when running basic_bgp_render also, if you put a file directory called bgp within the states file you must call bgp.basic_bgp_render as salt uses python dotted notation.*

```
salt 'base_lab_Leaf1' state.sls basic_bgp_render
base_lab_Leaf1:
----------
          ID: render the output
    Function: file.managed
        Name: /srv/salt/templates/intended/configs/base_lab_Leaf1.cfg
      Result: True
     Comment: File /srv/salt/templates/intended/configs/base_lab_Leaf1.cfg is in the correct state
     Started: 14:59:30.537848
    Duration: 361.574 ms
     Changes:   

Summary for base_lab_Leaf1
------------
Succeeded: 1
Failed:    0
------------
Total states run:     1
Total run time: 361.574 ms
```


