#!/bin/sh

# This file should be run on the linux machine that will be running docker
# it is set up as the provisioning file for vagrant images, but can be run
# manually if you are not using vagrant. It should be run as root.

# note that all of the sudo usage in this script is due to the uncertainty
# of the provisioning user by vagrant.

# sudo -s << EOF
sudo apt-get install -q -y curl
# if you are paying attention, no get.docker.io does NOT use https
curl get.docker.io | sudo sh -x
sudo apt-get install -y -q python-all-dev
sudo apt-get install -y -q python-pip
sudo apt-get install -y -q git
sudo pip install -U pip
sudo mkdir -p /usr/local/etc/jiffylab/
WHO=$(whoami)
if [ $WHO=='vagrant' -o -d /vagrant/ ]
    then
        echo "running via vagrant"
        sudo cp -R /vagrant/* /usr/local/etc/jiffylab/
    else
        echo "not running via vagrant"
        sudo cp -r ./* /usr/local/etc/jiffylab/
fi

sudo pip install -r /usr/local/etc/jiffylab/webapp/requirements.txt

sudo stop dockerd
sudo echo "
start on startup
exec /usr/local/bin/docker -d -H 127.0.0.1:4243" > /etc/init/dockerd.conf
sudo start dockerd
# add a modicum of security - don't run the webapp as root
sudo useradd jiffylabweb
sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 5000
sudo chown -R jiffylabweb /usr/local/etc/jiffylab/webapp/

docker pull ptone/jiffylab-base
# docker build /usr/local/etc/jiffylab/docker-builds/base

sudo echo "
start on startup
pre-start script
   iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 5000
end script
exec sudo -u jiffylabweb /usr/bin/python /usr/local/etc/jiffylab/webapp/server.py
" > /etc/init/jiffylabweb.conf

sudo start jiffylabweb
# EOF
