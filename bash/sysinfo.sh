#!/bin/bash

#Simple menu driven info scraper about system, user(s), groups, networking etc., etc.

#Copyright (c) 2015 mtask @github.com

#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:


#The above copyright notice and this permission notice shall be included in
#all copies or substantial portions of the Software.

#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#THE SOFTWARE.


red='\033[0;31m'
neutral='\033[0m'
yellow='\033[0;33m'
blue='\033[0;34m'


sys_info()
{
    distro=$(cat /etc/*-release | grep -i pretty | awk -F "\"" '{print $2}')
    rel=$(uname -r)
    ver=$(uname -v)
    proc=$(uname -m)
    os=$(uname -s)
    bver=$(bash --version | head -n 1)
         
    clear
    echo -e "${red}\t--System info--\n"
    echo -e "${blue}Operating System:${yellow} $os"
    echo -e "${blue}Distribution:${yellow} $distro"
    echo -e "${blue}Kernel release:${yellow} $rel"
    echo -e "${blue}Kernel version:${yellow} $ver"
    echo -e "${blue}Processor:${yellow} $proc"
    echo -e "${blue}Bash version:${yellow} $bver"
    
    if [ $(id -u $(whoami)) = "0" ];then 
        if type dmidecode &> /dev/null; then
            echo -e "${blue}Bios vendor:${yellow} $(dmidecode -s 
bios-vendor 2> /dev/null)"
            echo -e "${blue}Bios Version:${yellow} $(dmidecode -s 
bios-version 2> /dev/null)"
            echo -e "${blue}Bios release-date:${yellow} $(dmidecode -s bios-release-date 2> /dev/null)"
        else
            echo "To get info about your Bios install \"dmidecode\""
        fi
    else
        echo "Run as root user if you want BIOS information"
    fi

    echo -e "${red}\n"
    read -p "Press enter to go back"
    echo -e "${neutral}"
}

networking_info()
{
    ifaces=$(netstat -i | awk -F " " '{print $1}' | sed -n '1,2!p' | tr "\n" " ")
    internet_con=$(ping -c 1 -w 3 8.8.8.8 | grep icmp* | wc -l)
    pub_ip=$(curl -s http://orga.cat/ip)
    primary_dns=$(cat /etc/resolv.conf | awk '{print $2}' | head -n 1)
    open_ports=$(nc -z -v localhost 1-1023 2>&1)
    
    if [ $internet_con = "1" ]
    then
        con_status="Up"
    else
        con_status="Down"
    fi
    
    clear
    echo -e "${red}\t--Networking info--${neutral}\n"
    echo -e "${blue}Interfaces: ${yellow}$ifaces"
    echo -e "${blue}Primary dns: ${yellow}$primary_dns"
    echo -e "${blue}Internet connection: ${yellow}$con_status"
    if [ $con_status = "Up" ];then
        echo -e "${blue}Public IP-address: ${yellow}$pub_ip"  
    fi 
    echo -e "${blue}Open ports:\n ${yellow}$open_ports"
    echo -e "${red}"
    read -p "Press enter to go back"
    echo -e "${neutral}"
}

user_info()
{
    grps=$(groups $(whoami))
    user_id=$(id -u $(whoami))
    
    clear
    echo -e "${red}\t--User info--${neutral}\n"
    echo -e "${blue}Username: ${yellow}$(whoami)"
    echo -e "${blue}User id:${yellow} $user_id"
    echo -e "${blue}Home directory:${yellow}" ~/
    echo -e "${blue}User's groups:${yellow} $grps"
    echo -e "${red}"
    read -p "Press enter to go back"
    echo -e "${neutral}"
 
 
}

users_groups_info()
{
    user_list=$(cut -d: -f1 /etc/passwd | tr "\n" " ")
    group_list=$(cut -d: -f1 /etc/group | tr "\n" " ")
    locked_users=$(cat /etc/shadow | grep ! |  awk -F ":" '{print $1}' | tr "\n" " ")
    
    clear
    echo -e "${red}\t--Users and groups info--${neutral}\n"
    echo -e "${blue}Users: ${yellow}$user_list"
    echo -e "${blue}Locked users: ${yellow}$locked_users"
    echo -e "${blue}Groups: ${yellow}$group_list"
    echo -e "${red}"
    read -p "Press enter to go back"
    echo -e "${neutral}"   
}

clear
while [ "$action" != "x" ]
do
    echo "- - - - - - - - - - - -"
    echo -e "${red}   System info${neutral}"
    echo "- - - - - - - - - - - -"
    echo -e "\nSelect action and press enter:" 
 
    echo -e "${yellow}1) System info"
    echo "2) User info"
    echo "3) Users and groups info"
    echo "4) Networking info"
    echo "x) Exit"
    echo -e "${neutral}"
    read -p ">" action
    if [ "$action" = "1" ];then
        sys_info
    elif [ "$action" = "2" ];then
        user_info
    elif [ "$action" = "3" ];then
        users_groups_info   
    elif [ "$action" = "4" ];then
        echo "Just a second.."
        networking_info  
    
    fi
clear    
done
clear