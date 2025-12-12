#Install all necessary programms for a pool laptop
function install_programms {
    #Auto install from a config file, which has to be created.
    $filename = "pool.json"
    $poolJsonPath = Join-Path -Path $PWD -ChildPath $filename
    Invoke-WebRequest https://raw.githubusercontent.com/Eisdaemon/Bwinf-Bewertung/refs/heads/main/Windows/pool/pool.json -OutFile $poolJsonPath
    iex "& { $(irm https://christitus.com/win) } -Config pool.json -Run"
    winget install Romanitho.Winget-AutoUpdate
    winget install Microsoft.OpenJDK.17
    winget install -e --id JetBrains.PyCharm.Community
    winget uninstall "windows web experience pack"


    #Install Clang
    winget install -e --id MSYS2.MSYS2
    C:\msys64\msys2_shell.cmd -defterm -no-start -mingw64 -here -c "pacman -Syu"
    C:\msys64\msys2_shell.cmd -defterm -no-start -mingw64 -here -c "pacman -S mingw-w64-x86_64-clang mingw-w64-x86_64-clang-tools-extra"
    C:\msys64\msys2_shell.cmd -defterm -no-start -mingw64 -here -c "pacman -S mingw-w64-x86_64-make"
    C:\msys64\msys2_shell.cmd -defterm -no-start -mingw64 -here -c "pacman -S mingw-w64-x86_64-gdb"

    Set-PathVariable AddPath 'C:\msys64\mingw64\bin'

}





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

function Set_UpBewertung {

    $filename = "WiFi-bewertung.txt"
    $WifiPathPath = Join-Path -Path $PWD -ChildPath $filename
    Invoke-WebRequest https://raw.githubusercontent.com/Eisdaemon/Bwinf-Bewertung/refs/heads/main/Windows/pool/WiFi-bewertung.txt -OutFile $WifiPathPath

    $BewertungPass  = Read-Host -Prompt "Enter the Password for the bewertungs wlan"
    $find = '				<keyMaterial>PLACEHOLDER</keyMaterial>'
    $replace = $find.Replace('PLACEHOLDER', $BewertungPass)

    (Get-Content $WifiPathPath).replace($find, $replace) | Set-Content $WifiPathPath

}

function user_setup {
    #Because why would it be easily possible to install packages system wide...
    icacls "C:\Users\SysOperator\AppData\Local\Microsoft\WindowsApps\winget.exe" /grant girlsuser:RX
    runas /user:girlsuser "C:\Users\SysOperator\AppData\Local\Microsoft\WindowsApps\winget.exe install Anaconda.Anaconda3"
    runas /user:girlsuser "C:\Users\SysOperator\AppData\Local\Microsoft\WindowsApps\winget.exe install Microsoft.VisualStudioCode"
    runas /user:girlsuser "C:\Users\SysOperator\AppData\Local\Microsoft\WindowsApps\winget.exe install Spyder.Spyder"
    runas /user:girlsuser "C:\Users\girlsuser\AppData\Local\Programs\Microsoft VS Code\bin\code.cmd --install-extension ms-vscode.cpptools"
    runas /user:girlsuser "C:\Users\girlsuser\AppData\Local\Programs\Microsoft VS Code\bin\code.cmd --install-extension Oracle.oracle-java"
    runas /user:girlsuser "C:\Users\girlsuser\AppData\Local\Programs\Microsoft VS Code\bin\code.cmd --install-extension ms-python.python"
    icacls "C:\Users\SysOperator\AppData\Local\Microsoft\WindowsApps\winget.exe" /remove girlsuser

    icacls "C:\Users\SysOperator\AppData\Local\Microsoft\WindowsApps\winget.exe" /grant anderes:RX
    runas /user:anderes "C:\Users\SysOperator\AppData\Local\Microsoft\WindowsApps\winget.exe install Microsoft.VisualStudioCode"
    runas /user:anderes "C:\Users\girlsuser\AppData\Local\Programs\Microsoft VS Code\bin\code.cmd --install-extension ms-vscode.cpptools"
    runas /user:anderes "C:\Users\girlsuser\AppData\Local\Programs\Microsoft VS Code\bin\code.cmd --install-extension Oracle.oracle-java"
    runas /user:anderes "C:\Users\girlsuser\AppData\Local\Programs\Microsoft VS Code\bin\code.cmd --install-extension ms-python.python"
    icacls "C:\Users\SysOperator\AppData\Local\Microsoft\WindowsApps\winget.exe" /remove anderes


    icacls "C:\Users\SysOperator\AppData\Local\Microsoft\WindowsApps\winget.exe" /grant bewertung:RX
    runas /user:bewertung "C:\Users\SysOperator\AppData\Local\Microsoft\WindowsApps\winget.exe install Microsoft.VisualStudioCode"
    runas /user:bewertung "C:\Users\girlsuser\AppData\Local\Programs\Microsoft VS Code\bin\code.cmd --install-extension ms-vscode.cpptools"
    runas /user:bewertung "C:\Users\girlsuser\AppData\Local\Programs\Microsoft VS Code\bin\code.cmd --install-extension Oracle.oracle-java"
    runas /user:bewertung "C:\Users\girlsuser\AppData\Local\Programs\Microsoft VS Code\bin\code.cmd --install-extension ms-python.python"
    icacls "C:\Users\SysOperator\AppData\Local\Microsoft\WindowsApps\winget.exe" /remove bewertung

}

harden_windows {
    #Install LibreOffice Group Policies
    Invoke-WebRequest https://raw.githubusercontent.com/somedowntime/libreofficegrouppolicy/refs/heads/master/LibreOffice.admx -OutFile LibreOffice.admx
    mv LibreOffice.admx C:\Windows\PolicyDefintions\
    Invoke-WebRequest https://raw.githubusercontent.com/somedowntime/libreofficegrouppolicy/refs/heads/master/en-US/LibreOffice.adml -OutFile LibreOffice.adml
    mv LibreOffice.adml C:\Windows\PolicyDefintions\en-US\
    Write-Host "Configute the Libre Office Group Policies in accordance to the BSI: https://www.allianz-fuer-cybersicherheit.de/SharedDocs/Downloads/Webs/ACS/DE/BSI-CS/BSI-CS_147.pdf?__blob=publicationFile&v=7"


    mkdir "C:\Program Files\Mozilla Firefox\distribution"
    #Download Firefox config and set it up
    Invoke-WebRequest https://raw.githubusercontent.com/Eisdaemon/Bwinf-Bewertung/refs/heads/main/Windows/pool/policies.json -OutFile "C:\Program Files\Mozilla Firefox\distribution\policies.json"

}

#Execution as Admin sets the folder path to a system folder – for some fucking reason. So we have to go back to a user folder.
$homeFolder = $env:USERPROFILE
cd $homeFolder
Set_UpBewertung
install_programms
user_setup
harden_windows

Write-Output "Finished Install Script for Windows"
Write-Output "Changing execution Policy back"
Set-ExecutionPolicy -ExecutionPolicy AllSigned


