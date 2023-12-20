#Requires -RunAsAdministrator
# The Scipt Assumes it is used by SysOperator

#Cd to home Path, where Files are downloaded.
#It is not possible to download something to the standard folder, so we move to out homefolder
cd C:\Users\SysOperator

#Download a Script to install winget and execute it
Write-Host "Downloading Winget Script and Executing it"
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Eisdaemon/Bwinf-Bewertung/main/Windows/winget.ps1" -OutFile "C:\Users\SysOperator\winget.ps1"
$PSScriptRoot
& "$PSScriptRoot\winget.ps1"
#Register Winget
Add-AppxPackage -RegisterByFamilyName -MainPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe
#Clean Up the Winget install script
Write-Host "Downloading and Installing Chocolatey"
Remove-Item C:\Users\SysOperator\winget.ps1
#Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

#The Debloat Script is downloaded and executed, if not done already
Write-Host "Now we begin with debloating Windows"
do {
  $RunDebloat = Read-Host -Prompt "Have you already run the Debloat Script? (y/n)"
} while ($RunDebloat -ne "y" -and $RunDebloat -ne "n")

if ($RunDebloat -eq "n") {
  Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Eisdaemon/Bwinf-Bewertung/main/Windows/debloat.ps1" -OutFile "C:\Users\SysOperator\debloat.ps1"
  $PSScriptRoot
  & "$PSScriptRoot\debloat.ps1"
  Remove-Item C:\Users\SysOperator\debloat.ps1
}

#Check if Chris Titus tool was run for Optimizations, this should be (most of the time) only be used for Optimizations. Installs are handled later, depending on Laptop type.
Write-Host "Now we execute the Chris Titus Tool. Installing Programms is handled later, but the Optimizations should be executed"
Start-Sleep -Seconds 2.5
do {
  $RunChris = Read-Host -Prompt "Have you already run the Chris Titus Tool for Optimizations? You may have to restart the script after using it(y/n)"
} while ($RunChris -ne "y" -and $RunChris -ne "n")

if ($RunChris -eq "n") {
  iwr -useb https://christitus.com/win | iex
}

#Now Windows should be sufficiently debloated, removing a lot of bullsit, diabsling telemetry and many stupid tasks
#We now ask if the device is used for a pool Laptop, or a coworker. Depending on which, different accounts and software will be used
do {
  $WhatKind = Read-Host -Prompt "Is the Device for the Pool or a coworker (pool/coworker)"
} while ($WhatKind -ne "pool" -and $WhatKind -ne "coworker")
if ($WhatKind -eq "pool") {
  
  #For a Pool Laptop we use to accounts, besides the SysOperator, these are an Admin "bewertung" Account for the evaluation days of the BWINF and a user account, for something like the Girl Camps

  $UserPass = Read-Host -Prompt "Enter the Password for the User Account"
  net user bwinfuser $UserPass /add
  $BewertungPass  = Read-Host -Prompt "Enter the Password for the Bewertungs Account"
  net user bewertung $BewertungPass /add
  #Make Bewertung Adming
  Add-LocalGroupMember -Group "Administrators" -Member "bewertung"
  Add-LocalGroupMember -Group "Administratoren" -Member "bewertung" #We try again with the German word
  Write-Host "You Only need to check if you get two Errors like that, as it tries german and english localization"
  Set-LocalUser -Name "bwinfuser" -PasswordNeverExpires:$true
  Set-LocalUser -Name "bewertung" -PasswordNeverExpires:$true
  Set-LocalUser -Name "SysOperator" -PasswordNeverExpires:$true

  #Install all Pool Software for Windows
  #A full List of Programms is found on the Wiki in git

  #Install via Choco: Kate, Okular and Update every choco Package
  choco install kate; choco install okular; choco upgrade all

  #Install via winget: Virtual Box, BlueJ, Scratch, LibreOffice, LibreWolf, Neovim, vim, Pycharm and IntelliJ, Windows Terminal  also should update every winget install programm
  winget install -e --id Oracle.VirtualBox; winget install -e --id BlueJTeam.BlueJ; winget install -e --id MITMediaLab.Scratch.3; winget install -e --id TheDocumentFoundation.LibreOffice; winget install -e --id LibreWolf.LibreWolf; winget install -e --id Neovim.Neovim; winget install -e --id vim.vim; winget install -e --id JetBrains.PyCharm.Community.EAP; winget install -e --id JetBrains.IntelliJIDEA.Community; winget install -e --id Microsoft.WindowsTerminal; winget install -e --id Microsoft.VisualStudioCode; winget upgrade --all;
  #Legt eine Txt mit Infos über die Programme an
  winget install -e --id Spyder.Spyder; winget install -e --id Python.Python.3.11; winget install -e --id Anaconda.Anaconda3; winget install -e --id 7zip.7zip
  cd ..\..\users\bewertung\Desktop; echo "Installiert sind folgende Programmier Tools:" "Kate, vim, neovim, Pycharm, IntelliJ, BlueJ, Scratch, Windows Terminal, VSCode" "Ansonsten sind installiert worden:" "LibreWolf, Okular, LibreOffice, VirtualBox" > Programme.txt
} elseif ($WhatKind -eq "coworker") {

  #Coworkers get an Adming Account too. The UserName should be the last Name, and the password should be the same as for the Server
  $UserName = Read-Host -Prompt "Enter the last the of the coworker"
  $UserPass = Read-Host -Prompt "Enter the Password for the User"
  net user $UserName $UserPass /add
  #The Coworkers do have to become admins, due to the Fact that WireGuard only works on admin accounts
  Add-LocalGroupMember -Group "Administrators" -Member $UserName
  Add-LocalGroupMember -Group "Administratoren" -Member $UserName #We try again with the German word
  Write-Host "You Only need to check if you get two Errors like that, as it tries german and english localization"
  #Remove Expiring Password
  Set-LocalUser -Name "SysOperator" -PasswordNeverExpires:$true
  Set-LocalUser -Name $UserName -PasswordNeverExpires:$true
  winget install -e --id 7zip.7zip; winget install -e --id TheDocumentFoundation.LibreOffice; winget install -e --id Mozilla.Thunderbird; winget install -e --id Mozilla.Firefox; winget install -e --id Google.Chrome; winget install -e --id Adobe.Acrobat.Reader.64-bit; winget install -e --id GIMP.GIMP; winget install -e --id WireGuard.WireGuard
  choco install okular
  Write-Host "Create Shortcut on Desktop pointing to \\192.168.2.2\ with the Name Server - creating something like that through Powershell is way more tedious than it has any right to be"

  do {
    $Exists = Read-Host -Prompt "Is the Shortcut ready? (y/n)"
  } while ($Exists -ne "y" -and $Exists -ne "n")
  cd ..\..\users\SysOperator\Desktop; copy Server.lnk ..\..\Public\Desktop
  Write-Host "For CloudPBX 2.0 there is no convient way of installation and for Element you have to change the Account to the Coworkers Accout, as there is no System Wide Installation"
}

Write-Host "Finished Install Script for Windows"
