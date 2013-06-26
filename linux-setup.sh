#!/bin/sh

# This file should be run on the linux machine that will be running docker
# it is set up as the provisioning file for vagrant images, but can be run
# manually if you are not using vagrant

sudo apt-get install -q -y curl
# if you are paying attention, no get.docker.io does NOT use https
curl get.docker.io | sudo sh -x
sudo apt-get install -y -q python-all-dev
sudo apt-get install -y -q python-pip
sudo apt-get install -y -q git
pip install -U pip
sudo mkdir -p /usr/local/etc/jiffylab/
WHO=$(whoami)
if [ $WHO == 'vagrant' -o -d /vagrant/ ]
    then
        # if on vagrant
        cp -R /vagrant/* /usr/local/etc/jiffylab/
    else
        cp -r ./* /usr/local/etc/jiffylab/
fi

pip install -r /usr/local/etc/jiffylab/webapp/requirements.txt

stop dockerd
echo "
start on startup
exec /usr/local/bin/docker -d" > /etc/init/dockerd.conf
start dockerd
# add a modicum of security - don't run the webapp as root
useradd jiffylabweb
iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 5000
chown -R jiffylabweb /usr/local/etc/jiffylab/webapp/

docker pull ptone/jiffy-base
# docker build /usr/local/etc/jiffylab/docker-builds/base

echo "
start on startup
pre-start script
   iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 5000
end script
exec sudo -u jiffylabweb /usr/bin/python /usr/local/etc/jiffylab/webapp/server.py
" > /etc/init/jiffylabweb.conf

start jiffylabweb

