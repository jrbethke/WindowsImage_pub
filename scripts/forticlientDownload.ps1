# Downloads forticlient VPN if it doesn't exist on the computer already
Write-Output "Setting local path for the forticlient vpn"
$vpnPath = "C:\Program Files\Fortinet\FortiClient"

# Tests the path and if chrome doesn't exist it will install the forticlient vpn
If(!(test-path $vpnPath))
{
    $LocalTempDir = $env:TEMP; 
    $FortiClientVPNOnlineInstaller = "FortiClientVPNOnlineInstaller.exe"; 
    (new-object System.Net.WebClient).DownloadFile('https://links.fortinet.com/forticlient/win/vpnagent', "$LocalTempDir\$FortiClientVPNOnlineInstaller"); 
    & "$LocalTempDir\$FortiClientVPNOnlineInstaller" /silent /install; 
    $Process2Monitor =  "FortiClientVPNOnlineInstaller"; 
    Do { $ProcessesFound = Get-Process | Where-Object{$Process2Monitor -contains $_.Name} | Select-Object -ExpandProperty Name; 
    If ($ProcessesFound) { "Still running: $($ProcessesFound -join ', ')" | Write-Host; Start-Sleep -Seconds 10 } 
    else { Remove-Item "$LocalTempDir\$FortiClientVPNOnlineInstaller" -ErrorAction SilentlyContinue -Verbose } } Until (!$ProcessesFound)
}
else {Write-Output "ForticlientVPN has already been downloaded"}