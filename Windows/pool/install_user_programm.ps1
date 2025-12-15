$taskName = "WingetInstallVSCodeAnderes"
$wingetPath = "C:\Users\SysOperator\AppData\Local\Microsoft\WindowsApps\winget.exe"
$arguments = "install Microsoft.VisualStudioCode3"
$username = "anderes"

# Create the scheduled task
$action = New-ScheduledTaskAction -Execute $wingetPath -Argument $arguments
$settings = New-ScheduledTaskSettingsSet -StartWhenAvailable -DontStopOnIdleEnd
$principal = New-ScheduledTaskPrincipal -UserId "$env:COMPUTERNAME\$username" -LogonType Password -RunLevel Highest
$task = Register-ScheduledTask -TaskName $taskName -Action $action -Principal $principal -Settings $settings -Force

# Run the task immediately
Start-ScheduledTask -TaskName $taskName
