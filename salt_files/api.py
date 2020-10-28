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
