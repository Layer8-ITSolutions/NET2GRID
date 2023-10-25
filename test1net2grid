# Set variables for forest and domain names
$forestName = "NET2GRID.local"
$domainName = "net2grid"

# Set the Directory Services Restore Mode (DSRM) password
$dsrmPassword = ConvertTo-SecureString "DSRM_Password" -AsPlainText -Force

# Promote the server to a Domain Controller and create the forest
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
Install-ADDSForest -DomainName $domainName -DomainNetbiosName $domainName -ForestMode Win2016 -DomainMode Win2016 -InstallDns -Force -SafeModeAdministratorPassword $dsrmPassword

# Import the Active Directory module
Import-Module ActiveDirectory

# Install DNS Server role
Install-WindowsFeature -Name DNS

# Configure static IP address
$IPAddress = "10.0.0.2"
$DnsServerAddress = "127.0.0.1"

Set-DnsClientServerAddress -InterfaceAlias (Get-NetAdapter | Where-Object { $_.Status -eq 'Up' }).InterfaceAlias -ServerAddresses $DnsServerAddress

# Verify DNS configuration
Resolve-DnsName $domainName

# Rename the computer
Rename-Computer -NewName "NET2GRID"

# Create OUs
New-ADOrganizationalUnit -Name "CEO" -Path "DC=net2grid,DC=local"
New-ADOrganizationalUnit -Name "Sales" -Path "DC=net2grid,DC=local"
New-ADOrganizationalUnit -Name "IT" -Path "DC=net2grid,DC=local"
New-ADOrganizationalUnit -Name "Cyber Department" -Path "DC=net2grid,DC=local"
New-ADOrganizationalUnit -Name "Financial" -Path "DC=net2grid,DC=local"
New-ADOrganizationalUnit -Name "HR" -Path "DC=net2grid,DC=local"
New-ADOrganizationalUnit -Name "Markting" -Path "DC=net2grid,DC=local"
# Add more OUs here...

# Define the user information
$userInfo = @(
    @{
        Name = "Pepper Potts"
        Title = "CEO"
        Department = "CEO"
    },
    # Add more user information entries...
)

# Create user accounts based on the provided information
foreach ($user in $userInfo) {
    $Name = $user.Name
    $Title = $user.Title
    $Department = $user.Department
    # Create the user
    New-ADUser -Name $Name -DisplayName $Name -SamAccountName $Name -Title $Title -Department $Department -AccountPassword (ConvertTo-SecureString "ABCdef123" -AsPlainText -Force) -Enabled $true
}
