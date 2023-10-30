# Define the DNS server IP addresses you want to use
$dnsServerAddresses = "192.168.10.12" # DNS Address from Server

# Set the DNS server addresses on all network adapters
Get-NetAdapter | ForEach-Object {
    Set-DnsClientServerAddress -InterfaceAlias $_.InterfaceAlias -ServerAddresses $dnsServerAddresses
}

# Define the domain name and the credentials of an account
$domainName = "corp.net2grid.com"
$domainCredential = Get-Credential

# Join the computer to the domain
Add-Computer -DomainName $domainName -Credential $domainCredential -Restart