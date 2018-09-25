# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
  config.vm.define "web01" do |web01|
    web01.vm.box = "bento/ubuntu-16.04"
    web01.vm.network "private_network", ip: "192.168.33.11"
    web01.vm.hostname = "web01"
    web01.ssh.forward_agent = true
    web01.ssh.port = 2222    
    web01.vm.synced_folder ".", "/vagrant"
    web01.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
    end
    web01.vm.provision "ansible" do |ansible|
      ansible.playbook = "playbook.yml"
    end
  end
end
=======================================================================
  
Vagrantfile
The Vagrantfile is where are four virtual machines are defined, and you will notice three blocks of code here, one for our Ansible management node, one for a load balancer, and the final one is for our web servers.

# Defines our Vagrant environment
#
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # create mgmt node
  config.vm.define :mgmt do |mgmt_config|
      mgmt_config.vm.box = "ubuntu/trusty64"
      mgmt_config.vm.hostname = "mgmt"
      mgmt_config.vm.network :private_network, ip: "10.0.15.10"
      mgmt_config.vm.provider "virtualbox" do |vb|
        vb.memory = "256"
      end
      mgmt_config.vm.provision :shell, path: "bootstrap-mgmt.sh"
  end

  # create load balancer
  config.vm.define :lb do |lb_config|
      lb_config.vm.box = "ubuntu/trusty64"
      lb_config.vm.hostname = "lb"
      lb_config.vm.network :private_network, ip: "10.0.15.11"
      lb_config.vm.network "forwarded_port", guest: 80, host: 8080
      lb_config.vm.provider "virtualbox" do |vb|
        vb.memory = "256"
      end
  end

  # create some web servers
  # https://docs.vagrantup.com/v2/vagrantfile/tips.html
  (1..2).each do |i|
    config.vm.define "web#{i}" do |node|
        node.vm.box = "ubuntu/trusty64"
        node.vm.hostname = "web#{i}"
        node.vm.network :private_network, ip: "10.0.15.2#{i}"
        node.vm.network "forwarded_port", guest: 80, host: "808#{i}"
        node.vm.provider "virtualbox" do |vb|
          vb.memory = "256"
        end
    end
  end

end
