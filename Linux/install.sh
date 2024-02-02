#!/bin/bash
#The Script install all necessary Software for Linux
#The Script is only relevant for pool Laptops, as we don't use any more congif for coworkers, after the install

# Set up All Account

[ "$UID" -eq 0 ] || exec sudo "$0" "$@"
wget https://raw.githubusercontent.com/Eisdaemon/Bwinf-Bewertung/main/Linux/add-user.sh
chmod +x add-user.sh
echo "Enter the Password for user"
read UserPass
echo "Enter the Password for bewertung"
read bewertungPass
./add-user.sh -u bwinf-user -p "$UserPass"
./add-user.sh -u bewertung -p "$bewertungPass"
usermod -aG root bewertung


apt-get update --fix-missing
apt install kate okular gnome-boxes vim neovim visualvm codeblocks valgrind ddd emacs geany joe kdevelop gdb gcc nano konsole firefox gnome-terminal
apt-get install ruby-full byobu
snap install pycharm-community --classic
snap install intellij-idea-community --classic
snap install code --classic
snap install atom --classic
snap install --classic eclipse
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
apt-get update
apt-get install apt-transport-https
apt-get install sublime-text
apt update && sudo apt upgrade


#Setup  iptables. The iptable Rules will block every website but contest.informatik-contest.de. It will also download a script (and make it executable) to remove all iptable rules. Both the scripts are found in this repo 
wget https://raw.githubusercontent.com/Eisdaemon/Bwinf-Bewertung/main/Linux/ip.sh
chmod +x ip.sh

#Mädchenworkshop:
#Linux:
wget https://repo.anaconda.com/archive/Anaconda3-2023.03-1-Linux-x86_64.sh
chmod +x  Anaconda3-2023.03-1-Linux-x86_64.sh
bash Anaconda3-2023.03-1-Linux-x86_64.sh
./anaconda3/bin/conda init
