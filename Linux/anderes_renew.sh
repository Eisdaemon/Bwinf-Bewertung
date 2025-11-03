#!/bin/bash

userdel -r anderes
useradd -m anderes
echo "anderes:user" | chpasswd

cp -a /home/sysoperator/anderes/. /home/anderes

chown -R anderes:anderes /home/anderes
