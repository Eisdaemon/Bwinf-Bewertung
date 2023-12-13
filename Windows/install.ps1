# #Requires -RunAsAdministrator
# The Scipt Assumes it is used by SysOperator

#We begin by debloating

do {
  $RunDebloat = Read-Host -Prompt "Have you already run the Debloat Script? (y/n)"
} while ($RunDebloat -ne "y" or $RunDebloat -ne "n")

if ($RunDebloat -eq "n") {
  $WebClient = New-Object System.Net.WebClient
  $WebClient.DownlaodFile("https://raw.githubusercontent.com/Eisdaemon/Bwinf-Bewertung/main/Windows/debloat.ps1")
  $PSScriptRoot/debloat.ps1
}

#Check if Chris Titus tool war run for Optimizations
do {
  $RunChris = Read-Host -Prompt "Have you already run the Chris Titus Tool for Optimizations? You may have to restart the script after using it(y/n)"
} while ($RunChris -ne "y" or $RunChris -ne "n")

if ($RunChris -eq "n") {
  iwr -useb https://christitus.com/win | iex
}

#Now it should be Sufficiently Debloated
#Install Winget and Chocolatey
  $URL = "https://api.github.com/repos/microsoft/winget-cli/releases/latest"
  $URL = (Invoke-WebRequest -Uri $URL).Content | ConvertFrom-Json |
        Select-Object -ExpandProperty "assets" |
        Where-Object "browser_download_url" -Match '.msixbundle' |
        Select-Object -ExpandProperty "browser_download_url"

  #  download
  Invoke-WebRequest -Uri $URL -OutFile "Setup.msix" -UseBasicParsing

  # install
  Add-AppxPackage -Path "Setup.msix"

  # delete file
  Remove-Item "Setup.msix"

#  #Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

do {
  $WhatKind = Read-Host -Prompt "Is the Device for the Pool or a coworker (pool/coworker)"
} while ($WhatKind -ne "pool" or $WhatKind -ne "coworker")

if ($WhatKind -eq "pool") {
#Install all Pool Software for Windows

  $UserPass = Read-Host -Prompt "Enter the Password for the User Account"
  net user user $UserPass /add
  $BewertungPass  = Read-Host -Prompt "Enter the Password for the Bewertungs Account"
  net user bewertung $BewertungPass /add
  #Make Bewertung Adming
  Add-LocalGroupMember -Group "Administrators" -Member "bewertung"
  $Users "SysOperator", "bewertung", "user"
  #Remove Expiring Password
  $Users | ForEach-Object {Set-ADUser -Identity $_.SamAccountName -PasswordNeverExpires:$True}

  #Install via Choco: Kate, Okular and Update every choco Package
  choco install kate; choco install okular; choco upgrade all

  #Install via winget: Virtual Box, BlueJ, Scratch, LibreOffice, LibreWolf, Neovim, vim, Pycharm and IntelliJ, Windows Terminal and add a new "user" account, it also should update every winget install programm
  winget install -e --id Oracle.VirtualBox; winget install -e --id BlueJTeam.BlueJ; winget install -e --id MITMediaLab.Scratch.3; winget install -e --id TheDocumentFoundation.LibreOffice; winget install -e --id LibreWolf.LibreWolf; winget install -e --id Neovim.Neovim; winget install -e --id vim.vim; winget install -e --id JetBrains.PyCharm.Community.EAP; winget install -e --id JetBrains.IntelliJIDEA.Community; winget install -e --id Microsoft.WindowsTerminal; winget install -e --id Microsoft.VisualStudioCode; winget upgrade --all; net user user ioi-workshop /ADD
  #Legt eine Txt mit Infos über die Programme an

  winget install -e --id Spyder.Spyder; winget install -e --id Python.Python.3.11; winget install -e --id Anaconda.Anaconda3

  cd ..\..\users\bewertung\Desktop; echo "Installiert sind folgende Programmier Tools:" "Kate, vim, neovim, Pycharm, IntelliJ, BlueJ, Scratch, Windows Terminal, VSCode" "Ansonsten sind installiert worden:" "LibreWolf, Okular, LibreOffice, VirtualBox" > Programme.txt
} elseif ($WhatKind -eq "coworker") {
  $UserName = Read-Host -Prompt "Enter the last the of the coworker"
  $UserPass = Read-Host -Prompt "Enter the Password for the User"
  net user $UserName $UserPass /add
  Add-LocalGroupMember -Group "Administrators" -Member $UserName
  $Users "SysOperator", $UserName
  #Remove Expiring Password
  $Users | ForEach-Object {Set-ADUser -Identity $_.SamAccountName -PasswordNeverExpires:$True}
  winget install -e --id 7zip.7zip; winget install -e --id TheDocumentFoundation.LibreOffice; winget install -e --id Mozilla.Thunderbird; winget install -e --id Mozilla.Firefox; winget install -e --id Google.Chrome; winget install -e --id Adobe.Acrobat.Reader.64-bit; winget install -e --id GIMP.GIMP
  choco install okular
  "For CloudPBX 2.0 there is no convient way of installation and for Element you have to change the Account to the Coworkers Accout, as there is no System Wide Installation"
}

"Finished Install Script for Windows"
