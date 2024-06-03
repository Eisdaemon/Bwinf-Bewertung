$homeFolder = $env:USERPROFILE
Write-Output "The current user's home folder is: $homeFolder"

function Test-IsAdmin {

  $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
  return $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (-not (Test-IsAdmin)) {
    Write-Output "This script is not running with administrative privileges."
    Start-Sleep -Seconds 3
    exit 1  # Exit the script with a non-zero exit code to indicate failure
} else {
    Write-Output "This script is running with administrative privileges."
}
