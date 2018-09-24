#!/bin/sh
##################################################
#Script to create and boot a Vagrant Box : Ubuntu
##################################################
TIMESTAMP=`date "+%Y-%m-%d %H:%M:%S"`
VAGRANT_CMD='/usr/bin/vagrant'
VAGRANT_BOX='ubuntu/trusty64'
VAGRANT_BOX_VER='https://app.vagrantup.com/ubuntu/boxes/trusty64/versions/20180919.0.0/providers/virtualbox.box'
VAGRANT_BOX_DIR='/vagrant/ubuntu64'
VAGRANT_LOG='/tmp/install.log'
declare -a PACKAGE_LIST=("virtualbox" "vagrant")
#Download Vagrant

check_command_sccess()
{
        if [ $? -eq 0 ]
        then
                echo "$TIMESTAMP : $1"
        else
                echo "$TIMESTAMP : $2 Check /tmp/install.log for errors"
        fi
}

install_package()
{
if [ "$#" -eq 3 ]
then
        apt-get update
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

# Download Vagrant Box : Ubuntu/trusty64
        echo "Creating directory for Vagrant box"
        cd $VAGRANT_BOX_DIR
        echo "Install/Add ubuntu Vagrant box"
        $VAGRANT_CMD box add $VAGRANT_BOX $VAGRANT_BOX_VER >>$VAGRANT_LOG 2>&1
        check_command_sccess "Vagrant box $VAGRANT_BOX Successfully added " "Vagrant box $VAGRANT_BOX failed"

#Creating Vagrant file

        $VAGRANT_CMD init $VAGRANT_BOX

#Brining Vagrant box up

        $VAGRANT_CMD up >>$VAGRANT_LOG 2>&1
        check_command_sccess "Vagrant box $VAGRANT_BOX is up and running" "Vagrant box having issues with booting"
        $VAGRANT_CMD status

#Check the ssh configuation for Vagrant box
        $VAGRANT_CMD ssh-config

echo "check $VAGRANT_LOG for more information about installation"
