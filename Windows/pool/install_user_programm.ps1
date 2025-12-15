$taskName = "WingetInstallVSCodeAnderes"
$wingetPath = "C:\Users\SysOperator\AppData\Local\Microsoft\WindowsApps\winget.exe"
$arguments = "install Microsoft.VisualStudioCode3"
$username = "anderes"
$password = Read-Host "Enter password for $username" -AsSecureString
$credential = New-Object System.Management.Automation.PSCredential($username, $password)

# Create the action
$action = New-ScheduledTaskAction -Execute $wingetPath -Argument $arguments

# Create the principal with the correct logon type
$principal = New-ScheduledTaskPrincipal -UserId "$env:COMPUTERNAME\$username" -LogonType Password -RunLevel Highest

# Register the task with the credentials
Register-ScheduledTask -TaskName $taskName -Action $action -Principal $principal -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable -DontStopOnIdleEnd) -Force

# Run the task immediately
Start-ScheduledTask -TaskName $taskName
