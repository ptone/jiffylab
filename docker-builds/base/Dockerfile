# Sets up a container for the web based lab login
#
# VERSION               0.0.1

# At some point, more of this will be pushed into its own docker image

FROM      ubuntu
MAINTAINER Preston Holmes "preston@ptone.com"

RUN echo 'deb http://archive.ubuntu.com/ubuntu quantal main universe multiverse' > /etc/apt/sources.list
# RUN echo 'deb http://archive.ubuntu.com/ubuntu main universe multiverse' > /etc/apt/sources.list
RUN apt-get update -qq
RUN apt-get install -y -q curl
RUN apt-get install -y -q sudo
RUN apt-get install -y -q python-dev
RUN apt-get install -y -q python-pip
RUN apt-get install -y -q git-core

# gcc and make should be available from python-dev
# RUN apt-get install -y -q gcc
# RUN apt-get install -y -q make

# add a user
RUN useradd -D --shell=/bin/bash
RUN useradd -m user
RUN echo "user:secret" | chpasswd
RUN adduser user sudo
RUN sudo -u user mkdir /home/user/ipynotebooks



# shellinabox web based terminal
# ADD ./shellinabox-2.14.tar.gz /
# the add command seems to untar for you
RUN curl -O http://shellinabox.googlecode.com/files/shellinabox-2.14.tar.gz
RUN tar -xzf shellinabox-2.14.tar.gz
RUN cd shellinabox-2.14 && ./configure && make && make install
RUN mkdir /etc/shellinabox-css && cp shellinabox-2.14/shellinabox/*.css /etc/shellinabox-css/
RUN cd .. && rm -r shellinabox*
ADD ./supervisor/shellinabox.conf /etc/supervisor.d/shellinabox.conf
EXPOSE 4200

# supervisor process manager
RUN pip install supervisor
ADD supervisor/supervisord.conf /etc/supervisord.conf

RUN pip install ipython[notebook]
RUN pip install ez_setup
RUN pip install ipythonblocks
ADD ./ipython-conf.tgz /home/user/
RUN chown -R user /home/user/ipython-conf/
ENV IPYTHONDIR /ipython-config/
ADD ./supervisor/ipynotebook.conf /etc/supervisor.d/ipynotebook.conf
EXPOSE 8888

# sshd - to move out of base
# RUN apt-get install -y -q openssh-server
# EXPOSE 22
# ADD ./supervisor/sshd.conf /etc/supervisor.d/sshd.conf
# RUN mkdir /var/run/sshd

CMD supervisord -n -c /etc/supervisord.conf

