# 10 minutes interval for AD to be installed
Start-Sleep -Seconds 600

# Set variable Path
$DCPath = "DC=corp,DC=net2grid,DC=com"

# Create OUs
New-ADOrganizationalUnit -Name "Sales" -Path $DCPath
New-ADOrganizationalUnit -Name "Marketing" -Path $DCPath
New-ADOrganizationalUnit -Name "CyberDepartment" -Path $DCPath
New-ADOrganizationalUnit -Name "Financial" -Path $DCPath
New-ADOrganizationalUnit -Name "HR" -Path $DCPath
New-ADOrganizationalUnit -Name "IT" -Path $DCPath
New-ADOrganizationalUnit -Name "CEO" -Path $DCPath

# Get the directory of the currently running script
$scriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Definition

# Define the path to Script2 relative to the script's directory
$csvFilePath = Join-Path -Path $scriptDirectory -ChildPath "N2G-Users.csv"

# Import the CSV data
$userList = Import-Csv -Path $csvFilePath

# Loop through each user and create their AD account
foreach ($user in $userList) {
    $firstName = $user.FirstName
    $lastName = $user.LastName
    $name = "$firstName $lastName"
    $username = $user.Username
    $password = $user.Password
    $department = $user.Department
    $title = $user.Title
    $targetOU = "OU=$department,DC=corp,DC=net2grid,DC=com"
    New-ADUser -GivenName $firstName -Surname $lastName -Name $name -DisplayName $name -SamAccountName $username -Title $title -Department $department -AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) -Enabled $true
    $userObject = Get-ADUser -Filter { SamAccountName -eq $username }
    Move-ADObject -Identity $userObject -TargetPath $targetOU
}