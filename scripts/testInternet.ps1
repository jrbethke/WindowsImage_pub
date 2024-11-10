# Adds a wif-fi network as known network

# Get the available Wi-fi interface
$wifi = Get-NetAdapter | Where-Object { $_.Name -like "*Wi-Fi*" }
$String = $wifi.name
Write-Output "Interface to be selected: $wifi"

# Get all XML files in the current directory
$xmlFiles = Get-ChildItem *.xml
Write-Output "Looking for Wi-Fi profiles in $($xmlFiles.Count) files."
# Attempt to add the Wi-Fi profile to known networks
foreach ($file in $xmlFiles) {
    Try {
        Write-Output "Trying to add the Wi-Fi profile from $($file.FullName)"
        netsh wlan add profile filename="$($file.FullName)" interface="$String" user=current
    }
    # Catch block executed if there's an error adding the Wi-Fi profile
    Catch {
        Write-Output "Error adding Wi-Fi profile from $($file.FullName): $_"
    }
}

# pauses script to allow wi-fi to connect
Start-Sleep -Seconds 10

# Check if the computer has internet connectivity by pinging google.com
try {
    $bConnected = Test-Connection -ComputerName google.com
    if ($bConnected) {
        Write-Host "Success, you are connected" -ForegroundColor Green
    }
    else {Write-Host "BOOOOO" -ForegroundColor Red}
}
catch {
    Write-Host "Check the wi-fi connection" -ForegroundColor Red
}
Write-Output "**Done**"
