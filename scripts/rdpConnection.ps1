<#
.SYNOPSIS
    Creates an RDP connection shortcut on the Public Desktop for all users based on the passed in parameters: full address and username.
    
.DESCRIPTION
    This script generates an RDP shortcut (.rdp file) with the provided full address (IP or hostname) and username, 
    then creates a shortcut on the Public Desktop for all users. The shortcut will open an RDP session to the specified server address.
    
    The script takes two parameters: 
    - `$address`: The IP or hostname of the RDP server.
    - `$username`: The username for the RDP connection.
    
    If no values are passed, the script will use blank defaults and prompt the user to provide values interactively.

.PARAMETER $address
    The full address (IP or hostname) of the RDP server to connect to. If not provided, the script will prompt for the address.

.PARAMETER $username
    The username to use for the RDP connection. If not provided, the script will prompt for the username.

.EXAMPLE
    .\rdpConnection.ps1 -address "192.168.1.100" -username "Administrator"
    This will create an RDP shortcut for the server "192.168.1.100" using the "Administrator" username and place it on the Public Desktop.

.NOTES
    Author        : Jesse Bethke
    Version       : 1.1
    Date Created  : 2024-11-8
    Purpose       : To create an RDP connection shortcut on the Public Desktop for all users.
    Prerequisites : None. Requires PowerShell and administrative privileges to write to the Public Desktop directory.
#>

param (
    [string]$address = "",    # The full address (IP or hostname) of the RDP server
    [string]$username = ""    # The username for the RDP connection
)

# Define the RDP file content with placeholders
$rdpContent = @"
screen mode id:i:2
use multimon:i:1
desktopwidth:i:800
desktopheight:i:600
session bpp:i:32
winposstr:s:0,3,0,0,800,600
compression:i:1
keyboardhook:i:2
audiocapturemode:i:0
videoplaybackmode:i:1
connection type:i:7
networkautodetect:i:1
bandwidthautodetect:i:1
displayconnectionbar:i:1
enableworkspacereconnect:i:0
disable wallpaper:i:0
allow font smoothing:i:0
allow desktop composition:i:0
disable full window drag:i:1
disable menu anims:i:1
disable themes:i:0
disable cursor setting:i:0
bitmapcachepersistenable:i:1
full address:s:$address
username:s:$username
audiomode:i:0
redirectprinters:i:1
redirectlocation:i:0
redirectcomports:i:0
redirectsmartcards:i:1
redirectwebauthn:i:1
redirectclipboard:i:1
redirectposdevices:i:0
autoreconnection enabled:i:1
authentication level:i:2
prompt for credentials:i:0
negotiate security layer:i:1
remoteapplicationmode:i:0
alternate shell:s:
shell working directory:s:
gatewayhostname:s:
gatewayusagemethod:i:4
gatewaycredentialssource:i:4
gatewayprofileusagemethod:i:0
promptcredentialonce:i:0
gatewaybrokeringtype:i:0
use redirection server name:i:0
rdgiskdcproxy:i:0
kdcproxyname:s:
enablerdsaadauth:i:0
"@

# Path to the Public Desktop for all users
$publicDesktopPath = "C:\Users\Public\Desktop"

# Define the shortcut file name
$shortcutName = "Server Login.rdp"

# Create the RDP file in the Public Desktop directory
$rdpFilePath = Join-Path -Path $publicDesktopPath -ChildPath $shortcutName

try {
    # Write the RDP content to the .rdp file
    $rdpContent | Set-Content -Path $rdpFilePath -Force
    Write-Host "RDP connection shortcut created on the Public Desktop: $rdpFilePath" -ForegroundColor Green
}
catch {
    Write-Host "Error: Failed to create the RDP shortcut. Ensure you have proper permissions to write to the Public Desktop." -ForegroundColor Red
}
