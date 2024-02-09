
add_accept () { #Add the accepted IP to the Accept list
  iptables -A INPUT  -p tcp -s $1 -m tcp --dport 443 -j ACCEPT
  iptables -A INPUT  -p tcp -s $1 -m tcp --dport 80 -j ACCEPT
  iptables -A OUTPUT -p tcp -d $1 -m tcp --dport 80 -j ACCEPT
  iptables -A OUTPUT -p tcp -d $1 -m tcp --dport 443 -j ACCEPT
  echo "Added $1 to Accept list\nNote: This Part only adds ip adresses, if you add ip addresses which are not for the contest site and you want to use dns you may need to add them  manually to /etc/hosts"

}

more_sites () {
  echo "Usually only the ip for contest.informatik-olympiade.de is allowed\n If more ip have to be allowed we need to add them here. \n This is e.g. necessary if all traffic is routed through something else first\n Is it necessary(y/n)"
  read YESNO
  if [ "$YESNO" == "y" ]; then
    echo "Please type the ip in:"
    read IP_ADRESS
    add_accept $IP_ADRESS
    more_sites
  else 
    echo "Continue as usual"
    # Save these Rules to make them Persistant
    iptables-save > /etc/iptables/rules.v4
    ip6tables-save > /etc/iptables/rules.v6

    # Activate the Persistant Netfilter
    systemctl enable netfilter-persistent.service
    systemctl status netfilter-persistent.service
    netfilter-persistent start

    # Add the Website to Hosts:
    if grep -Fxq '138.201.137.186 contest.informatik-olympiade.de' /etc/hosts; then
        echo "contest.informatik-olympiade.de is already in the host file"
    else
        echo "138.201.137.186 contest.informatik-olympiade.de" >> /etc/hosts
    fi
  fi
}

#Install iptables-persistant 
apt-get install netfilter-persistent
apt-get install iptables-persistent

# Download File to remove all IPtable settings if no longer needed
if test -f ip_away.sh; then
	echo "ip_away.sh is already downloaded"
else
	wget https://raw.githubusercontent.com/Eisdaemon/Bwinf-Bewertung/main/ip_away.sh
	# Make it executable
	chmod +x ip_away.sh
fi

# IPv6

##
## set default policies to let everything in
ip6tables --policy INPUT   ACCEPT;
ip6tables --policy OUTPUT  ACCEPT;
ip6tables --policy FORWARD ACCEPT;

##
## start fresh
ip6tables -Z; # zero counters
ip6tables -F; # flush (delete) rules
ip6tables -X; # delete all extra chains

# IPv4

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


# Drop everything
iptables -P OUTPUT  DROP
iptables -P INPUT   DROP
iptables -P FORWARD DROP

# Drop everything IPv6
ip6tables -P OUTPUT  DROP
ip6tables -P INPUT   DROP
ip6tables -P FORWARD DROP

# drop TCP sessions opened prior firewall restart
iptables -A INPUT -p tcp -m tcp ! --tcp-flags SYN,RST,ACK SYN -m state --state NEW -j DROP
iptables -A OUTPUT  -p tcp -m tcp ! --tcp-flags SYN,RST,ACK SYN -m state --state NEW -j DROP

# drop packets that do not match any valid state
iptables -N drop_invalid
iptables -A OUTPUT   -m state --state INVALID  -j drop_invalid 
iptables -A INPUT    -m state --state INVALID  -j drop_invalid 
iptables -A INPUT -p tcp -m tcp --sport 1:65535 --tcp-flags FIN,SYN,RST,PSH,ACK,URG NONE -j drop_invalid 
iptables -A drop_invalid -j DROP

# ESTABLISHED,RELATED
iptables -A INPUT  -m state --state ESTABLISHED,RELATED  -j ACCEPT

# allow all on loopback
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT
iptables -A FORWARD -o lo -j ACCEPT

#(INVALID OUT)
iptables -A OUTPUT -p tcp -m tcp ! --tcp-flags SYN,RST,ACK SYN -m state --state NEW -j DROP

# ESTABLISHED,RELATED (OUT)
iptables -A OUTPUT  -m state --state ESTABLISHED,RELATED  -j ACCEPT

## repeat this section for multiple IPs
add_accept "128.201.137.196"

more_sites





