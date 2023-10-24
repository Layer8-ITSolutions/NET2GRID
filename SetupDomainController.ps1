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
