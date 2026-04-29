#Install all necessary programms for a pool laptop
function install_programms {
    #Auto install from a config file, which has to be created.
    $filename = "pool.json"
    $poolJsonPath = Join-Path -Path $PWD -ChildPath $filename
    winget settings --enable BypassCertificatePinningForMicrosoftStore
    Invoke-WebRequest https://raw.githubusercontent.com/Eisdaemon/Bwinf-Bewertung/refs/heads/main/Windows/worker/worker.json -OutFile $poolJsonPath
    & ([ScriptBlock]::Create((irm "https://christitus.com/win"))) -Config pool.json -Run
    winget install Romanitho.Winget-AutoUpdate
    Add-Contet -Path "C:\Program Files\Winget-AutoUpdate\config\default_excluded_apps.txt" -Value "Discord.Discord"

}


function harden_windows {
    #Install LibreOffice Group Policies
    Invoke-WebRequest https://raw.githubusercontent.com/somedowntime/libreofficegrouppolicy/refs/heads/master/LibreOffice.admx -OutFile LibreOffice.admx
    Invoke-WebRequest https://raw.githubusercontent.com/somedowntime/libreofficegrouppolicy/refs/heads/master/en-US/LibreOffice.adml -OutFile LibreOffice.adml
    mv LibreOffice.admx C:\Windows\PolicyDefinitions\
    mv LibreOffice.adml C:\Windows\PolicyDefinitions\en-US\
    Write-Host "Configute the Libre Office Group Policies in accordance to the BSI: https://www.allianz-fuer-cybersicherheit.de/SharedDocs/Downloads/Webs/ACS/DE/BSI-CS/BSI-CS_147.pdf?__blob=publicationFile&v=7"


    mkdir "C:\Program Files\Mozilla Firefox\distribution"
    #Download Firefox config and set it up
    Invoke-WebRequest https://raw.githubusercontent.com/Eisdaemon/Bwinf-Bewertung/refs/heads/main/Windows/worker/policies_firefox.json -OutFile "C:\Program Files\Mozilla Firefox\distribution\policies.json"

    #Invoke-WebRequest https://raw.githubusercontent.com/Eisdaemon/Bwinf-Bewertung/refs/heads/main/Windows/worker/policies_thunderbird.json -OutFile "C:\Program Files\Mozilla Firefox\distribution\policies.json"
    $path = 'HKLM:\SOFTWARE\Policies\Adobe\Adobe Acrobar\DC\FeatureLockDown'

    $key = try {
        Get-Item -Path $path -ErrorAction Stop
    }
    catch {
        New-Item -Path $path -Force
    }

    New-ItemProperty -Path $key.PSPath -Name bDisableJavaScript -PropertyType Dword -Value 1

    #Add Worker as Wireguard User without Admin
    reg add HKLM\Software\WireGuard /v LimitedOperatorUI /t REG_DWORD /d 1 /f
    $user_name = Read-Host "Enter the username to add as Network Operator for Wireguard"
    Add-LocalGroupMember -Group "Network Configuration Operators" -Member $user_name -Verbose

}

#Execution as Admin sets the folder path to a system folder – for some fucking reason. So we have to go back to a user folder.
$homeFolder = $env:USERPROFILE
cd $homeFolder
install_programms
harden_windows

Write-Output "Finished Install Script for Windows"
Write-Output "Changing execution Policy back"
Set-ExecutionPolicy -ExecutionPolicy AllSigned


