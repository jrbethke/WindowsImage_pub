<#
.SYNOPSIS
    Function to remove applications based on name patterns (both Appx packages and traditional software).
    
.DESCRIPTION
    This script allows the removal of applications either for all users or for a specific user. It handles both modern Appx 
    packages (UWP apps) and traditional software installed via Windows Installer (MSI) or other methods, using WMI for traditional software.
    
    The script takes a name pattern as input and removes applications whose names match that pattern. Wildcards can be used 
    in the pattern for more flexible matching. This function allows you to target applications across the system, or for individual users.

    The removal of Appx packages can be done for either all users or just the current user. For traditional software, WMI queries 
    are used to identify and uninstall software matching the provided pattern.
    
    This function can be especially useful for removing bloatware, unwanted applications, or specific versions of software 
    from a system based on a partial match to the application names.

.PARAMETER Pattern
    The name pattern for the applications to be removed. This supports wildcard characters (`*` and `?`) to allow for broad or specific matching.
    - For example, the pattern `*Adobe*` will match any application containing "Adobe" in its name.
    - The pattern `Photoshop` will match only those applications with "Photoshop" in the name exactly.

.PARAMETER AllUsers
    Optional switch to remove Appx packages for all users. If specified, the script will attempt to remove Appx packages for all users on the system.
    If not specified, only Appx packages for the current user will be removed. This parameter applies to UWP (Universal Windows Platform) apps, 
    which are typically installed per user rather than per machine.

.EXAMPLE
    .\RemoveApplications.ps1 -Pattern "*Adobe*" -AllUsers
    This will remove all Appx packages related to Adobe (such as Adobe Reader, Adobe Acrobat, etc.) for **all users** on the system.

.EXAMPLE
    .\RemoveApplications.ps1 -Pattern "Photoshop"
    This will remove the Adobe Photoshop application for the **current user** (if it's an Appx package).

.EXAMPLE
    .\RemoveApplications.ps1 -Pattern "*Microsoft Office*" -AllUsers
    This will remove all Appx packages related to Microsoft Office for **all users** on the system.

.NOTES
    Author        : Jesse Bethke
    Version       : 1.1
    Date Created  : 2024-11-08
    Purpose       : To remove applications (Appx and traditional software) from a system based on name patterns.
    Prerequisites : Requires administrative privileges to remove software via WMI and to uninstall Appx packages for all users.
    Dependencies  : Requires PowerShell cmdlets for Appx package management (`Get-AppxPackage`, `Remove-AppxPackage`) and WMI (`Get-WmiObject`, `Uninstall`).
    
    Known Limitations:
        - The script may not remove all system-protected apps or applications that are running.
        - For traditional software, the script assumes that the applications are registered in WMI and uninstallable through the `Uninstall` method.

    Usage Notes:
        - When removing Appx packages for all users, you may need to run the script with elevated privileges (Run as Administrator).
        - The `AllUsers` switch affects only Appx packages and does not apply to traditional software.

#>


function Remove-PackageByPattern {
    param (
        [string]$Pattern,
        [switch]$AllUsers
    )

    # Remove Appx packages
    Write-Output "Removing Appx package(s) matching pattern: $Pattern"
    $packages = if ($AllUsers) {
        Get-AppxPackage -AllUsers -Name $Pattern
    } else {
        Get-AppxPackage -Name $Pattern
    }

    try {
        foreach ($package in $packages) {
            Write-Output "Removing Appx package: $($package.PackageFullName)"
            if ($AllUsers) {
                Remove-AppxPackage -Package $package.PackageFullName -AllUsers
                Write-Output "The following app was removed for all users: $($package.PackageFullName)"
            } else {
                Remove-AppxPackage -Package $package.PackageFullName
                Write-Output "The following app was removed for the current user: $($package.PackageFullName)"
            }
        }
    }
    catch {
        Write-Output "Error removing Appx packages: $_"
    }

    # Remove software via WMI (Win32_Product)
    Write-Output "Removing software matching pattern in WMI: $Pattern"
    try {
        $wmiApp = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -match $Pattern }
        if ($wmiApp) {
            foreach ($app in $wmiApp) {
                Write-Output "Removing WMI application: $($app.Name)"
                try {
                    $app.Uninstall()
                    Write-Output "Successfully removed: $($app.Name)"
                }
                catch {
                    Write-Output "Error uninstalling WMI application: $($app.Name) - $_"
                }
            }
        } else {
            Write-Output "No WMI application found matching the pattern: $Pattern"
        }
    }
    catch {
        Write-Output "Error querying WMI: $_"
    }
}

# Define patterns for the apps to be removed
$patterns = @{
    "CutePDF Writer"  = "*CutePDF* *Writer*"
    "Adobe"           = "*Adobe*"
    "OpenOffice"      = "*OpenOffice*"
    "Xbox Game Bar"   = "*Xbox* *Game*"
    "Xbox Live"       = "*Xbox* *Live*"
    "Zoom"            = "*Zoom*"
    "McAfee"          = "*McAfee*"
    "Microsoftbuy"    = "*StorePurchaseApp*"
    "BingNews"        = "*bingNews*"
    "Bing Weather"    = "*BingWeather*"
    "Microsoft Store" = "*WindowsStore*"
    "Your Phone"      = "*YourPhone*"
    "Gaming"          = "*Gaming*"
    "Solitaire"       = "*Solitaire*"
    "Xbox Gaming Overlay" = "*XboxGamingOverlay*"
    "Games"           = "*Microsoft.*Games*"
    "Xbox Speech2text" = "*SpeechToText*"
}

# Remove packages for all users
foreach ($app in $patterns.Values) {
    Remove-PackageByPattern  -Pattern $app -AllUsers
}

Write-Output "**Done**"
