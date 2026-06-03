#!/bin/bash
set -e  # Exit on any error

# Kill all processes for ioiuser
pkill -u ioiuser || true  # Ignore failure if no processes

# Wait a moment for processes to die
sleep 1

# Delete the user and home directory
userdel -r ioiuser || { echo "Failed to delete ioiuser"; exit 1; }

# Recreate the user
useradd -m ioiuser || { echo "Failed to create ioiuser"; exit 1; }
echo "ioiuser:user" | chpasswd || { echo "Failed to set password"; exit 1; }

# Copy files
cp -a /home/sysoperator/ioiuser/. /home/ioiuser/ || { echo "Failed to copy files"; exit 1; }

# Set ownership
chown -R ioiuser:ioiuser /home/ioiuser || { echo "Failed to chown"; exit 1; }

# Run ip.sh
/home/sysoperator/bin/ip.sh || { echo "Failed to run ip.sh"; exit 1; }
