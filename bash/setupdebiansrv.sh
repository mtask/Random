#!/bin/bash

red='\033[0;31m'
neutral='\033[0m'
yellow='\033[0;33m'
blue='\033[0;34m'


function updatesrv()
{
    echo "[!] Running updates"
    apt-get update -y && apt-get upgrade -y && clear
}

function sudo_user()
{
    read -p "New User: " USERNAME
    apt-get install -y sudo
    useradd -m -G users,sudo -s /bin/bash $USERNAME  && clear
    passwd $USERNAME
    read -p "Add you public key for ssh login?(y/N)" ANS
    if [ "$ANS" = "y" ] || [ "$ANS" = "Y" ];then
        read -p "Paste your public key and press enter:" PUBKEY
        mkdir -p /home/$USERNAME/.ssh && echo $PUBKEY > /home/$USERNAME/.ssh/authorized_keys
        chown -R $USERNAME.$USERNAME /home/$USERNAME/ 
    fi
}

function setup_ssh()
{
    read -p "SSH port: " SSH_PORT
    sed -i -e 's/Port 22/Port '"$SSH_PORT"'/g' /etc/ssh/sshd_config
    sed -i -e 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
    read -p "Restart SSH service?(y/N)" ANS
    if [ "$ANS" = "y" ] || [ "$ANS" = "Y" ];then
        echo "[!] Restarting sshd"
        #/etc/init.d/ssh restart
    fi
}

function setup_ufw()
{
    apt-get install -y ufw
    SSH_PORT=$(grep -i port /etc/ssh/sshd_config | awk -F " " '{print $2}')
    ufw default deny incoming
    ufw default allow outgoing
    ufw allow $SSH_PORT/tcp
    read -p "Enable ufw now(y/N): " ANS
    if [ "$ANS" = "y" ] || [ "$ANS" = "Y" ];then
        echo Y | ufw enable
    else
        echo "Enable firewall with following command: \"ufw enable\""
    fi
}


######
######
#Main#
######
######

while true
do
    echo "1) Run updates"
    echo "2) Create regular user with full sudo rights"
    echo "3) Harden ssh"
    echo "4) Install UFW and create default rules"
    echo "Select option. Select multiple actions by seperating numbers with comma." 
    read SELECTIONS
    # Create array from input
    SELARR=($(echo "$SELECTIONS" | tr -d " " | tr "," " "))
 
    for SELECTION in "${SELARR[@]}"
    do
        case "$SELECTION" in

            1) updatesrv
            ;;
      	    2) sudo_user
 	    ;;
	    3) setup_ssh
       	    ;;
	    4) setup_ufw
            ;;
            esac
            read -p "Press enter to continue...." && clear
    done
done
