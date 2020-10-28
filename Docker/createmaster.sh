#Having to add this because of https://rtfm.co.ua/en/docker-configure-tzdata-and-timezone-during-build/ with tzdata for example
TZ=America/New_York

echo "Adding salt directories"
mkdir -p /srv/salt/
mkdir -p /srv/salt/pillar/
mkdir -p /srv/salt/states/
mkdir -p /srv/salt/states/vlans/
mkdir -p /srv/salt/states/bgp/
mkdir -p /srv/salt/templates/
mkdir -p /srv/salt/templates/intended
mkdir -p /srv/salt/templates/intended/configs
mkdir -p /srv/salt/templates/intended/structured_configs/
mkdir -p /srv/salt/_grains/
mkdir -p /srv/salt/reactor

echo "setting timezone"
ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
echo $TZ

echo "Getting infrasture packages"
apt-get update && apt-get install sudo tree wget python-cffi libxslt1-dev libffi-dev libssl-dev default-jre python3-pip python3-dev python-pip python-dev git net-tools iputils-ping mtr vim curl -y 

echo "fixing the default ubuntu pyOpenSSL issue"
pip3 install --upgrade pyOpenSSL 

echo "Install napalm EOS libraries"
pip3 install napalm

echo "upgrading cherrypy for api server"
pip3 install --upgrade cherrypy

echo "Installing salt components"
wget -O - https://repo.saltstack.com/py3/ubuntu/18.04/amd64/latest/SALTSTACK-GPG-KEY.pub |  apt-key add -
echo deb http://repo.saltstack.com/py3/ubuntu/18.04/amd64/latest bionic main >> /etc/apt/sources.list.d/saltstack.list
apt-get update 
apt-get install salt-master salt-minion salt-ssh salt-api -y 

echo "restarting the master service"
service salt-master restart

echo "getting salt keys"
salt-call --local tls.create_self_signed_cert

echo "adding api user"
useradd saltdev

echo "saltdev:saltdev" | chpasswd
usermod -aG sudo saltdev

echo "Opening master file and putting it in place of current master file"
rm /etc/salt/master
touch /etc/salt/master 
cat $PWD/master >> /etc/salt/master 

echo "Adding proxy information"
touch /etc/salt/proxy
echo master: salt >> /etc/salt/proxy

echo "restarting salt-master and starting api-server"
service salt-master start
service salt-api start