#!/bin/sh
##################################################
#Script to create and boot a Vagrant Box : Ubuntu
##################################################
TIMESTAMP=`date "+%Y-%m-%d %H:%M:%S"`
#Download Vagrant

check_command_sccess()
{
        if [ $? -eq 0 ]
        then
                echo "$TIMESTAMP : $1"
        else
                echo "$TIMESTAMP : $2 \nCheck /tmp/install.log for errors"
        fi
}

install_package()
{
if [ "$#" -eq 3 ]
then
        apt-get update
        apt-get install $1 -y >>/tmp/install.log 2>&1
        check_command_sccess "$2" "$3"
else
        echo "Usage: install_package <pkgname> <msg1> <msg2>"
        exit
fi
}

# Download and Install viratual box which is pre-requisite for vagrant

        echo "$TIMESTAMP : Download and Install Oracle Virtualbox, a pre-requisite for Vagrant"
        install_package "virtualbox" "Oracle Virtualbox Installation completed" "Oracle Virtualbox Download/installation failed. Check install.log for errors"

# Download and install  Vagrant package

        echo "$TIMESTAMP : Downloading and installting the vagrant package for ubuntu from https://vagrant.io"
        #wget -nc  https://releases.hashicorp.com/vagrant/2.1.5/vagrant_2.1.5_x86_64.deb1 -P /tmp >>/tmp/install.log 2>&1
        install_package "vagrant" "Vagrant Installation completed" "Vagrant Download/installation failed. Check install.log for errors"

# Download Vagrant Box : Ubuntu/trusty64
        echo "Creating directory for Vagrant box"
        mkdir -p /vagrant/ubuntu64
        cd /vagrant/ubuntu64
        echo "Install/Add ubuntu Vagrant box"
        /usr/bin/vagrant box add ubuntu/trusty64 https://app.vagrantup.com/ubuntu/boxes/trusty64/versions/20180919.0.0/providers/virtualbox.box
        check_command_sccess "Installation of Vagrant Ubuntu Box Completed" "Installation of Vagrant Ubuntu Box Failed"

#Creating Vagrant file

        /usr/bin/vagrant init ubuntu/trusty64

#Brining Vagrant box up

        /usr/bin/vagrant up
        check_command_sccess "Vagrant box is up and running" "Vagrant box having issues with booting"

#Check the ssh configuation for Vagrant box
        /usr/bin/vagrant ssh-config
