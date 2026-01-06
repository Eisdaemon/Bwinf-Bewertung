#Install iptables-persistant 
apt-get install netfilter-persistent
apt-get install iptables-persistent

# Download File to remove all IPtable settings if no longer needed
if test -f ip_away.sh; then
	echo "ip_away.sh is already downloaded"
else
	wget https://raw.githubusercontent.com/Eisdaemon/Bwinf-Bewertung/refs/heads/main/Linux/ip_away.sh
	# Make it executable
	mv ip_away.sh /home/sysoperator/bin/
	chmod +x /home/sysoperator/bin/ip_away.sh
fi

# IPv6

#Get uid of ioiuser
UID_IP=$(id -u ioiuser)
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

# Allow all on loopback for that user
iptables -A OUTPUT -o lo -m owner --uid-owner $UID_IP -j ACCEPT

# Drop invalid packets
iptables -N drop_invalid
iptables -A OUTPUT   -m state --state INVALID  -j drop_invalid
iptables -A INPUT    -m state --state INVALID  -j drop_invalid
iptables -A INPUT -p tcp -m tcp --sport 1:65535 --tcp-flags FIN,SYN,RST,PSH,ACK,URG NONE -j drop_invalid
iptables -A drop_invalid -j DROP

# Drop TCP sessions opened prior to firewall restart
iptables -A INPUT  -p tcp -m tcp ! --tcp-flags SYN,RST,ACK SYN -m state --state NEW -j DROP
iptables -A OUTPUT -p tcp -m tcp ! --tcp-flags SYN,RST,ACK SYN -m state --state NEW -j DROP

# Allow HTTP and HTTPS to contest.informatik-olympiade.de for that user
iptables -A OUTPUT -p tcp --dport 80  -d 138.201.137.186 -m owner --uid-owner $UID_IP -j ACCEPT
iptables -A OUTPUT -p tcp --dport 443 -d 138.201.137.186 -m owner --uid-owner $UID_IP -j ACCEPT

# Finally: drop everything else from that user
iptables -A OUTPUT -p tcp -m owner --uid-owner $UID_IP -j REJECT --reject-with tcp-reset
iptables -A OUTPUT -m owner --uid-owner $UID_IP -j REJECT
# Drop everything IPv6 for that user

ip6tables -A OUTPUT -m owner --uid-owner $UID_IP -j REJECT

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





