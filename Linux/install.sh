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
    sudo apt-get -y install python3 geany joe emacs nano neovim python3-neovim sublime-text vim code ddd gdb valgrind ruby konsole python3-pip kate


    #Eclipse
    sudo snap install eclipse --classic

    #KDevelop
    sudo snap install kdevelop --classic

    sudo apt-get remove -y "telnetd"

    #Documentation
    wget https://docs.python.org/3/archives/python-3.14-docs-html.tar.bz2
    wget https://github.com/PeterFeicht/cppreference-doc/releases/download/v20250209/html-book-20250209.tar.xz
    sudo mkdir -p /home/ioiuser/docs
    sudo tar -xvjf python-3.14-docs-html.tar.bz2 -C /home/ioiuser/docs
    sudo tar -xJf html-book-20250209.tar.x -C /home/ioiuser/docs
    sudo chown -R ioiuser:ioiuser /home/ioiuser/docs

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
    echo "Enter the Password for the account bewertung"
    read bewertung_pass
    sudo useradd -m bewertung && echo "bewertung:$bewertung_pass" | sudo chpasswd
    sudo useradd -m ioiuser && echo "ioiuser:user" | sudo chpasswd
}

set_ip_rules() {
    wget https://raw.githubusercontent.com/Eisdaemon/Bwinf-Bewertung/main/Linux/ip.sh
    mv ip.sh /home/sysoperator/bin/
    chmod +x /home/sysoperator/bin/ip.sh
    echo -e "Note: As of now the policies are still disabled, so that VsCode can actually get the Addons on first open with the ioiuser and start vscode once...\n
    Just change the account, do not log out and resume the install afterwards"
    while true; do
        echo "Do you want to continue? (y)"
        read answer

        if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
            echo "Resuming operation..."
            break
        else
            echo "Invalid input. Please enter 'y' to continue."
        fi
    done
    sudo /home/sysoperator/bin/ip.sh
}

add_bin_container() {
    mkdir -p /home/sysoperator/bin
}

create_backups() {
    sudo cp -a /home/ioiuser /home/sysoperator
    sudo cp -a /home/anderes /home/sysoperator
    sudo cp -a /home/ioiuser /home/sysoperator/ioiuser_og
    sudo cp -a /home/anderes /home/sysoperator/anderes_og

}

set_bewertungs_mode () {
    wget https://raw.githubusercontent.com/Eisdaemon/Bwinf-Bewertung/refs/heads/main/Linux/bewertungs_mode.sh
    mv bewertungs_mode.sh /home/sysoperator/bin/bewertungs_mode.sh
    chmod +x /home/sysoperator/bin/bewertungs_mode.sh
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
    #Add the Wlan to the config
    wget https://raw.githubusercontent.com/Eisdaemon/Bwinf-Bewertung/refs/heads/main/Linux/bewertungs-plan.yaml
    wlan_device=$(ip link show | grep -E wl | awk '/^[0-9]+: [^:]+:/ {print $2}' | tr -d :)
    sed -i -e "s/WLAN_DEVICE_PLACEHOLDER/$wlan_device/g" bewertungs-plan.yaml
    echo "Enter the password for the WLAN: Bewertung"
    read bewertung_pass
    echo "            password: \"$bewertung_pass\"" >> bewertungs-plan.yaml
    sudo chown root:root bewertungs-plan.yaml
    sudo chmod 0600 bewertungs-plan.yaml
    sudo mv bewertungs-plan.yaml /etc/netplan
    sudo netplan apply
    sudo netplan get

}

other_config() {

    wget https://raw.githubusercontent.com/Eisdaemon/Bwinf-Bewertung/refs/heads/main/Windows/pool/policies.json
    sudo mkdir -p /etc/firefox/policies
    sudo mv policies.json  /etc/firefox/policies
    #Set Grub Password
    #No Welcome Screen for new users.
    sudo apt remove --autoremove gnome-initial-setup
    #Auto Updates for Security Updates
    sudo apt-get install unattended-upgrades
    sudo dpkg-reconfigure unattended-upgrades
    echo "Please set up a password for grub"
    grub-mkpasswd-pbkdf2
    echo -e "Please set the default grub. For that open the file at /etc/default/grub and afterwards execute update-grub. Also add the following too /etc/grub.d/40_custom:
    \nset superusers="boot"
    \npassword_pbkdf2 boot grub.pbkdf2.sha512.VeryLongString"
}
create_accounts
install_all_programms
add_bin_container
set_ip_rules
create_backups
set_backup_commands
set_bewertung_config
set_bewertungs_mode
other_config

wget https://raw.githubusercontent.com/Eisdaemon/Bwinf-Bewertung/refs/heads/main/Linux/Command_Explanation.md
mv Command_Explanation.md /home/sysoperator/bin
echo -e "################################################################\n \nFinished with the Setup of the Pool pc.\n \n################################################################"

