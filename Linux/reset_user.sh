sudo deluser --remove-home bwinfuser

wget https://raw.githubusercontent.com/Eisdaemon/Bwinf-Bewertung/main/Linux/add-user.sh
chmod +x add-user.sh
echo "Enter the Password for user"
read UserPass
./add-user.sh -u bwinfuser -p "$UserPass"
