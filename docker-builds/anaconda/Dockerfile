# Sets up a container for the web based lab login
#
# VERSION               0.0.1

# At some point, more of this will be pushed into its own docker image

FROM      ubuntu
MAINTAINER Preston Holmes "preston@ptone.com"

RUN apt-get update -qq
RUN apt-get install -y -q python-dev python-dev-all

# sshd
RUN apt-get install -y -q openssh-server
EXPOSE 22

RUN apt-get install -y -q sudo gcc make nano sqlite3

RUN apt-get install -y -q python-pip
RUN pip install -U pip

# git
RUN apt-get install -y -q libcurl4-gnutls-dev libexpat1-dev gettext libz-dev libssl-dev
RUN apt-get install -y -q git
# TODO add git configs

RUN 
RUN 
RUN 
RUN 
RUN 

