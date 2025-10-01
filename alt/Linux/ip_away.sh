# Flush all rules according to the Arch Wiki
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X
iptables -t raw -F
iptables -t raw -X
iptables -t security -F
iptables -t security -X
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT

# Save these Rules to make them Persistant:
iptables-save > /etc/iptables/rules.v4
ip6tables-save > /etc/iptables/rules.v6

#Disable the Netfilter Service
systemctl disable netfilter-persistent.service
netfilter-persistent stop
netfilter-persistent flush
