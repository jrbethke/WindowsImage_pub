<#
.SYNOPSIS
    Renames the computer if a new name is provided and the user confirms the change.

.DESCRIPTION
    This script checks if the user wants to rename the computer. It will prompt for a new name and confirm the change 
    before renaming the computer. It can also be run non-interactively by passing parameters directly.

.PARAMETER CurrentComputerName
    The current name of the computer. This is typically retrieved automatically from the environment, but can be overridden if needed.

.PARAMETER NewComputerName
    The new name for the computer. If this is provided, the computer will be renamed to this name.

.PARAMETER ChangeName
    A boolean value that determines whether the computer name should be changed. 
    Default is 'yes' to change the name.

.EXAMPLE
    .\nameComputer.ps1 -ChangeName 'yes' -NewComputerName 'NewPCName'
    This will rename the computer to 'NewPCName' if the user confirms.

.NOTES
    File Name      : nameComputer.ps1
    Author         : Jesse Bethke
    Version        : 1.1
    Date Created   : 2024-11-08
    Purpose        : To rename the local computer to a new name based on user input.
    Prerequisites  : Run as Administrator. Ensure the new name does not conflict with an existing computer name.
    Dependencies   : None
#>

param (
    [string]$CurrentComputerName = $env:COMPUTERNAME,  # The current name of the computer (default is the existing computer name)
    [string]$NewComputerName,  # The new name to set for the computer
    [string]$ChangeName = 'no'  # Default action is 'no', change it to 'yes' to rename
)

# Display current computer name
Write-Output "Current computer name is: $CurrentComputerName"

# Prompt for renaming only if 'ChangeName' is 'yes'
if ($ChangeName -like "yes") {
    if (-not $NewComputerName) {
        Write-Host "Please specify a new computer name using the -NewComputerName parameter."
        return
    }

    $bIsGood = $false
    $check = "yes"  # default to yes if the user accepts the name
    
    Write-Host "You are about to rename the computer to: $NewComputerName"
    
    # Confirm the new computer name
    do {
        $check = Read-Host -Prompt "Is this okay to rename the computer to '$NewComputerName'? [yes] or [no] default is yes"
        
        if ($check -like "yes" -or $check -like "y" -or $check -like "") {
            $bIsGood = $true
        }
    } while (-not $bIsGood)

    # Rename the computer
    Rename-Computer -NewName $NewComputerName -Force

    Write-Output "Computer has been renamed to $NewComputerName."
} else {
    Write-Output "No change to computer name."
}

Write-Output "**Done**"
