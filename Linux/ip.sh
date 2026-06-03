#!/bin/bash
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root" >&2
    exit 1
fi

set -e

#Global because shit support with paramenters
if [ ! -f /home/sysoperator/bin/ip_dns_list ] && [ ! -f /home/sysoperator/bin/ip6_dns_list ]; then
    echo "Allow lists are missing!"; exit 1;
fi
#Read lines from the files, ignore first line, remove empty lines
readarray -t ip_dns < <(tail -n +2 /home/sysoperator/bin/ip_dns_list | grep -v '^$')
readarray -t ip6_dns < <(tail -n +2 /home/sysoperator/bin/ip6_dns_list | grep -v '^$')
ip=()
ip6=()

install_dependencies() {
    #Install iptables-persistant
    apt-get install iptables-persistent

    # Download File to remove all IPtable settings if no longer needed
    if test -f ip_away.sh; then
        echo "ip_away.sh is already downloaded"
    else
        wget https://raw.githubusercontent.com/Eisdaemon/Bwinf-Bewertung/refs/heads/main/Linux/ip_away.sh || { echo "Failed to download ip_away.sh"; exit 1; }
        # Make it executable
        mv -f ip_away.sh /home/sysoperator/bin/
        chmod +x /home/sysoperator/bin/ip_away.sh
    fi
    #kill old rules
    sudo /home/sysoperator/bin/ip_away.sh
}

create_lists() {

    #Get all ips and dns which should be allowed


    if [ ${#ip_dns[@]} -eq 0 ] && [ ${#ip6_dns[@]} -eq 0 ]; then
        echo "Allow lists are empty!"; exit 1;
    fi

    #Split them, since i also need the ip only

    for i in "${ip_dns[@]}"
    do
        substring=${i%% *}
        ip+=($substring)
    done
    for i in "${ip6_dns[@]}"
    do
        substring=${i%% *}
        ip6+=($substring)
    done
}

set_ip_rules() {

    #Get uid of ioiuser
    UID_IP=$(id -u ioiuser) || { echo "User ioiuser does not exist!"; exit 1; }
    ## set default policies to let everything in
    ip6tables --policy INPUT   ACCEPT;
    ip6tables --policy OUTPUT  ACCEPT;
    ip6tables --policy FORWARD ACCEPT;

    ##
    ## start fresh
    ip6tables -Z; # zero counters
    ip6tables -F; # flush (delete) rules
    ip6tables -X; # delete all extra chains

    # # IPv4

    ##
    ## set default policies to let everything in
    iptables --policy INPUT   ACCEPT;
    iptables --policy OUTPUT  ACCEPT;
    iptables --policy FORWARD ACCEPT;

    ##
    ## start fresh
    iptables -Z; # zero counters
    iptables -F; # flush (delete) rules
    iptables -X; # delete all extra chains

    # --- IPv4 rules ---

    # Allow established and related connections (systemwide)
    iptables -A INPUT  -m state --state ESTABLISHED,RELATED -j ACCEPT
    iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

    ip6tables -A INPUT  -m state --state ESTABLISHED,RELATED -j ACCEPT
    ip6tables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

    # Allow all on loopback for that user
    iptables -A OUTPUT -o lo -m owner --uid-owner $UID_IP -j ACCEPT
    ip6tables -A OUTPUT -o lo -m owner --uid-owner $UID_IP -j ACCEPT
    # Drop invalid packets
    iptables -N drop_invalid
    iptables -A OUTPUT   -m state --state INVALID  -j drop_invalid
    iptables -A INPUT    -m state --state INVALID  -j drop_invalid
    iptables -A INPUT -p tcp -m tcp --sport 1:65535 --tcp-flags FIN,SYN,RST,PSH,ACK,URG NONE -j drop_invalid
    iptables -A drop_invalid -j DROP

    ip6tables -N drop_invalid
    ip6tables -A OUTPUT   -m state --state INVALID  -j drop_invalid
    ip6tables -A INPUT    -m state --state INVALID  -j drop_invalid
    ip6tables -A INPUT -p tcp -m tcp --sport 1:65535 --tcp-flags FIN,SYN,RST,PSH,ACK,URG NONE -j drop_invalid
    ip6tables -A drop_invalid -j DROP

    # Drop TCP sessions opened prior to firewall restart
    iptables -A INPUT  -p tcp -m tcp ! --tcp-flags SYN,RST,ACK SYN -m state --state NEW -j DROP
    iptables -A OUTPUT -p tcp -m tcp ! --tcp-flags SYN,RST,ACK SYN -m state --state NEW -j DROP

    ip6tables -A INPUT  -p tcp -m tcp ! --tcp-flags SYN,RST,ACK SYN -m state --state NEW -j DROP
    ip6tables -A OUTPUT -p tcp -m tcp ! --tcp-flags SYN,RST,ACK SYN -m state --state NEW -j DROP

    # Allow HTTP and HTTPS to the allowed ips
    for i in "${ip[@]}"
    do
        iptables -A OUTPUT -p tcp --dport 80  -d $i -m owner --uid-owner $UID_IP -j ACCEPT
        iptables -A OUTPUT -p tcp --dport 443 -d $i -m owner --uid-owner $UID_IP -j ACCEPT
    done

    for i in "${ip6[@]}"
    do
        ip6tables -A OUTPUT -p tcp --dport 80  -d $i -m owner --uid-owner $UID_IP -j ACCEPT
        ip6tables -A OUTPUT -p tcp --dport 443 -d $i -m owner --uid-owner $UID_IP -j ACCEPT
    done

    # Finally: drop everything else from that user
    iptables -A OUTPUT -p tcp -m owner --uid-owner $UID_IP -j REJECT --reject-with tcp-reset
    iptables -A OUTPUT -m owner --uid-owner $UID_IP -j REJECT
    # Drop everything IPv6 for that user

    ip6tables -A OUTPUT -p tcp -m owner --uid-owner $UID_IP -j REJECT --reject-with tcp-reset
    ip6tables -A OUTPUT -m owner --uid-owner $UID_IP -j REJECT


    # Save these Rules to make them Persistant
    iptables-save > /etc/iptables/rules.v4 || { echo "Failed to save iptables rules"; exit 1; }
    ip6tables-save > /etc/iptables/rules.v6 || { echo "Failed to save ip6tables rules"; exit 1; }

    # Activate the Persistant Netfilter
    systemctl enable netfilter-persistent.service
    systemctl status netfilter-persistent.service
    netfilter-persistent start || { echo "Failed to start netfilter-persistent"; exit 1; }
}


set_hosts_file() {
    # Add the Website to Hosts:
    for i in "${ip_dns[@]}"; do
        # Skip if the line contains "NODNS"
        if [[ "$i" == *"NODNS"* ]]; then
            echo "Skipping $i (NODNS)"
            continue
        fi

        if grep -Fxq "$i" /etc/hosts; then
            echo "$i is already in the host file; addition is skipped"
        else
            echo "$i" >> /etc/hosts || { echo "Failed to write to /etc/hosts"; exit 1; }
        fi
    done

    for i in "${ip6_dns[@]}"; do
        # Skip if the line contains "NODNS"
        if [[ "$i" == *"NODNS"* ]]; then
            echo "Skipping $i (NODNS)"
            continue
        fi

        if grep -Fxq "$i" /etc/hosts; then
            echo "$i is already in the host file; addition is skipped"
        else
            echo "$i" >> /etc/hosts || { echo "Failed to write to /etc/hosts"; exit 1; }
        fi
    done
}


install_dependencies
create_lists
set_ip_rules
set_hosts_file
