#!/bin/sh

# This file should be run on the linux machine that will be running docker
# it is set up as the provisioning file for vagrant images, but can be run
# manually if you are not using vagrant. It should be run as root.

# note that all of the sudo usage in this script is due to the uncertainty
# of the provisioning user by vagrant.

sudo apt-get install -q -y curl
curl https://get.docker.io | sudo sh -x
sudo apt-get install -y -q python-all-dev
sudo apt-get install -y -q python-pip
sudo apt-get install -y -q git
sudo pip install -U pip
sudo mkdir -p /usr/local/etc/jiffylab/
WHO=$(whoami)
if [ $WHO = 'vagrant' -o -d /vagrant/webapp/ ]
    then
        echo "running via vagrant"
        sudo cp -R /vagrant/* /usr/local/etc/jiffylab/
    else
        echo "not running via vagrant"
        sudo cp -r ./* /usr/local/etc/jiffylab/
fi

sudo pip install -r /usr/local/etc/jiffylab/webapp/requirements.txt

# users the docker group can access the docker command and remote API
sudo groupadd docker
sudo useradd -g docker jiffylabweb

sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 5000
sudo chown -R jiffylabweb /usr/local/etc/jiffylab/webapp/

docker pull ptone/jiffylab-base
# docker build /usr/local/etc/jiffylab/docker-builds/base

# add a modicum of security - don't run the webapp as root
sudo echo "
start on startup
pre-start script
   iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 5000
end script
exec sudo -u jiffylabweb /usr/bin/python /usr/local/etc/jiffylab/webapp/server.py
" > /etc/init/jiffylabweb.conf

sudo start jiffylabweb
