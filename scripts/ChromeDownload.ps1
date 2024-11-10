# Downloads chrome if it doesn't exist on the computer already
Write-Output "Setting local path for chrome"
$chromePath = "C:\Program Files\Google\Chrome"

# Tests the path and if chrome doesn't exist it will install chrome
If(!(test-path $chromePath))
{
    $LocalTempDir = $env:TEMP; 
    $ChromeInstaller = "ChromeInstaller.exe"; 
    winget install -e --id Google.Chrome
    Install-Module -Name Microsoft.WinGet.Client
    $Process2Monitor =  "ChromeInstaller"; 
    Do { $ProcessesFound = Get-Process | Where-Object{$Process2Monitor -contains $_.Name} | Select-Object -ExpandProperty Name; 
    If ($ProcessesFound) { "Still running: $($ProcessesFound -join ', ')" | Write-Host; Start-Sleep -Seconds 10 } 
    else { Remove-Item "$LocalTempDir\$ChromeInstaller" -ErrorAction SilentlyContinue -Verbose } } Until (!$ProcessesFound)
}
else {Write-Output "Chrome has already been downloaded"}

# old code temporary here while testing above with winget and install-module
# (new-object System.Net.WebClient).DownloadFile('http://dl.google.com/chrome/install/375.126/chrome_installer.exe', "$LocalTempDir\$ChromeInstaller")
# & "$LocalTempDir\$ChromeInstaller" /silent /install 