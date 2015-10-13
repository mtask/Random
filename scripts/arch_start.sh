#!/bin/bash

#Author:
#mtask@github.com

#!Script not ready!"

package_installs(){
    echo "Install usefull utilies:"
    
    packs=( openssh
    openssh-server
    git
    wireshark-qt
    nmap
    libreoffice
    geany
    google-chrome
    openjdk-default
    ipython2
    gedit
    geany
    gnu-netcat
    curl
    virtualbox
    virtualbox-guest-utils
    alsa-oss 
    alsa-lib
    alsa-utils
    gvfs
    ntfs-3g 
    gvfs-afc
    unzip
    unrar 
    bison
    autoconf
    automake
    diffutils
    make
    libtool )
 
    yaourt -S --noconfirm --needed ${packs[@]}
      
yaourt_install(){
    pacman -S --noconfirm --needed base-devel yajl binutils make gcc wget
    pacman -S --noconfirm yaourt
    if [[ $? != 0 ]]; then
        mkdir -p ~/temp/AUR/ && cd ~/temp/AUR/
        #package-query
        wget https://aur.archlinux.org/cgit/aur.git/snapshot/package-query.tar.gz
        tar xfz package-query.tar.gz 
        cd package-query  &&  makepkg -s
        pacman -U package-query*.pkg.tar.xz
        #Yaourt install
        wget https://aur.archlinux.org/cgit/aur.git/snapshot/yaourt.tar.gz
        tar xzf yaourt.tar.gz
        cd yaourt  &&  makepkg -s
        pacman -U yaourt*.pkg.tar.xz
        echo "[!] Yaourt installed succesfully"
    elif [[ $? = 0 ]]; then
        echo "[!] Yaourt installed succesfully"
         
}

basic_setup(){
    ###Update###
    pacman -Sy
    pacman -Syyu

    ###Install sudo###
    pacman --noconfirm --needes -S sudo
    echo "Give your username"
    read user -p ">"
    if [[ groups "$user" | grep sudo | wc -l = 0 ]]; then
        echo "Adding "$user" to sudoers group..."
        usermod -aG sudo "$user"
        echo -e "%sudoers\tALL=(ALL) ALL" >> /etc/sudoers
    fi
}


#Main
if [[ $UID != 0 ]]
then
    echo "[!] Needs to run as root"
    exit 0
elif [[ ping -c 1 -w 2 google.com | grep icmp* | wc -l ]]; then
    "[!] No network connection is detected"
    exit 0
fi

basic_setup
yaourt_install
