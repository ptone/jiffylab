# -*- mode: ruby -*-
# vi: set ft=ruby :

# this vagrant file specifies details for the virtualbox and rackspace
# providers. See the linux-setup file for provisioning details.
#
# BOX_NAME = ENV['BOX_NAME'] || "raring"
# BOX_URI = ENV['BOX_URI'] || "http://files.vagrantup.com/precise64.box"
# AWS_REGION = ENV['AWS_REGION'] || "us-east-1"
# AWS_AMI    = ENV['AWS_AMI']    || "ami-d0f89fb9"


kernel_upgrade = "add-apt-repository -y ppa:ubuntu-x-swat/r-lts-backport; " \
      "apt-get update -qq; apt-get install -q -y linux-image-3.8.0-19-generic; shutdown -r +1;"

Vagrant.configure("2") do |config|


  config.vm.box = 'jiffylab'

  config.vm.provider :virtualbox do |vb, override|
    override.vm.box_url = 'http://cloud-images.ubuntu.com/raring/current/raring-server-cloudimg-vagrant-amd64-disk1.box'
    override.vm.network :private_network, ip:"10.10.10.10"
    vb_guest_install = "apt-get install -q -y linux-headers-3.8.0-19-generic dkms; " \
    "echo 'Downloading VBox Guest Additions...'; " \
    "wget -q http://dlc.sun.com.edgesuite.net/virtualbox/4.2.12/VBoxGuestAdditions_4.2.12.iso; "
    # Prepare the VM to add guest additions after reboot
    vb_guest_install << "echo -e 'mount -o loop,ro /home/vagrant/VBoxGuestAdditions_4.2.12.iso /mnt\n" \
    "echo yes | /mnt/VBoxLinuxAdditions.run\numount /mnt\n" \
        "rm /root/guest_additions.sh; ' > /root/guest_additions.sh; " \
    "chmod 700 /root/guest_additions.sh; " \
    "sed -i -E 's#^exit 0#[ -x /root/guest_additions.sh ] \\&\\& /root/guest_additions.sh#' /etc/rc.local; " \
    "echo 'Installation of VBox Guest Additions is proceeding in the background.'; " \
    "echo '\"vagrant reload\" can be used in about 2 minutes to activate the new guest additions.'; "
  end

  config.vm.provider :aws do |aws, override|
    override.vm.box = "dummy"
    aws.access_key_id = ENV["AWS_ACCESS_KEY"]
    aws.secret_access_key = ["AWS_SECRET_KEY"]
    aws.region = "us-west-2"
    aws.keypair_name = ENV["AWS_KEYPAIR_NAME"]
    # aws.security_groups = ["jiffylab"]
    aws.ami = "ami-ace67f9c"
    # aws.ami = "ami-9c47deac"
    # aws.instance_type = "m2.xlarge"
    # override.ssh.username = "ubuntu"
    # override.ssh.private_key_path = ENV["PRIVATE_KEY"]
  end

  config.vm.provider :rackspace do |rs, override|
    override.vm.box = "dummy"
    override.ssh.private_key_path = ENV["PRIVATE_KEY"]
    rs.public_key_path = ENV["PUBLIC_KEY"]
    rs.username = ENV["RS_USERNAME"]
    rs.api_key  = ENV["RS_API_KEY"]
    rs.flavor   = /512MB/
    rs.image    = /Raring/
  end

  config.vm.provider :digital_ocean do |digocean, override|
    override.vm.box = "dummy"
    override.ssh.private_key_path = ENV["PRIVATE_KEY"]
    digocean.public_key_path = ENV["PUBLIC_KEY"]
    digocean.client_id = ENV["DO_CLIENT_ID"]
    digocean.image = "Ubuntu 13.04 x64"
    digocean.size = "512MB"
  end

  config.vm.provision :shell, :path => "linux-setup.sh"
end
