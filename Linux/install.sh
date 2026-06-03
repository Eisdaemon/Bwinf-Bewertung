#!/bin/bash


#Install all Programms for the IOI and Girls Workshop
install_all_programms () {
    #Add Repos
    add-apt-repository universe
    wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo tee /etc/apt/keyrings/sublimehq-pub.asc > /dev/null
    echo -e 'Types: deb\nURIs: https://download.sublimetext.com/\nSuites: apt/stable/\nSigned-By: /etc/apt/keyrings/sublimehq-pub.asc' | sudo tee /etc/apt/sources.list.d/sublime-text.sources
    echo "code code/add-microsoft-repo boolean true" | sudo debconf-set-selections
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
    sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    rm packages.microsoft.gpg
    wget -O- https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo gpg --dearmor --yes --output /usr/share/keyrings/oracle-virtualbox-2016.gpg
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/oracle-virtualbox-2016.gpg] http://download.virtualbox.org/virtualbox/debian $(. /etc/os-release && echo "$VERSION_CODENAME") contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list

    apt update
    apt -y upgrade

    wget github.com/atom/atom/releases/download/v1.60.0/atom-amd64.deb
    apt -y install ./atom-amd64.deb
    apt-get -y install build-essential
    rm atom-amd64.deb

    #Apt installed editors
    apt-get -y install python3 geany joe emacs nano neovim python3-neovim sublime-text vim code ddd gdb valgrind ruby konsole python3-pip kate

    #Vbox
    touch /etc/modprobe.d/blacklist-kvm.conf
    echo -e "blacklist kvm\nblacklist kvm_amd\nblacklist kvm_intel" | sudo tee /etc/modprobe.d/blacklist-kvm.conf
    modprobe -r kvm_intel kvm 2>/dev/null
    modprobe -r kvm_amd kvm 2>/dev/null
    apt install virtualbox-7.2
    usermod -aG vboxusers $USER
    usermod -aG vboxusers anderes




    #Eclipse
    snap install eclipse --classic

    #KDevelop
    snap install kdevelop --classic

    apt-get remove -y "telnetd"

    #Documentation
    wget https://docs.python.org/3/archives/python-3.14-docs-html.tar.bz2
    wget https://github.com/PeterFeicht/cppreference-doc/releases/download/v20250209/html-book-20250209.tar.xz
    mkdir -p /home/ioiuser/docs
    tar -xvjf python-3.14-docs-html.tar.bz2 -C /home/ioiuser/docs
    tar -xJf html-book-20250209.tar.xz -C /home/ioiuser/docs
    chown -R ioiuser:ioiuser /home/ioiuser/docs
    rm python-3.14-docs-html.tar.bz2
    rm html-book-20250209.tar.xz

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
    sed -i 's|^SHELL=/bin/sh$|SHELL=/bin/bash|' /etc/default/useradd
    useradd -m anderes && echo "anderes:user" | sudo chpasswd
    echo "Enter the Password for the account bewertung"
    read bewertung_pass
    useradd -m bewertung && echo "bewertung:$bewertung_pass" | sudo chpasswd
    useradd -m ioiuser && echo "ioiuser:user" | sudo chpasswd
}

set_ip_rules() {
    wget https://raw.githubusercontent.com/Eisdaemon/Bwinf-Bewertung/main/Linux/ip.sh
    mv ip.sh /home/sysoperator/bin/
    wget https://raw.githubusercontent.com/Eisdaemon/Bwinf-Bewertung/main/Linux/ip_dns_list
    mv ip_dns_list /home/sysoperator/bin/
    wget https://raw.githubusercontent.com/Eisdaemon/Bwinf-Bewertung/main/Linux/ip6_dns_list
    mv ip6_dns_list /home/sysoperator/bin/
    chmod +x /home/sysoperator/bin/ip.sh
    /home/sysoperator/bin/ip.sh
}

add_bin_container() {
    mkdir -p /home/sysoperator/bin
}

create_backups() {
    cp -a /home/ioiuser /home/sysoperator
    cp -a /home/anderes /home/sysoperator
    cp -a /home/ioiuser /home/sysoperator/ioiuser_og
    cp -a /home/anderes /home/sysoperator/anderes_og

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
    mv renew_ioi.service /etc/systemd/system
    mv renew_ioi.timer /etc/systemd/system

    #Enable services
    systemctl daemon-reload
    systemctl enable renew_ioi.timer
    systemctl start renew_ioi.timer
}

set_bewertung_config() {
    #Add the Wlan to the config
    wget https://raw.githubusercontent.com/Eisdaemon/Bwinf-Bewertung/refs/heads/main/Linux/bewertungs-plan.yaml
    wlan_device=$(ip link show | grep -E wl | awk '/^[0-9]+: [^:]+:/ {print $2}' | tr -d :)
    sed -i -e "s/WLAN_DEVICE_PLACEHOLDER/$wlan_device/g" bewertungs-plan.yaml
    echo "Enter the password for the WLAN: Bewertung"
    read bewertung_pass
    echo "            password: \"$bewertung_pass\"" >> bewertungs-plan.yaml
    chown root:root bewertungs-plan.yaml
    chmod 0600 bewertungs-plan.yaml
    mv bewertungs-plan.yaml /etc/netplan
    netplan apply
    netplan get

}

other_config() {

    wget https://raw.githubusercontent.com/Eisdaemon/Bwinf-Bewertung/refs/heads/main/Linux/policies.json
    mkdir -p /etc/firefox/policies
    mv policies.json  /etc/firefox/policies
    #Set Grub Password
    #No Welcome Screen for new users.
    apt remove --autoremove gnome-initial-setup
    #Auto Updates for Security Updates
    apt-get install unattended-upgrades
    dpkg-reconfigure unattended-upgrades
    echo "Please set up a password for grub"
    echo -e "Please set the default grub. For that open the file at /etc/default/grub and afterwards execute update-grub."
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

