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

# Download and install ImportExcel module
Save-Module -Name ImportExcel -Path $scriptDirectory
Install-Module -Name ImportExcel -Force -AllowClobber -Scope CurrentUser


# Import the ImportExcel module
Import-Module ImportExcel

# Define the path to Script2.ps1 relative to the script's directory
$excelFilePath = Join-Path -Path $scriptDirectory -ChildPath "N2G-Users.xlsx"

# Import data from the Excel file
$userList = Import-Excel -Path $excelFilePath

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