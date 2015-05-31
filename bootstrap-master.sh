#!/bin/sh

# Run on VM to bootstrap Puppet Master server

if ps aux | grep "puppet master" | grep -v grep 2> /dev/null
then
    echo "Puppet Master is already installed. Exiting..."
else
    # Install Puppet Master
    wget https://apt.puppetlabs.com/puppetlabs-release-trusty.deb && \
    sudo dpkg -i puppetlabs-release-trusty.deb && \
    sudo apt-get update -yq && sudo apt-get upgrade -yq && \
    sudo apt-get install -yq puppetmaster

    # Configure /etc/hosts file
    echo "" | sudo tee --append /etc/hosts 2> /dev/null && \
    echo "# Host config for Puppet Master and Agent Nodes" | sudo tee --append /etc/hosts 2> /dev/null && \
    echo "192.168.32.5    puppet1.dev1.rowdy.cc  puppet1" | sudo tee --append /etc/hosts 2> /dev/null && \
    echo "192.168.32.10   agent1.dev1.rowdy.cc  agent1" | sudo tee --append /etc/hosts 2> /dev/null && \
    echo "192.168.32.15   core1.dev1.rowdy.cc  core1" | sudo tee --append /etc/hosts 2> /dev/null

    # Add optional alternate DNS names to /etc/puppet/puppet.conf
    sudo sed -i 's/.*\[main\].*/&\ndns_alt_names = puppet,puppet1,puppet1.dev1.rowdy.cc/' /etc/puppet/puppet.conf

    # Install some initial puppet modules on Puppet Master server
    sudo puppet module install puppetlabs-ntp
    sudo puppet module install puppetlabs-apt

    # symlink manifest and hieradata from Vagrant synced folder location
    #ln -s /vagrant/puppet/manifests/site.pp /etc/puppet/manifests/site.pp
    ln -s /vagrant/puppet/hiera.yaml /etc/puppet/hiera.yaml
    ln -s /vagrant/puppet/manifests/* /etc/puppet/manifests/
    ln -s /vagrant/puppet/modules/* /etc/puppet/modules/
fi


