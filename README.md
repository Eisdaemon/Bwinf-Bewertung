# Bwinf Bewertung

## Author: Joris Lamberty

In this repo are commands to make the Setup of Laptops for BWINF Contests as easy as possible. The File Commands contains a bunch of commands to install programming Software, first on Windows, later on Linux; Add a new user without password for the contestants and if necessary employ strict rules about the Website which can be accessed. In the Standard Config, access will be reduced to contest.informatik-olympiade.de

The two files ip.sh and ip_away.sh are scripts to Set up the necessary iptable Rules or remove them afterward. ip.sh also downloads ip_away.sh, so you don't accidentally cut your Internet without an option to undo. It also appends the IP of contest.informatik-olympiade.de to /etc/hosts to make sure you can use the DNS.

![alt text](https://maxleiter.com/blog/node-tooling/unix-poster.jpg)
