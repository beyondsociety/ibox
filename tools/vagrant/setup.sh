#!/bin/bash
# Download Vagrant and virtualbox

# Install virtualbox guest additions
vagrant plugin install vagrant-vbguest

# Update the vagrant box
vagrant box update

# Start the vagrant box and setup our linux environment
vagrant up --provision --provider=virtualbox

# Ssh into the vagrant box automatically
vagrant ssh
