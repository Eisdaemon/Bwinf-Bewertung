##Bwinf Bewertung

#Author Joris

In this repos are commands to make the Setup of Laptops for BWINF Contests as easy as possible.
The File Commands contains a bunch of commands to install programming Software, first on Windows, later on linux; Add a new user without password for the contestants 
and if necessary employ strict rules about the Website which can be accessed. In the Standard Config, access will reduced to contest.informatik-olympiade.de

The two files ip.sh and ip_away.sh are scripts to Setup Up the necessary iptable Rules or remove them afterwards. 
ip.sh also downloads ip_away.sh so you don't accediently cut your Internet without an option to undo.
It also appends the ip of contest.informatik-olympiade.de to /etc/hosts to make sure you can use the dns.
