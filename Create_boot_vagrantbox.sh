#!/bin/bash
##################################################
#Script to create and boot a Vagrant Box : Ubuntu
#Author : Naveen Kumar HS
#Version : 1.0
##################################################

####VARIABLES###
TIMESTAMP=`date "+%Y-%m-%d %H:%M:%S"`
VAGRANT_CMD='/usr/bin/vagrant'
VAGRANT_BOX_NAME='ubuntu64'
VAGRANT_BOX_IMAGE='ubuntu/trusty64'
VAGRANT_OS='ubuntu/boxes/trusty64'
VAGRANT_OS_VER='20180919.0.0'
VAGRANT_BOX="https://app.vagrantup.com/$VAGRANT_OS/versions/$VAGRANT_OS_VER/providers/virtualbox.box"
VAGRANT_WORKING_DIR="/vagrant/$VAGRANT_BOX_NAME"
VAGRANT_LOG='/tmp/install.log'
declare -a PACKAGE_LIST=("virtualbox" "vagrant")

####FUNCTION: To check command status####
check_command_sccess()
{
        if [ $? -eq 0 ]
        then
                echo "$TIMESTAMP : $1"
        else
                echo "$TIMESTAMP : $2 Check /tmp/install.log for errors"
                exit
        fi
}
####FUNCTION: To install packages####
install_package()
{
if [ "$#" -eq 3 ]
then
        apt-get update >>$VAGRANT_LOG 2>&1
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
        echo "$TIMESTAMP : Creating working directory for Vagrant box $VAGRANT_BOX_NAME."
        mkdir -p $VAGRANT_WORKING_DIR
        cd $VAGRANT_WORKING_DIR;pwd
        echo "$TIMESTAMP : Install/Add $VAGRANT_BOX_NAME Vagrant box."
        $VAGRANT_CMD box add $VAGRANT_BOX_IMAGE $VAGRANT_BOX_IMAGE_URL >>$VAGRANT_LOG 2>&1
        check_command_sccess "Vagrant box $VAGRANT_BOX_NAME Successfully added." "Vagrant box $VAGRANT_BOX_NAME failed."

#Creating Vagrant file

        $VAGRANT_CMD init $VAGRANT_BOX_NAME >>$VAGRANT_LOG 2>&1

#Brining Vagrant box up
        echo "$TIMESTAMP :Create Environment by running vagrant up"
        $VAGRANT_CMD up >>$VAGRANT_LOG 2>&1
        check_command_sccess "Vagrant box $VAGRANT_BOX_NAME is up and running" "Vagrant box $VAGRANT_BOX_NAME having issues with booting"
        echo "$TIMESTAMP : Status of the Vagrant box $VAGRANT_BOX_NAME"
        $VAGRANT_CMD status

#Check the ssh configuation for Vagrant box
        echo "$TIMESTAMP : ssh configuration of Vagrant box $VAGRANT_BOX_NAME"
        $VAGRANT_CMD ssh-config

        echo "$TIMESTAMP : check $VAGRANT_LOG for more information about installation"
