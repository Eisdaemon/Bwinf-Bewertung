
#Bitlocker behaves badly on dual boot systems for the pool laptops
function disable_bitlocker {

}


#Chris titus tool
function chrissi {
    iwr -useb https://christitus.com/win | iex
}


#Install all necessary programms for a pool laptop
function install_programms {
    #Auto install from a config file, which has to be created.
    iex "& { $(irm https://christitus.com/win) } -Config [path-to-your-config] -Run"

    winget install Romanitho.Winget-AutoUpdate

}

#Set Up all necessary accounts.
function set_up_accounts {
  net user girlsuser user /add
  net user anderes user /add
  $BewertungPass  = Read-Host -Prompt "Enter the Password for the bewertungs Account"
  net user bewertung $BewertungPass /add
  #Make sure the passwords never expire
  Set-LocalUser -Name "girlsuser" -PasswordNeverExpires:$true
  Set-LocalUser -Name "anderes" -PasswordNeverExpires:$true
  Set-LocalUser -Name "bewertung" -PasswordNeverExpires:$true
  Set-LocalUser -Name "SysOperator" -PasswordNeverExpires:$true
}

function set_up_resets {
}

#Execution as Admin sets the folder path to a system folder – for some fucking reason. So we have to go back to a user folder.
$homeFolder = $env:USERPROFILE
cd $homeFolder
$installPath = Join-Path -Path $homeFolder -ChildPath "install.ps1"
if (-not (Test-IsAdmin)) {
    Write-Error "This script is not running with administrative privileges."
    Start-Sleep -Seconds 3
    exit 1  # Exit the script with a non-zero exit code to indicate failure
} else {
    Write-Output "This script is running with administrative privileges."
}


#Execute Functions here
disable_bitlocker
set_up_accounts
install_programms
chrissi
set_up_resets


Write-Output "Changing execution Policy back"
Write-Output "Finished Install Script for Windows"
Set-ExecutionPolicy -ExecutionPolicy AllSigned
