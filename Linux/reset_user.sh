sudo deluser --remove-home bwinfuser
echo "Enter the Password for user"
read UserPass
sudo useradd -m -s /bin/bash bwinfuser
echo "bwinfuser:$UserPass" | sudo chpasswd
