<#
.SYNOPSIS
    Joins a computer to a specified domain and places it into the correct Organizational Unit (OU).

.DESCRIPTION
    This script adds the local computer to a specified Active Directory (AD) domain using provided credentials and places it in the specified Organizational Unit (OU).
    
    The script prompts the user to enter the necessary parameters, and it can also be run with parameters directly to automate the process.

.PARAMETER DomainName
    The domain name that the computer will join (e.g., 'ad.domain.com').

.PARAMETER OUPath
    The Organizational Unit (OU) path where the computer will be added (e.g., 'OU=Computers,DC=ad,DC=domain,DC=com').

.PARAMETER Credential
    The credentials for a domain account with sufficient permissions to join the computer to the domain.
    This should be entered as a PSCredential object (e.g., using `Get-Credential` or directly with the `username` and `password`).

.EXAMPLE
    .\DomainJoin.ps1 -DomainName 'ad.domain.com' -OUPath 'OU=Computers,DC=ad,DC=domain,DC=com' -Credential (Get-Credential)

    This command joins the computer to the 'ad.domain.com' domain, placing it in the 'Computers' OU and using the provided credentials.

.NOTES
    File Name      : DomainJoin.ps1
    Author         : Jesse Bethke
    Version        : 1.1
    Date Created   : 2024-11-08
    Purpose        : To join the computer to an Active Directory domain and place it in the correct Organizational Unit (OU).
    Prerequisites  : Run as Administrator. Ensure the specified domain and OU path are correct and that valid credentials are provided.
    Dependencies   : Requires Active Directory and the `Add-Computer` cmdlet to function properly.
#>

param (
    [string]$DomainName = 'ad.domain.com',  # Default domain name (change to match your environment)
    [string]$OUPath = 'OU=Computers,DC=ad,DC=domain,DC=com',  # Default OU path (adjust accordingly)
    [pscredential]$Credential  # A PSCredential parameter to store domain admin credentials
)

# Check if credentials were provided, otherwise prompt the user
if (-not $Credential) {
    $Credential = Get-Credential -Message "Please provide domain administrator credentials."
}

# Splat the parameters into the Add-Computer cmdlet
$addComputerSplat = @{
    DomainName = $DomainName
    OUPath = $OUPath
    Credential = $Credential
}

# Join the computer to the domain using splatted parameters
Add-Computer @addComputerSplat
