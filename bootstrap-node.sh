#!/bin/sh

# Run on VM to bootstrap Puppet Agent nodes

if ps aux | grep "puppet agent" | grep -v grep 2> /dev/null
then
    echo "Puppet Agent is already installed. Moving on..."
else
    sudo apt-get install -yq puppet
fi

if cat /etc/crontab | grep puppet 2> /dev/null
then
    echo "Puppet Agent is already configured. Exiting..."
else
    sudo apt-get update -yq && sudo apt-get upgrade -yq

    sudo puppet resource cron puppet-agent ensure=present user=root minute=30 \
        command='/usr/bin/puppet agent --onetime --no-daemonize --splay'

    sudo puppet resource service puppet ensure=running enable=true

    # Configure /etc/hosts file
    echo "" | sudo tee --append /etc/hosts 2> /dev/null && \
    echo "# Host config for Puppet Master and Agent Nodes" | sudo tee --append /etc/hosts 2> /dev/null && \
    echo "192.168.32.5    puppet1.dev1.rowdy.cc  puppet1" | sudo tee --append /etc/hosts 2> /dev/null && \
    echo "192.168.32.10   agent1.dev1.rowdy.cc  agent1" | sudo tee --append /etc/hosts 2> /dev/null && \
    echo "192.168.32.15   core1.dev1.rowdy.cc  core1" | sudo tee --append /etc/hosts 2> /dev/null

    # Add agent section to /etc/puppet/puppet.conf
    echo "" && echo "[agent]\nserver=puppet1.dev1.rowdy.cc" | sudo tee --append /etc/puppet/puppet.conf 2> /dev/null

    sudo puppet agent --enable
fi