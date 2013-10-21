JiffyLab
========

JiffyLab is a project to provide an entirely web based environment for the
instruction, or lightweight use of, Python and UNIX shell environment with
zero-configuration of the user's machine.

Currently in early development status

The Problem
-----------

Python is a wonderful first language, but sometimes introducing people to
Python is bogged down by making sure that everyone has a usable development
environment. This can often set a tone of frustration for beginners, as well as
completely drain instructor and assistant's time, instead of letting everyone
"dive in".

There are other advantages to having a standardized environment:

* If the instructor is projecting the same thing as what the student sees, the
  student will be less likely to be thrown off by inconsequential details such
  as differences in the shell prompt (> vs $ etc), different syntax
  highlighting colors, or the use of some tool or feature not installed on the
  student's machine.

* When all students are using the same exact setup, they are more likely to be
  capable of helping their neighbor, because if they got it working on their
  screen, they can probably get it working on their neighbor's - peers and
  instructors can more effectively visually "diff" what might be different.

* Even if the setup of a student machine goes smoothly at a technical level, it
  can still take time, especially if a significant number of material needs to
  be downloaded over slow links, or requires significant build time.

Trade-offs
----------

Messing around with tools and your machine's setup is of course part of being
a developer - learning how to manage your system and Python 'PATH', learning an
editor, virtualenvs, pip etc all need to happen. But not in your first hours as
a new developer.

Another reason to have students work through the challenge of getting
a working dev environment on their own machines is so that they can continue to
teach themselves and learn on their own once past the introduction. This is
very important, and should be built into any worthwhile instruction, it just
doesn't need to happen at the beginning. Once students have learned some
material, they will have much more context to understand what it is they are
setting up, and will potentially have a greater motivation for getting it all
working. So in the end I believe this trade-off is a bit of a red herring, as
it is not about "either or", but "which comes first".

Finally there is some advantage to working in a "tunneled" environment if the
primary way you may interact with tools or data is remotely on a server. When
you have only learned with the aid of local GUI tools on hand, it can be a very
difficult transition to doing things remotely.

Short Screencast
----------------

.. raw:: html

    <iframe width="560" height="315" src="http://www.youtube.com/embed/NkPO6nb9owE" frameborder="0" allowfullscreen></iframe>

`Direct link if embedding disabled <http://www.youtube.com/embed/NkPO6nb9owE>`_

Quickstart
----------

JiffyLab uses `Docker <http://docker.io>`_ which provides each student a
sandboxed environment through the use of linux containers (think lightweight,
process level virtual machines). Note that this technology is Linux specific,
so does NOT run on Mac OS X. You can run this quite effectively inside a Linux
virtual machine using `vagrant <http://vagrantup.com>`_ (in fact, this project
was developed on a Mac). A simple Flask app runs on the same machine as Docker
and uses the Docker remote API to create or restart containers as needed.

Once you have a linux machine setup (see below for more details on Vagrant),
you can execute the steps in the linux-setup.sh file. This will install Docker,
and some python tools, pull the base Docker images needed, and start the
webapp. You can then connect on port 80 to that machine. It is recommended you
not run this on a server also used for any "Very Important Things", but instead
run it on some sort of VM on its own.

Running on a Mac with Vagrant
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Note - running this on a cloud based vagrant provider ends up getting set up
much faster, usually due to the excellent speeds on cloud providers.

You will need Vagrant and Virtualbox (make sure you are using the latest
version that is known to support vagrant, sometimes virtualbox breaks vagrant).

cd into the jiffylab folder and just run ``vagrant up`` in a terminal. Note
that with the 'Ubuntu Raring' image used, I found that Vagrant would hang on
first boot.  If you are stuck on "waiting for VM to boot" for more than several
minutes, ctrl-C, then do a ``vagrant halt`` followed by another ``vagrant up``.

If you had this stalling issue, vagrant may not have provisioned properly, so
you will have to run the linux-setup script, which should be found at
/vagrant/linux-setup.sh

Running on Rackspace with Vagrant
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You will need a an account and `API key
<http://www.rackspace.com/knowledge_center/article/rackspace-cloud-essentials-1-generating-your-api-key-0>`_
on `Rackspace <http://www.rackspace.com>`_. You will also need to install the
vagrant rackspace plugin::

    $ vagrant plugin install vagrant-rackspace
    $ vagrant box add dummy https://github.com/mitchellh/vagrant-rackspace/raw/master/dummy.box

You will need to set some environment variables for Rackspace - an easy way to
do this is to follow the directions in ``cloud-credentials.sh``, fill out
your information, then::

    $ source cloud-credentials.sh
    $ vagrant up --provider=rackspace

After server building and provisioning, you should be able to access your
instance on the IP address listed in your Rackspace dashboard.


Running on DigitalOcean with Vagrant
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Install the `DigitalOcean vagrant provider
<https://github.com/smdahlen/vagrant-digitalocean>`_ and dummy box::

    $vagrant plugin install vagrant-digitalocean
    $vagrant box add dummy https://github.com/smdahlen/vagrant-digitalocean/raw/master/box/digital_ocean.box

    # see notes on DigitalOcean plugin readme if you get errors

Sign up if you haven't already, then grab your client id and api key from
`DigitalOcean <https://www.digitalocean.com/api_access>`_.

Plug these into ``cloud-credentials.sh``, then::

    $ source cloud-credentials.sh
    $ vagrant up --provider=digital_ocean

Similar or related projects
---------------------------

* `wakari <http://wakari.io>`_ A really well done and far more complete version
  of this concept, using the ACE editor, OpenVZ linux containers instead of
  Docker, and the GateOne shell. The only knocks against it is that it is
  commercial (with a free EDU option) and not open source, but hey, well done.

* `notebookcloud <https://notebookcloud.appspot.com/docs>`_ is an app_engine
  app that will manage the spin up of EC2 instances. Requires you to upload
  your AWS credentials.


* `IPython-hydra <https://github.com/cni/ipython-hydra>`_ a set of scripts to
  launch IPython notebook processes under dynamically created users.

This project still has plenty of rough edges, check out the current issues,
submit a new one, feedback welcome.
