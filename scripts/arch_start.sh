#!/bin/bash

#Author:
#mtask@github.com

#!Script not ready!"

package_installs(){
    echo "Install usefull utilies:"

    packs=( openssh
    atom-editor-bin
    git
    wireshark-qt
    nmap
    libreoffice
    geany
    google-chrome
    jdk8-openjdk
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

}

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
    fi
}

basic_setup(){
    ###Update###
    pacman -Sy
    pacman -Syyu

    ###Install sudo###
    pacman --noconfirm --needed -S sudo
    echo "Give your username"
    read -p user ">"
    usrid=$(groups "$user" | grep wheel | wc -l)
    if [[ "$usrid" = 0 ]]; then
        echo "Adding "$user" to wheels group..."
        usermod -aG wheel "$user"
    fi
}


#Main
ping_goo=$(ping -c 1 -w 2 google.com | grep icmp* | wc -l)
if [[ $UID != 0 ]]
then
    echo "[!] Needs to run as root"
    exit 0
elif [[ "$ping_goo" = 0 ]]; then
    echo "[!] No network connection is detected"
    exit 0
fi

basic_setup
#yaourt_install
package_installs
