<#
.SYNOPSIS
    Installs and manages Windows updates using the `PSWindowsUpdate` module in PowerShell.

.DESCRIPTION
    This script updates Windows and installs the necessary modules for managing Windows updates.
    It first ensures that the TLS1.2 protocol is used for secure connections, then installs the 
    `PSWindowsUpdate` module (via NuGet) if it's not already installed, and finally performs 
    Windows updates. The updates are installed silently, and the script does not prompt for a reboot.

    The script includes the following steps:
    1. Ensures TLS1.2 is enabled for secure connections required by the `WindowsUpdate` module.
    2. Installs the latest version of the `NuGet` provider if it's not already installed.
    3. Installs the `PSWindowsUpdate` module from the PowerShell Gallery.
    4. Lists available Windows updates from Microsoft Update.
    5. Installs all available updates without prompting for a reboot.

.PARAMETER None
    This script does not require any parameters. It is designed to run directly as a script 
    to automatically manage Windows updates.

.EXAMPLE
    .\WindowsUpdater.ps1
    This example runs the script, installs necessary modules, checks for available updates, 
    and installs them without requiring a reboot.

.NOTES
    Author: Jesse Bethke
    Version: 1.1
    Date: 2024-11-08
    Prerequisites: The script must be run as an administrator for Windows Update and module installation to succeed.

    ** WARNING **: This script will automatically install Windows updates and may take some time depending on the number of updates. It is recommended to run this script in a controlled environment.

    The script can be modified to install specific updates (e.g., by KB article ID) if needed.
#>

# The following is required by windowsupdate module using TLS1.2 for connection
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Installs PSWindowsUpdated, required for installing windows updates

# Updated so it silently installs Nuget and will start PSwindowsupdate
Write-Output "Adding Windows Update for Powershell"
$nuget = Find-PackageProvider -Name "NuGet" -AllVersions | Sort-Object Version -Descending | Select-Object -First 1
Install-PackageProvider NuGet -RequiredVersion $nuget.Version -Force;
Write-Host "NuGet provider version $($nuget.Version) installed successfully."
Set-PSRepository PSGallery -InstallationPolicy Trusted;
Install-Module PSWindowsUpdate -Repository PSGallery -Scope CurrentUser -Force
Get-Package -Name PSWindowsUpdate

# command to show list of available command lines if wanted
# Get-Command -module PSWindowsUpdate

# List all available windows updates 
# Command for installing specific windows update:
# Get-WindowsUpdate -Install -KBArticleID <Enter ID her>
Write-Output "Looking for updates"
Get-WUList -MicrosoftUpdate

# installs all updates and does not ask for reboot
Write-Output "Installing Windows Updates"
Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -Install -IgnoreReboot
Write-Output "Updates complete"