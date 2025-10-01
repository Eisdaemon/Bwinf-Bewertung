
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
    sudo apt upgrade

    wget github.com/atom/atom/releases/download/v1.60.0/atom-amd64.deb
    sudo apt install ./atom-amd64.deb
    sudo apt-get install build-essential

    #Apt installed editors
    sudo apt-get install python3 geany joe emacs nano neovim python3-neovim sublime-text vim code ddd gdb valgrind ruby konsole keditbookmarks default-jre python3-pip python3-spyder


    #Jet Brains Packages
    sudo snap install clion --classic
    sudo snap install pycharm-community --classic


    #Eclipse
    sudo snap install eclipse --classic

    #KDevelop
    sudo snap install kdevelop --classic

sudo -u girlsuser bash << 'EOF'
# Install Anaconda as USER2
wget https://repo.anaconda.com/archive/Anaconda3-2022.05-Linux-x86_64.sh
chmod +x Anaconda3-2022.05-Linux-x86_64.sh
sudo bash Anaconda3-2022.05-Linux-x86_64.sh
./anaconda3/bin/conda init
EOF

    #ToDo
    #Download and configure code add ons
    #https://stackoverflow.com/questions/34286515/how-to-install-visual-studio-code-extensions-from-command-line
}

create_accounts () {
    echo "Enter the Password for anderes"
    read anderes_pass
    sudo useradd -m anderes && echo "anderes:$anderes_pass" | sudo chpasswd
    echo "Enter the Password for bewertung"
    read bewertung_pass
    sudo useradd -m bewertung && echo "bewertung:$bewertung_pass" | sudo chpasswd
    echo "Enter the Password for ioiuser"
    read ioi_pass
    sudo useradd -m ioiuser && echo "ioiuser:$ioi_pass" | sudo chpasswd
    echo "Enter the Password for girlsuser"
    read girls_pass
    sudo useradd -m girlsuser && echo "girlsuser:$girls_pass" | sudo chpasswd
}

set_ip_rules() {
    wget https://raw.githubusercontent.com/Eisdaemon/Bwinf-Bewertung/main/Linux/ip.sh
    mv ip.sh ~/bin/
    chmod +x ~/bin/ip.sh
    sudo ~/bin/ip.sh
}

add_bin_container() {
    mkdir -p ~/bin
    echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
    source ~/.bashrc
}

create_backups() {
    sudo cp -r /home/ioiuser /home/sysoperator
    sudo cp -r /home/girlsuser /home/sysoperator
    sudo cp -r /home/anderes /home/sysoperator
}

create_accounts
install_all_programms
add_bin_container
set_ip_rules
create_backups

