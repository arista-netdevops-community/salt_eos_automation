Salt utilizes a ZeroMQ bus within the communication between the salt master and salt minions.  The salt master fires off events directly from the bus to the minions where the minion will receive structured data and that data is then passed into a module.  

## Stop the master and put it in debug mode.
```
 service salt-master stop
```

## Debug the salt master 
```
 salt-master -l debug
```

Opening up another terminal and exec into the salt master we can see through the debug screen all of the data which is passed back and forth through the ZeroMQ bus.

```
#Salt master cli 
salt 'base_lab_Leaf2' net.cli 'show version'

#Salt master debug 

[DEBUG   ] Sending event: tag = salt/job/20201027182445049986/new; data = {'jid': '20201027182445049986', 'tgt_type': 'glob', 'tgt': 'base_lab_Leaf2', 'user': 'root', 'fun': 'net.cli', 'arg': ['show version'], 'minions': ['base_lab_Leaf2'], 'missing': [], '_stamp': '2020-10-27T18:24:45.055000'}

#Salt minion sending data back through the bus.

[DEBUG   ] Sending event: tag = salt/job/20201027182445049986/ret/base_lab_Leaf2; data = {'cmd': '_return', 'id': 'base_lab_Leaf2', 'success': True, 'return': {'out': {'show version': ' cEOSLab\nHardware version:    \nSerial number:       \nSystem MAC address:  0242.c083.e816\n\nSoftware image version: 4.23.2F\nArchitecture:           i686\nInternal build version: 4.23.2F-15405360.4232F\nInternal build ID:      4cde5c53-3642-4934-8bcc-05691ffd79b3\n\ncEOS tools version: 1.1\n\nUptime:                 0 weeks, 5 days, 18 hours and 16 minutes\nTotal memory:           32970568 kB\nFree memory:            18146044 kB\n\n'}, 'result': True, 'comment': ''}, 'retcode': 0, 'jid': '20201027182445049986', 'fun': 'net.cli', 'fun_args': ['show version'], '_stamp': '2020-10-27T18:24:45.484923'}

```

What this means is anything can happen through the salt bus and we can react to this we will later get to reactors.  This also means that to render templates or use certain data we can pull this from the salt master.  