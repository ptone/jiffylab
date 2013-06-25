# This file can be used as a handy way to setup your vagrant-rackspace env settings
# copy this file somewhere where it won't get commited to a public repo and fill in
# the values, then in any terminal where you want to do `vagrant up`, you can do
#
#   source <this file>
#   vagrant up

export RS_USERNAME=""
export RS_API_KEY=""
export RS_PUBLIC_KEY="~/.ssh/id_rsa.pub" 
export RS_PRIVATE_KEY="~/.ssh/id_rsa" 
export VAGRANT_DEFAULT_PROVIDER="rackspace"
