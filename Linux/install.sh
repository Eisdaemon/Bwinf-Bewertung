#!/bin/bash


#Install all Programms for the IOI and Girls Workshop
install_all_programms () {
    #Add Repos
    sudo add-apt-repository universe
    wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo tee /etc/apt/keyrings/sublimehq-pub.asc > /dev/null
    echo -e 'Types: deb\nURIs: https://download.sublimetext.com/\nSuites: apt/stable/\nSigned-By: /etc/apt/keyrings/sublimehq-pub.asc' | sudo tee /etc/apt/sources.list.d/sublime-text.sources
    echo "code code/add-microsoft-repo boolean true" | sudo debconf-set-selections
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
    sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'

    sudo apt update
    sudo apt -y upgrade

    wget github.com/atom/atom/releases/download/v1.60.0/atom-amd64.deb
    sudo apt -y install ./atom-amd64.deb
    sudo apt-get -y install build-essential

    #Apt installed editors
    sudo apt-get -y install python3 geany joe emacs nano neovim python3-neovim sublime-text vim code ddd gdb valgrind ruby konsole keditbookmarks default-jre python3-pip


    #Jet Brains Packages
    sudo snap install clion --classic
    sudo snap install pycharm-community --classic


    #Eclipse
    sudo snap install eclipse --classic

    #KDevelop
    sudo snap install kdevelop --classic


    sudo -u ioiuser bash << 'EOF'
    # Install code addon
    code --install-extension ms-vscode.cpptools
    EOF

    sudo -u anderes bash << 'EOF'
    # Install code addon
    code --install-extension ms-vscode.cpptools
    EOF
}

create_accounts () {
    sudo useradd -m anderes && echo "anderes:user" | sudo chpasswd
    echo "Enter the Password for bewertung"
    read bewertung_pass
    sudo useradd -m bewertung && echo "bewertung:$bewertung_pass" | sudo chpasswd
    sudo useradd -m ioiuser && echo "ioiuser:user" | sudo chpasswd
}

set_ip_rules() {
    wget https://raw.githubusercontent.com/Eisdaemon/Bwinf-Bewertung/main/Linux/ip.sh
    mv ip.sh /home/sysoperator/bin/
    chmod +x /home/sysoperator/bin/ip.sh
    sudo /home/sysoperator/bin/ip.sh
}

add_bin_container() {
    mkdir -p /home/sysoperator/bin
}

create_backups() {
    sudo cp -a /home/ioiuser /home/sysoperator
    sudo cp -a /home/anderes /home/sysoperator
}

set_backup_commands() {
    #Get all files
    wget https://raw.githubusercontent.com/Eisdaemon/Bwinf-Bewertung/refs/heads/main/Linux/ioi.sh
    wget https://raw.githubusercontent.com/Eisdaemon/Bwinf-Bewertung/refs/heads/main/Linux/ioi_renew.sh
    wget https://raw.githubusercontent.com/Eisdaemon/Bwinf-Bewertung/refs/heads/main/Linux/anderes.sh
    wget https://raw.githubusercontent.com/Eisdaemon/Bwinf-Bewertung/refs/heads/main/Linux/anderes_renew.sh
    wget https://raw.githubusercontent.com/Eisdaemon/Bwinf-Bewertung/refs/heads/main/Linux/renew_ioi.service
    wget https://raw.githubusercontent.com/Eisdaemon/Bwinf-Bewertung/refs/heads/main/Linux/renew_ioi.timer
    #Commands
    mv ioi.sh /home/sysoperator/bin/ioi.sh
    mv ioi_renew.sh /home/sysoperator/bin/ioi_renew.sh
    mv anderes.sh /home/sysoperator/bin/anderes.sh
    mv anderes_renew.sh /home/sysoperator/bin/anderes_renew.sh

    chmod +x /home/sysoperator/bin/ioi.sh
    chmod +x /home/sysoperator/bin/ioi_renew.sh
    chmod +x /home/sysoperator/bin/anderes.sh
    chmod +x /home/sysoperator/bin/anderes_renew.sh

    #Services
    sudo mv renew_ioi.service /etc/systemd/system
    sudo mv renew_ioi.timer /etc/systemd/system

    #Enable services
    sudo systemctl daemon-reload
    sudo systemctl enable renew_ioi.timer
    sudo systemctl start renew_ioi.timer
}

set_bewertung_config() {
#ToDo Set up Wlan
#ToDo Set up Dolphin Bookmark
#ToDo Set up Samba Share
}

create_accounts
install_all_programms
add_bin_container
set_ip_rules
create_backups
set_backup_commands
