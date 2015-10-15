#!/bin/bash

#Author:
#mtask@github.com

#Just some useful/needed packages I install to fresh system.

package_installs(){
    packs=( openssh
    net-tools
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
    pypy-pip
    mplayer
 )
    yaourt -S --noconfirm --needed ${packs[@]}
}

yaourt_install(){
    sudo pacman -S --noconfirm --needed base-devel yajl binutils make gcc wget
    sudo pacman -S --noconfirm --needed yaourt
    if [[ $? != 0 ]]; then
        mkdir -p ~/temp/AUR/ && cd ~/temp/AUR/
        #package-query
        wget https://aur.archlinux.org/cgit/aur.git/snapshot/package-query.tar.gz
        tar xfz package-query.tar.gz
        cd package-query  &&  makepkg -s
        sudo pacman -U package-query*.pkg.tar.xz
        #Yaourt install
        wget https://aur.archlinux.org/cgit/aur.git/snapshot/yaourt.tar.gz
        tar xzf yaourt.tar.gz
        cd yaourt  &&  makepkg -s
        sudo pacman -U yaourt*.pkg.tar.xz
        echo "[!] Yaourt installed succesfully"
    elif [[ $? = 0 ]]; then
        echo "[!] Yaourt installed succesfully"
    fi
}


#Main
ping_goo=$(ping -c 1 -w 2 google.com | grep icmp* | wc -l)
if [[ "$ping_goo" = 0 ]]; then
    echo "[!] No network connection is detected"
    exit 0
fi

yaourt_install
package_installs
