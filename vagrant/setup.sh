#!/bin/bash
# Download Vagrant and virtualbox

# install virtualbox guest additions
vagrant plugin install vagrant-vbguest

# Update the box
vagrant box update

# run the box and setup linux environment
vagrant up --provision

# ssh into vagrant box automatically
vagrant ssh
