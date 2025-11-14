
#Bitlocker behaves badly on dual boot systems for the pool laptops
function disable_bitlocker {

}


#Install all necessary programms for a pool laptop
function install_programms {
    #Auto install from a config file, which has to be created.
    $filename = "pool.json"
    $poolJsonPath = Join-Path -Path $PWD -ChildPath $filename
    Invoke-WebRequest https://raw.githubusercontent.com/Eisdaemon/Bwinf-Bewertung/refs/heads/main/Windows/pool/pool.json -OutFile $poolJsonPath
    iex "& { $(irm https://christitus.com/win) } -Config pool.json -Run"
    winget install Romanitho.Winget-AutoUpdate
    winget install Microsoft.OpenJDK.17
    #Install Clang
    winget install -e --id MSYS2.MSYS2
    C:\msys64\msys2_shell.cmd -defterm -no-start -mingw64 -here -c "pacman -Syu"
    C:\msys64\msys2_shell.cmd -defterm -no-start -mingw64 -here -c "pacman -S mingw-w64-x86_64-clang mingw-w64-x86_64-clang-tools-extra"
    C:\msys64\msys2_shell.cmd -defterm -no-start -mingw64 -here -c "pacman -S mingw-w64-x86_64-make"
    C:\msys64\msys2_shell.cmd -defterm -no-start -mingw64 -here -c "pacman -S mingw-w64-x86_64-gdb"

    Set-PathVariable AddPath 'C:\msys64\mingw64\bin'

    #Because why would it be easily possible to install packages system wide...
    icacls "C:\Users\SysOperator\AppData\Local\Microsoft\WindowsApps\winget.exe" /grant girlsuser:RX
    runas /user:girluser "C:\Users\SysOperator\AppData\Local\Microsoft\WindowsApps\winget.exe install --scope user Anaconda.Anaconda3"
    runas /user:girluser "C:\Users\SysOperator\AppData\Local\Microsoft\WindowsApps\winget.exe install --scope user Microsoft.VisualStudioCode"
    runas /user:girluser "C:\Users\SysOperator\AppData\Local\Microsoft\WindowsApps\winget.exe install --scope user Microsoft.Spyder.Spyder"
    runas /user:girluser "code --install-extension ms-vscode.cpptools"
    runas /user:girluser "code --install-extension Oracle.oracle-java"
    runas /user:girluser "code --install-extension ms-python.python"
    icacls "C:\Users\SysOperator\AppData\Local\Microsoft\WindowsApps\winget.exe" /remove girlsuser

    icacls "C:\Users\SysOperator\AppData\Local\Microsoft\WindowsApps\winget.exe" /grant anderes:RX
    runas /user:girluser "C:\Users\SysOperator\AppData\Local\Microsoft\WindowsApps\winget.exe install --scope user Microsoft.VisualStudioCode"
    runas /user:girluser "code --install-extension ms-vscode.cpptools"
    runas /user:girluser "code --install-extension Oracle.oracle-java"
    runas /user:girluser "code --install-extension ms-python.python"
    icacls "C:\Users\SysOperator\AppData\Local\Microsoft\WindowsApps\winget.exe" /remove anderes


    icacls "C:\Users\SysOperator\AppData\Local\Microsoft\WindowsApps\winget.exe" /grant bewertung:RX
    runas /user:girluser "C:\Users\SysOperator\AppData\Local\Microsoft\WindowsApps\winget.exe install --scope user Microsoft.VisualStudioCode"
    runas /user:girluser "code --install-extension ms-vscode.cpptools"
    runas /user:girluser "code --install-extension Oracle.oracle-java"
    runas /user:girluser "code --install-extension ms-python.python"
    icacls "C:\Users\SysOperator\AppData\Local\Microsoft\WindowsApps\winget.exe" /remove bewertung
}

#Set Up all necessary accounts.
function set_up_accounts {
  net user /add girlsuser user
  net user /add anderes user
  $BewertungPass  = Read-Host -Prompt "Enter the Password for the bewertungs Account"
  net user /add bewertung $BewertungPass
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
}Set-PathVariable AddPath 'C:\tmp\bin'


function Set-PathVariable {
    param (
        [string]$AddPath,
        [string]$RemovePath
    )
    $regexPaths = @()
    if ($PSBoundParameters.Keys -contains 'AddPath'){
        $regexPaths += [regex]::Escape($AddPath)
    }

    if ($PSBoundParameters.Keys -contains 'RemovePath'){
        $regexPaths += [regex]::Escape($RemovePath)
    }

    $arrPath = $env:Path -split ';'
    foreach ($path in $regexPaths) {
        $arrPath = $arrPath | Where-Object {$_ -notMatch "^$path\\?"}
    }
    $env:Path = ($arrPath + $addPath) -join ';'
}

#Execute Functions here
#disable_bitlocker
set_up_accounts
install_programms
#set_up_resets


Write-Output "Changing execution Policy back"
Write-Output "Finished Install Script for Windows"
Set-ExecutionPolicy -ExecutionPolicy AllSigned
