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
./add-user.sh -u bwinfuser -p "$UserPass"
./add-user.sh -u bewertung -p "$bewertungPass"
usermod -aG root bewertung



#VS Code
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg

snap install atom --classic

#Eclipse
wget https://www.eclipse.org/downloads/download.php?project=egit&file=eclipse-inst-jar
tar -xvf eclipse-inst-jar
cd eclipse-inst-jar && ./eclipse-inst

wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
apt-get update --fix-missing
apt-get install
apt-get install sublime-text apt-transport-https
apt install kate okular gnome-boxes vim neovim visualvm codeblocks valgrind ddd emacs geany joe kdevelop gdb gcc nano konsole firefox gnome-terminal code
apt-get install ruby-full byobu

apt update && sudo apt upgrade


#Setup  iptables. The iptable Rules will block every website but contest.informatik-contest.de. It will also download a script (and make it executable) to remove all iptable rules. Both the scripts are found in this repo 
wget https://raw.githubusercontent.com/Eisdaemon/Bwinf-Bewertung/main/Linux/ip.sh
chmod +x ip.sh

#Mädchenworkshop:
#Linux:
snap install pycharm-community --classic
wget https://repo.anaconda.com/archive/Anaconda3-2023.03-1-Linux-x86_64.sh
chmod +x  Anaconda3-2023.03-1-Linux-x86_64.sh
bash Anaconda3-2023.03-1-Linux-x86_64.sh
./anaconda3/bin/conda init
