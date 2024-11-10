# Windows Imaging script to prepare laptops/workstations
# Created 9/11/2024
# Author Jesse Bethke
# Setting the execution policy to allow scripts to run
Set-ExecutionPolicy RemoteSigned

$path = $PSScriptRoot+"\scripts\"
# array of scripts to run in order
$order = ("syncDateTime.ps1",
    "StartScript.ps1",
    "nameComputer.ps1",
    "ChangeUsers.ps1",
    "WindowsUpdater.ps1",
    "RemoveApplications.ps1",
    "ChromeDownload.ps1",
    "softwareInstall.ps1",
    "CreateShortcuts.ps1",
    "EndScript.ps1")

# executing the scripts
foreach ($ps in $order){
    Try{
        Write-Host "Executing $ps"
        $ps = $path + $ps
        . $ps
    }
    Catch{
        Write-Host "Error with $ps, check if it exists"
    }
}

Write-Host "Restarting the computer for the changes to take effect" -ForegroundColor Yellow
shutdown /r

