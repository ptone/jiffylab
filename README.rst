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
completely drain instructor and assistants time, instead of letting everyone
"dive in".

There are other advantages to having a standardized environment:

* If the instructor is projecting the same thing as what the student sees, the
  student will be less likely to be thown off by inconsequential details such
  as differences in the shell prompt (> vs $ etc), different syntax
  highlighting colors, or use of some tool or feature not installed on the
  student's machine.

* When all students are using the same exact setup, they are more likely to be
  capable of helping their neighbor, as if they got it working on their screen,
  they can probably get it working on their neigbor - peers can more
  effectively visually "diff" what might be different.

* Even if the setup of a student machine goes smoothly at a technical level, it
  can still take time, especially if a significant number of material needs to
  be downloaded over slow links, or requires significant build time.

Trade-offs
----------

Messing around with tools and your machine setup is of course part of being
a developer - learning how to manage your system and Python 'PATH', learning an
editor, virtualenvs, pip etc all need to happen. But not in your first hour as
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

TODO Learn to work on a server

Quickstart
----------

JiffyLab uses `Docker <http://docker.io>`_ which provides each student a
sandboxed environment through the use of linux containers (think lightweight,
process level virtual machines). Note that this technology is Linux specific,
so does NOT run on Mac OS X. You can run this quite effectively inside a Linux
virtual machine using `vagrant <http://vagrantup.com>`_ (in fact, this project
was developed on a Mac).

# notes

vagrant virtualbox stall on raring box

