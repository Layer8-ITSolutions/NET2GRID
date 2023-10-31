# Set variables for forest and domain names
$forestName = "NET2GRID.local"
$domainName = "corp.net2grid.com"
$domainNBName = "net2grid"

# Set the Directory Services Restore Mode (DSRM) password
$dsrmPassword = ConvertTo-SecureString "DSRM_Password" -AsPlainText -Force

# Get the directory of the currently running script
$scriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Definition

# Define the path to Script2 relative to the script's directory
$script2Path = Join-Path -Path $scriptDirectory -ChildPath "SetupOU-UsersCSV.ps1"

# Define the trigger to start the task at logon
$trigger = New-ScheduledTaskTrigger -AtLogOn -User "Username"

# Define the name for the scheduled task
$taskName = "RunSetupOU-Users"

# Create the scheduled task
schtasks /Create /TN $taskName /SC ONSTART /TR "powershell.exe -ExecutionPolicy Bypass -File $script2Path" /RU "NT AUTHORITY\SYSTEM"

# Run the scheduled task immediately
schtasks /Run /TN $taskName

# Promote the server to a Domain Controller and create the forest
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
Install-ADDSForest -DomainName $domainName -DomainNetbiosName $domainNBName -ForestMode Win2012 -DomainMode Win2012 -InstallDns -Force -SafeModeAdministratorPassword $dsrmPassword

# Import the Active Directory module
Import-Module ActiveDirectory

# Install DNS Server role
Install-WindowsFeature -Name DNS

# Configure DNS settings
$CurrentIPConfig = Get-NetIPAddress -InterfaceAlias $InterfaceAlias
$DnsServerAddress = "127.0.0.1"

# Find the network adapter with a status of 'Up'
$NetworkAdapter = Get-NetAdapter | Where-Object { $_.Status -eq 'Up' }

# Check if a network adapter is found
if ($NetworkAdapter) {
    # Use the alias of the network adapter
    $InterfaceAlias = $NetworkAdapter.InterfaceAlias

    # Configure the static IP address
    New-NetIPAddress -IPAddress $CurrentIPConfig -PrefixLength $PrefixLength -InterfaceAlias $InterfaceAlias

} else {
    Write-Host "No network adapter with status 'Up' found."
}

Set-DnsClientServerAddress -InterfaceAlias $InterfaceAlias -ServerAddresses $DnsServerAddress

# Verify DNS configuration
Resolve-DnsName $domainName

Write-Host "Configuration completed. System will now restart."