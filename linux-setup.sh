sudo apt-get install -q -y curl
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
# docker pull ptone/jiffy-base
docker build /usr/local/etc/jiffylab/docker-builds/base
echo "exec python /usr/local/etc/jiffylab/webapp/server.py" > /etc/init/jiffylabweb.conf
start jiffylabweb

