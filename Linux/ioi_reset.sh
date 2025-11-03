#!/bin/bash

userdel -r ioiuser
useradd -m ioiuser
echo "ioiuser:user" | chpasswd

cp -a /home/sysoperator/ioiuser/. /home/ioiuser

chown -R ioiuser:ioiuser /home/ioiuser
