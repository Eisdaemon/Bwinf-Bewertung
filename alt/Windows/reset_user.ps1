net user bwinfuser /delete
$UserPass = Read-Host -Prompt "Enter the Password for the User Account"
net user bwinfuser $UserPass /add
Set-LocalUser -Name "bwinfuser" -PasswordNeverExpires:$true
