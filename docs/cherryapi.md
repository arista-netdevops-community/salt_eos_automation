Salt offers a very easy to use API based off of [cherrypy](https://cherrypy.org/)

## Master file.
The api itself requires some small configuration within the master file.

```
external_auth:
 pam:
   saltdev:
     - .*

rest_cherrypy:
  port: 8999
  ssl_crt: /etc/pki/tls/certs/localhost.crt
  ssl_key: /etc/pki/tls/certs/localhost.key
```

## Create the ssl cert for the master.
Afterwards the cherrypy ssl certs have to be created.
```
salt-call --local tls.create_self_signed_cert
```

## Restart the salt-api
```
service salt-api start
```

## Usage of the salt api

The salt API is very simple.  The idea is that you can pass in any salt information you would generally do via the salt cli through the API.

First step is authenticate and receive a token.  Second step is to use the token and send salt commands.

## Example script.
```
#/srv/salt/api/.py
#!/usr/bin/env python3.6

import requests
import json
import os 
import subprocess

salt_ip = '127.0.0.1'
port = 8999
user = 'saltdev'
password = 'saltdev'

requests.packages.urllib3.disable_warnings()

def get_token():
    headers = {'Content-type':'application/json'}
    urltoken = ('https://{}:{}/login').format(salt_ip, port)
    data = {"username":str(user), "password":str(password), "eauth":str('pam')}
    json_data = json.dumps(data)
    r = requests.post(urltoken, headers=headers, verify=False, data=json_data)
    r_data = (json.loads(r.content))
    return(r_data['return'][0]['token'])

def make_request(token):
    headers = {'Content-type':'application/json', 'X-Auth-Token': token}
    restcall = ('https://{}:{}').format(salt_ip, port)
    data = {"client":str("local"), "tgt":str("*"), "fun":str("net.arp")}
    json_data = json.dumps(data)
    r = requests.post(restcall, headers=headers, verify=False, data=json_data)
    r_data = (json.loads(r.content))
    print(json.dumps(r_data['return'][0], indent=4))

def main():
    make_request(get_token())

if __name__ == '__main__':
    main()
```

## Running the script

The output of this script will then provide arp outputs for each device.

```
root@a8519e13fd15:/srv/salt# python3.6 api.py 
{
    "base_lab_Spine2": {
        "out": [
            {
                "interface": "Ethernet1",
                "mac": "02:42:C0:A8:A0:03",
                "ip": "10.1.0.1",
                "age": 3262.0
            }
        ],
        "result": true,
        "comment": ""
    },
    "base_lab_Spine1": {
        "out": [],
        "result": true,
        "comment": ""
    },
    "base_lab_Leaf1": {
        "out": [
            {
                "interface": "Ethernet1",
                "mac": "02:42:C0:2E:A3:34",
                "ip": "10.0.0.2",
                "age": 4128.0
            },
            {
                "interface": "Ethernet2",
                "mac": "02:42:C0:A8:A0:02",
                "ip": "10.1.0.2",
                "age": 3263.0
            }
        ],
        "result": true,
        "comment": ""
    },
    "base_lab_Leaf2": {
        "out": [],
        "result": true,
        "comment": ""
    }
}
```


