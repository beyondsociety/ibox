#!/bin/bash
# Download Vagrant and virtualbox

# Install virtualbox guest additions
vagrant plugin install vagrant-vbguest

# Update the vagrant box
vagrant box update

# Reload the vagrant box to fix issues with guest additons and virtualbox
vagrant reload --no-provision

# Start the vagrant box and setup our linux environment
vagrant up --provision

# Ssh into the vagrant box automatically
vagrant ssh
