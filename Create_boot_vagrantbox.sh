#!/bin/bash
##################################################
#Script to create and boot a Vagrant Box : Ubuntu
#Author : Naveen Kumar HS
#Version : 1.0
##################################################

####VARIABLES###
VAGRANT_BOX_NAME='ubuntu64'
VAGRANT_OS='ubuntu/boxes/trusty64'
VAGRANT_OS_VER='20180919.0.0'
VAGRANT_BOX_IMAGE='ubuntu/trusty64'
VAGRANT_BOX_IMAGE_URL="https://app.vagrantup.com/$VAGRANT_OS/versions/$VAGRANT_OS_VER/providers/virtualbox.box"
VAGRANT_WORKING_DIR="/vagrant/$VAGRANT_BOX_NAME"
VAGRANT_LOG='/tmp/install.log'
VAGRANT_CMD='/usr/bin/vagrant'
declare -a PACKAGE_LIST=("virtualbox" "vagrant")

####Time stamp Function#####
timestamp()
{
        date "+%Y-%m-%d %H:%M:%S"
}

####FUNCTION: To check command status####
check_command_sccess()
{
        if [ $? -eq 0 ]
        then
                echo "$(timestamp) : $1"
        else
                echo "$(timestamp) : $2 Check /tmp/install.log for errors"
                exit
        fi
}
####FUNCTION: To install packages####
install_package()
{
if [ "$#" -eq 3 ]
then
#        apt-get update >>$VAGRANT_LOG 2>&1
        echo "$(timestamp) : $1 Installation Started."
        apt-get install $1 -y >>$VAGRANT_LOG 2>&1
        check_command_sccess "$2" "$3"
else
        echo "Usage: install_package <pkgname> <msg1> <msg2>"
        exit
fi
}

#Install Pacakges

for package in "${PACKAGE_LIST[@]}"
do
        install_package $package "$package Installation completed." "$package Installation failed."
done

# Download Vagrant Box
        echo "$(timestamp) : Creating working directory for Vagrant box $VAGRANT_BOX_NAME."
        mkdir -p $VAGRANT_WORKING_DIR
        cd $VAGRANT_WORKING_DIR;pwd
        echo "$(timestamp) : Download $VAGRANT_BOX_NAME Vagrant box image."
        $VAGRANT_CMD box add $VAGRANT_BOX_IMAGE $VAGRANT_BOX_IMAGE_URL >>$VAGRANT_LOG 2>&1
        check_command_sccess "Vagrant box $VAGRANT_BOX_NAME Successfully added." "Vagrant box $VAGRANT_BOX_NAME failed."
        echo "$(timestamp) : $VAGRANT_BOX_NAME Vagrant box image Downloaded."

#Creating VM
        echo "$(timestamp) : Creating/Initialising VM - Vagrantfile"
        $VAGRANT_CMD init $VAGRANT_BOX_NAME >>$VAGRANT_LOG 2>&1

#Brining Vagrant box up
        echo "$(timestamp) :Starting VM by running vagrant up"
        $VAGRANT_CMD up >>$VAGRANT_LOG 2>&1
        check_command_sccess "Vagrant box $VAGRANT_BOX_NAME is up and running" "Vagrant box $VAGRANT_BOX_NAME having issues with booting"
        echo "$(timestamp) : Status of the Vagrant box $VAGRANT_BOX_NAME"
        $VAGRANT_CMD status

#Check the ssh configuation for Vagrant box
        echo "$(timestamp) : ssh configuration of Vagrant box $VAGRANT_BOX_NAME"
        $VAGRANT_CMD ssh-config

        echo "$(timestamp) : check $VAGRANT_LOG for more information about installation"
