# Set variables for forest and domain names
$forestName = "NET2GRID.local"
$domainName = "corp.net2grid.com"
$domainNBName = "net2grid"

# Set the Directory Services Restore Mode (DSRM) password
$dsrmPassword = ConvertTo-SecureString "DSRM_Password" -AsPlainText -Force

# Promote the server to a Domain Controller and create the forest
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
Install-ADDSForest -DomainName $domainName -DomainNetbiosName $domainNBName -ForestMode Win2012 -DomainMode Win2012 -InstallDns -Force -SafeModeAdministratorPassword $dsrmPassword

# Import the Active Directory module
Import-Module ActiveDirectory

# Install DNS Server role
Install-WindowsFeature -Name DNS

# Configure DNS settings
$IPAddress = "10.0.0.2"
$DnsServerAddress = "127.0.0.1"

# Find the network adapter with a status of 'Up'
$NetworkAdapter = Get-NetAdapter | Where-Object { $_.Status -eq 'Up' }

# Check if a network adapter is found
if ($NetworkAdapter) {
    # Use the alias of the network adapter
    $InterfaceAlias = $NetworkAdapter.InterfaceAlias

    # Configure the static IP address
    New-NetIPAddress -IPAddress $IPAddress -PrefixLength $PrefixLength -InterfaceAlias $InterfaceAlias
} else {
    Write-Host "No network adapter with status 'Up' found."
}

Set-DnsClientServerAddress -InterfaceAlias $InterfaceAlias -ServerAddresses $DnsServerAddress

# Verify DNS configuration
Resolve-DnsName $domainName

# Create OUs
New-ADOrganizationalUnit -Name "Sales" -Path "DC=net2grid,DC=local"
New-ADOrganizationalUnit -Name "Marketing" -Path "DC=net2grid,DC=local"
New-ADOrganizationalUnit -Name "CyberDepartment" -Path "DC=net2grid,DC=local"
New-ADOrganizationalUnit -Name "Financial" -Path "DC=net2grid,DC=local"
New-ADOrganizationalUnit -Name "HR" -Path "DC=net2grid,DC=local"
New-ADOrganizationalUnit -Name "IT" -Path "DC=net2grid,DC=local"
New-ADOrganizationalUnit -Name "CEO" -Path "DC=net2grid,DC=local"

# Define the user information
$userInfo = @(
    @{
        Name = "Pepper Potts"
        Title = "CEO"
        Department = "CEO"
    },
    @{
        Name = "Jane Foster"
        Title = "Chief Marketing Officer"
        Department = "Marketing"
    },
    @{
        Name = "Thor Odinson"
        Title = "Sr. Manager, Paid Media"
        Department = "Marketing"
    },
    @{
        Name = "Brunnhilde Valkyrie"
        Title = "Sr. Manager, SEO"
        Department = "Marketing"
    },
    @{
        Name = "Loki Laufeyson"
        Title = "Sr. Manager, Communications"
        Department = "Marketing"
    },
    @{
        Name = "Philip Coulson"
        Title = "Chief Financial Officer"
        Department = "Financial"
    },
    @{
        Name = "Peter Quill"
        Title = "Senior Auditor"
        Department = "Financial"
    },
    @{
        Name = "Yondu Udonta"
        Title = "Sr. Accountant"
        Department = "Financial"
    },
    @{
        Name = "Rocket Racoon"
        Title = "Jr. Accountant"
        Department = "Financial"
    },
    @{
        Name = "Iam Groot"
        Title = "AP Administrator"
        Department = "Financial"
    },
    @{
        Name = "Bruce Banner"
        Title = "Exec VP"
        Department = "HR"
    },
    @{
        Name = "Nick Fury"
        Title = "Director, Talent Acquisition"
        Department = "HR"
    },
    @{
        Name = "James Rhodes"
        Title = "Training and Development"
        Department = "HR"
    },
    @{
        Name = "Tony Stark"
        Title = "Chief Information Officer"
        Department = "IT"
    },
    @{
        Name = "Hope van Dyn"
        Title = "Chief Technology Officer"
        Department = "IT"
    },
    @{
        Name = "Hank Pim"
        Title = "Senior Engineer"
        Department = "IT"
    },
    @{
        Name = "Scott Lang"
        Title = "Frontend Developer"
        Department = "IT"
    },
    @{
        Name = "Peter Parker"
        Title = "Backend Developer"
        Department = "IT"
    },
    @{
        Name = "Natasha Richardson"
        Title = "Chief Information Security Officer"
        Department = "Cyber Department"
    },
    @{
        Name = "Maria Hill"
        Title = "Director, Information Security"
        Department = "Cyber Department"
    },
    @{
        Name = "Pietro Maximoff"
        Title = "Defensive Security Team"
        Department = "Cyber Department"
    },
    @{
        Name = "Wanda Maximoff"
        Title = "Offensive Security Team"
        Department = "Cyber Department"
    },
    @{
        Name = "Happy Hogan"
        Title = "Facilities Manager"
        Department = "Cyber Department"
    },
    @{
        Name = "Carol Danvers"
        Title = "Chief Operations Officer"
        Department = "Sales"
    },
    @{
        Name = "Jing T'Challa"
        Title = "Divisional VP, Retail West"
        Department = "Sales"
    },
    @{
        Name = "Peggy Carter"
        Title = "Regional Manager, Washington, Idaho, Montana"
        Department = "Sales"
    },
    @{
        Name = "Bucky Barnes"
        Title = "Regional Manager, California & Oregon"
        Department = "Sales"
    },
    @{
        Name = "Princess Shuri"
        Title = "Divisional VP, Retail East"
        Department = "Sales"
    },
    @{
        Name = "Steve Evans"
        Title = "Regional Manager, New York, New Jersey, Connecticut"
        Department = "Sales"
    },
    @{
        Name = "Sam Wilson"
        Title = "Regional Manager, Florida, Georgia, Carolinas"
        Department = "Sales"
    }
)

# Create user accounts based on the provided information
foreach ($user in $userInfo) {
    $name = $user.Name
    $title = $user.Title
    $department = $user.Department
    # Create the user
    New-ADUser -Name $name -DisplayName $name -SamAccountName $name -Title $title -Department $department -AccountPassword (ConvertTo-SecureString "ABCdef123" -AsPlainText -Force) -Enabled $true
}