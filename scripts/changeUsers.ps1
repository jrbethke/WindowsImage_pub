<#
.SYNOPSIS
    Checks if a local user account exists, and prompts the user to either delete, demote, or create the account based on the input.

.DESCRIPTION
    This script performs various actions related to a local user account, such as:
    - Checking if a specified user exists on the local machine.
    - If the user exists, it provides options to:
        - Delete the user account.
        - Delete the user profile associated with the account.
        - Demote the user from the "Administrators" group.
    - If the user does not exist, it gives the option to create a new local user account without a password.

.PARAMETER None
    This script does not take any parameters. The user is prompted for input to decide the actions to take.

.EXAMPLE
    .\changeUsers.ps1
    This command will run the script, which checks if the specified user exists and prompts the user to either delete, demote, or create the account.

.NOTES
    File Name      : changeUsers.ps1
    Author         : Jesse Bethke
    Version        : 1.1
    Date Created   : 11/8/2024
    Purpose        : To manage local user accounts (create, delete, demote).
    Prerequisites  : Run as Administrator to ensure sufficient privileges to modify user accounts and profiles.
    Dependencies   : Requires the Get-LocalUser, Remove-LocalUser, New-LocalUser, and other PowerShell cmdlets to interact with local user accounts.
#>

# Define the username to check
$user = "user"

# Check if the user account exists
$userExists = Get-LocalUser -Name $user -ErrorAction SilentlyContinue

# Initialize variables for default
$deleteHost = "no"
$deleteProfile = "no"
$check = "no"

# Prompt to check if a user should be created if it does not exist
$check = Read-Host -Prompt "If $user doesn't exist, do you want to create it? [yes] or [no] default is no"

# Prompt to confirm deletion of account or files if the user exists
$deleteHost = Read-Host -Prompt "If user exists, do you want to delete the account? [yes] or [no] default is no"
$deleteProfile = Read-Host -Prompt "Delete the files too? [yes] or [no] default is no"

# Handle the case where the user exists
if ($userExists) {
    # If the user wants to delete the existing user
    if ($deleteHost -like "yes" -or $deleteHost -like "y") {
        # Delete the user account
        Remove-LocalUser -Name $user
        Write-Host "User '$user' has been deleted."
        return
    }
    
    if ($deleteProfile -like "yes" -or $deleteProfile -like "y") {
        # Delete the user profile associated with the account
        $userprofile = Get-CimInstance -Class Win32_UserProfile | Where-Object { $_.LocalPath -like "*$user" }
        $userprofile | Remove-CimInstance
        Write-Host "User profile for '$user' has been deleted."
    }

    # If not deleting, demote the user from the Administrators group
    Remove-LocalGroupMember -Group "Administrators" -Member $user
    Write-Host "User '$user' has been demoted."

} else {
    # Handle the case where the user does not exist
    if ($check -like "yes" -or $check -like "y") {
        # Create the user with no password
        New-LocalUser -Name $user -NoPassword
        Write-Host "User '$user' has been created with no password."
    } else {
        Write-Host "No user exists, and no account will be created."
    }
}
