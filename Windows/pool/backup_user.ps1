<#
.SYNOPSIS
    Backs up or restores a user's profile folder and registry hive.
.DESCRIPTION
    This script allows you to create a backup of a user's profile folder and registry hive,
    and restore it later. The user account must exist and the SID must not change.
.NOTES
    Run as Administrator.
    The user must be logged off during restore.
    Requires PowerShell 7+ for parallel copying.
#>
param (
    [Parameter(Mandatory=$true)]
    [string]$Username,
    [Parameter(Mandatory=$true)]
    [ValidateSet("Backup", "Restore")]
    [string]$Action
)

# Check if running as admin
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "Please run this script as Administrator."
    exit 1
}

# Get user SID
$user = Get-LocalUser -Name $Username -ErrorAction SilentlyContinue
if (-not $user) {
    Write-Error "User '$Username' not found."
    exit 1
}
$userSID = (Get-WmiObject Win32_UserAccount | Where-Object { $_.Name -eq $Username }).SID
if (-not $userSID) {
    Write-Error "Could not find SID for user '$Username'."
    exit 1
}

# Define paths
$backupRoot = "C:\User\SysOperator"
$backupProfilePath = Join-Path $backupRoot "$Username\$Username_Profile"
$backupRegPath = Join-Path $backupRoot "$Username\$Username_Registry.reg"
$profilePath = "C:\Users\$Username"
$ntuserDatPath = Join-Path $profilePath "NTUSER.DAT"

# Create backup directory if not exists
if (-not (Test-Path $backupRoot)) {
    New-Item -ItemType Directory -Path $backupRoot -Force | Out-Null
}

# Function for parallel file copying
function Copy-FilesParallel {
    param(
        [string]$Source,
        [string]$Destination
    )
    # Create destination directory if it doesn't exist
    if (-not (Test-Path $Destination)) {
        New-Item -ItemType Directory -Path $Destination -Force | Out-Null
    }
    # Get all files and subdirectories
    $files = Get-ChildItem $Source -Recurse -File
    # Copy files in parallel
    $files | ForEach-Object -Parallel {
        $destFile = Join-Path $using:Destination $_.FullName.Substring($using:Source.Length)
        $destDir = Split-Path $destFile -Parent
        if (-not (Test-Path $destDir)) {
            New-Item -ItemType Directory -Path $destDir -Force | Out-Null
        }
        Copy-Item $_.FullName $destFile -Force
    } -ThrottleLimit 10
}

# --- BACKUP ---
if ($Action -eq "Backup") {
    Write-Host "Backing up user '$Username'..."

    # Create user backup directory if not exists
    $userBackupDir = Join-Path $backupRoot $Username
    if (-not (Test-Path $userBackupDir)) {
        New-Item -ItemType Directory -Path $userBackupDir -Force | Out-Null
    }

    # Backup profile folder (parallel)
    if (Test-Path $profilePath) {
        if (Test-Path $backupProfilePath) {
            Remove-Item $backupProfilePath -Recurse -Force
        }
        Copy-FilesParallel -Source $profilePath -Destination $backupProfilePath
        Write-Host "Profile folder backed up to $backupProfilePath"
    } else {
        Write-Error "Profile folder not found: $profilePath"
        exit 1
    }

    # Backup registry hive
    if (Test-Path $ntuserDatPath) {
        reg export "HKEY_USERS\$userSID" $backupRegPath /y
        Write-Host "Registry hive backed up to $backupRegPath"
    } else {
        Write-Error "NTUSER.DAT not found: $ntuserDatPath"
        exit 1
    }

    Write-Host "Backup completed successfully."
}

# --- RESTORE ---
elseif ($Action -eq "Restore") {
    Write-Host "Restoring user '$Username'..."

    # Check if backup exists
    if (-not (Test-Path $backupProfilePath) -or -not (Test-Path $backupRegPath)) {
        Write-Error "Backup not found. Please create a backup first."
        exit 1
    }

    # Delete current profile folder
    if (Test-Path $profilePath) {
        Remove-Item $profilePath -Recurse -Force
    }

    # Restore profile folder (parallel)
    Copy-FilesParallel -Source $backupProfilePath -Destination $profilePath
    Write-Host "Profile folder restored from $backupProfilePath"

    # Set permissions
    $acl = Get-Acl $profilePath
    $accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("$Username","FullControl","ContainerInherit, ObjectInherit","None","Allow")
    $acl.SetAccessRule($accessRule)
    Set-Acl $profilePath $acl
    Write-Host "Permissions set for $Username"

    # Restore registry hive
    reg import $backupRegPath
    Write-Host "Registry hive restored from $backupRegPath"
    Write-Host "Restore completed successfully."
}
