## Vagrant Multiple-VM Creation and Configuration
Automatically provision multiple VMs with Vagrant and VirtualBox. Automatically install, configure, and test
Puppet Master and Puppet Agents on those VMs. Credit and additional help can be found here:
[http://wp.me/p1RD28-1kX](http://wp.me/p1RD28-1kX)  
Special thanks to Gary A. Stafford for his blog post.  
 
#### Quickstart 
vagrant up 
  
vagrant ssh agent1.dev1.rowdy.cc  
sudo puppet agent --test --waitforcert=60  
  
vagrant ssh core1.dev1.rowdy.cc 
sudo puppet agent --test --waitforcert=60  
  
vagrant ssh puppet1.dev1.rowdy.cc  
sudo puppet cert sign --all  
  
#### JSON Configuration File
The Vagrantfile retrieves multiple VM configurations from a separate `nodes.json` file. All VM configuration is
contained in the JSON file. You can add additional VMs to the JSON file, following the existing pattern. The
Vagrantfile will loop through all nodes (VMs) in the `nodes.json` file and create the VMs. You can easily swap
configuration files for alternate environments since the Vagrantfile is designed to be generic and portable.
 
 
#### Instructions
```
vagrant up # brings up all VMs
vagrant ssh puppet1.dev1.rowdy.cc

sudo service puppetmaster status # test that puppet master was installed
sudo service puppetmaster stop
sudo puppet master --verbose --no-daemonize
# Ctrl+C to kill puppet master
sudo service puppetmaster start
sudo puppet cert list --all # check for 'puppet' cert

# Shift+Ctrl+T # new tab on host
vagrant ssh agent1.dev1.rowdy.cc # ssh into agent node
vagrant ssh core1.dev1.rowdy.cc # ssh into core node
sudo service puppet status # test that agent was installed
sudo puppet agent --test --waitforcert=60 # initiate certificate signing request (CSR)
```
Back on the Puppet Master server (puppet1.dev1.rowdy.cc)
```
sudo puppet cert list # should see 'agent1.dev1.rowdy.cc and core1.dev1.rowdy.cc' cert waiting for signature
sudo puppet cert sign --all # sign the node(s) cert(s)
sudo puppet cert list --all # check for signed cert(s)
```
#### Forwarding Ports
Used by Vagrant and VirtualBox. To create additional forwarding ports, add them to the 'ports' array. For example:
 ```
 "ports": [
        {
          ":host": 1234,
          ":guest": 2234,
          ":id": "port-1"
        },
        {
          ":host": 5678,
          ":guest": 6789,
          ":id": "port-2"
        }
      ]
```
#### Useful Multi-VM Commands
The use of the specific <machine> name is optional.
* `vagrant up <machine>`
* `vagrant reload <machine>`
* `vagrant destroy -f <machine> && vagrant up <machine>`
* `vagrant status <machine>`
* `vagrant ssh <machine>`
* `vagrant global-status`
* `facter`
* `sudo tail -50 /var/log/syslog`
* `sudo tail -50 /var/log/puppet/masterhttp.log`
* `tail -50 ~/VirtualBox\ VMs/postblog/<machine>/Logs/VBox.log'