# Install DNS Server role
Install-WindowsFeature -Name DNS

# Configure DNS settings
$IPAddress = "10.0.0.2"
$DnsServerAddress = "127.0.0.1"

Set-DnsClientServerAddress -InterfaceAlias (Get-NetAdapter | Where-Object { $_.Status -eq 'Up' }).InterfaceAlias -ServerAddresses $DnsServerAddress

# Configure static IP address
New-NetIPAddress -IPAddress $IPAddress -PrefixLength 24 -InterfaceAlias (Get-NetAdapter | Where-Object { $_.Status -eq 'Up' })

# Verify DNS configuration
Resolve-DnsName $DomainName

# Rename the computer
Rename-Computer -NewName "NET2GRID"

# Install AD-Domain-Services
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools

# Import the Active Directory module
Import-Module ActiveDirectory

# Set variables for forest and domain names
$forestName = "NET2GRID.local"
$domainName = "net2grid"

# Set the Directory Services Restore Mode (DSRM) password
$dsrmPassword = ConvertTo-SecureString "DSRM_Password" -AsPlainText -Force

# Promote the server to a Domain Controller and create the forest
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
Install-ADDSForest -DomainName $domainName -DomainNetbiosName $domainName -ForestMode Win2016 -DomainMode Win2016 -InstallDns -Force -SafeModeAdministratorPassword $dsrmPassword

