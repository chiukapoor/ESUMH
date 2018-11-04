#!/bin/bash

#===============================================================================
#
#          FILE:  ESUMH.sh
#
#         USAGE:  ./ESUMH.sh
#
#   DESCRIPTION: (E)nable (S)sh for (U)sername on (M)ultiple (H)ost
#                This script enables ssh for a user defined username
#                on multiple hosts. Script is tested on AWS Ubuntu 
#                18.04 (Bionic Beaver) instance.
#        AUTHOR:  Chirayu Kapoor, chirayukapoor35ck@gmail.com
#       VERSION:  1.0
#       CREATED:  04/11/2018 09:43:23 PM IST
#      REVISION:  ---
#===============================================================================


# Remote host
remoteHost=(host1, host2, host3, host4, host5)

# Remote host keys
remoteHostPass=(key1, key2, key3, key4, key5)

# Check if a user id was supplied.
if [ -z "$1" ]; then
    # A remote user id was not supplied.
    echo
    echo "Username not provided. Please run the script again with a valid Username";
    exit 0
else
    # A remote user id was supplied.
    echo
    userId=$1
    echo "SSH will be enabled for \"$userId\" on \"${remoteHost[@]}\" remote hosts.";
fi

# Check if remoteHost and remoteHostPass.
if [${remoteHostPass[$i]} != ${remoteHost[$i]}]
then
    echo
    echo "Number of host and their keys doesn't match"
fi

# Looping through all the hosts.
for ((i=0; i<${#remoteHost[*]}; i++))
do
    # Connecting with remote host through SSH and it's Passkey
    # Runing code inside EOF in the remote host.
    ssh -i "${remoteHostPass[$i]}" ubuntu@${remoteHost[$i]}<<EOF
    
    # Adding the user in host.
    sudo adduser --disabled-password --gecos "" --home /home/$userId $userId
    
    # Setting it's password (q6Y8jl9)
    sudo sudo echo $userId:"q6Y8jl9" | sudo chpasswd

    # Editing '/etc/ssh/sshd_config' file to allow user for SSH.
    if grep -q '#AllowUsers' '/etc/ssh/sshd_config'; then
        sudo sed -i 's/#AllowUsers/AllowUsers/g' /etc/ssh/sshd_config
    fi

    if grep -q 'AllowUsers' '/etc/ssh/sshd_config'; then
        sudo sed -i 's/AllowUsers/AllowUsers '$userId'/g' /etc/ssh/sshd_config
    else
        sudo sed -i '$ a AllowUsers ubuntu '$userId'' /etc/ssh/sshd_config
    fi

    exit

EOF
    # Generating public and private keys of user for remote host.
    ssh-keygen -t rsa -N '' -f ~/.ssh/$userId.${remoteHost[$i]}.pem -C $userId@${remoteHost[$i]}

    # Sending the public key to host
    scp -i "${remoteHostPass[$i]}" ~/.ssh/$userId.${remoteHost[$i]}.pem.pub ubuntu@${remoteHost[$i]}:/home/ubuntu

    ssh -i "${remoteHostPass[$i]}" ubuntu@${remoteHost[$i]}<<EF
    # Changing ownership of file.
    sudo chown $userId:$userId /home/ubuntu/$userId.${remoteHost[$i]}.pem.pub
    sudo su $userId
    cd
    mkdir .ssh
    chmod 700 .ssh

    touch .ssh/authorized_keys

    cat /home/ubuntu/$userId.${remoteHost[$i]}.pem.pub >> /home/$userId/.ssh/authorized_keys
    chmod 600 .ssh/authorized_keys
    exit

    sudo rm /home/ubuntu/$userId.${remoteHost[$i]}.pem.pub

    sudo systemctl restart sshd.service
    exit
EF
done
echo
echo
echo "SSH is succesfully enabled for \"$userId\" on \"${remoteHost[@]}\" remote hosts";

exit 0