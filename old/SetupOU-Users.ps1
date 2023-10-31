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

# Define the user information
$userInfo = @(
    @{
        FirstName = "Pepper"
        LastName = "Potts"
        Title = "CEO"
        Department = "CEO"
    },
    @{
        FirstName = "Jane"
        LastName = "Foster"
        Title = "Chief Marketing Officer"
        Department = "Marketing"
    },
    @{
        FirstName = "Thor"
        LastName = "Odinson"
        Title = "Sr. Manager, Paid Media"
        Department = "Marketing"
    },
    @{
        FirstName = "Brunnhilde"
        LastName = "Valkyrie"
        Title = "Sr. Manager, SEO"
        Department = "Marketing"
    },
    @{
        FirstName = "Loki"
        LastName = "Laufeyson"
        Title = "Sr. Manager, Communications"
        Department = "Marketing"
    },
    @{
        FirstName = "Philip"
        LastName = "Coulson"
        Title = "Chief Financial Officer"
        Department = "Financial"
    },
    @{
        FirstName = "Peter"
        LastName = "Quill"
        Title = "Senior Auditor"
        Department = "Financial"
    },
    @{
        FirstName = "Yondu"
        LastName = "Udonta"
        Title = "Sr. Accountant"
        Department = "Financial"
    },
    @{
        FirstName = "Rocket"
        LastName = "Racoon"
        Title = "Jr. Accountant"
        Department = "Financial"
    },
    @{
        FirstName = "Iam"
        LastName = "Groot"
        Title = "AP Administrator"
        Department = "Financial"
    },
    @{
        FirstName = "Bruce"
        LastName = "Banner"
        Title = "Exec VP"
        Department = "HR"
    },
    @{
        FirstName = "Nick"
        LastName = "Fury"
        Title = "Director, Talent Acquisition"
        Department = "HR"
    },
    @{
        FirstName = "James"
        LastName = "Rhodes"
        Title = "Training and Development"
        Department = "HR"
    },
    @{
        FirstName = "Tony"
        LastName = "Stark"
        Title = "Chief Information Officer"
        Department = "IT"
    },
    @{
        FirstName = "Hope"
        LastName = "van Dyn"
        Title = "Chief Technology Officer"
        Department = "IT"
    },
    @{
        FirstName = "Hank"
        LastName = "Pim"
        Title = "Senior Engineer"
        Department = "IT"
    },
    @{
        FirstName = "Scott"
        LastName = "Lang"
        Title = "Frontend Developer"
        Department = "IT"
    },
    @{
        FirstName = "Peter"
        LastName = "Parker"
        Title = "Backend Developer"
        Department = "IT"
    },
    @{
        FirstName = "Natasha"
        LastName = "Richardson"
        Title = "Chief Information Security Officer"
        Department = "Cyber Department"
    },
    @{
        FirstName = "Maria"
        LastName = "Hill"
        Title = "Director, Information Security"
        Department = "Cyber Department"
    },
    @{
        FirstName = "Pietro"
        LastName = "Maximoff"
        Title = "Defensive Security Team"
        Department = "Cyber Department"
    },
    @{
        FirstName = "Wanda"
        LastName = "Maximoff"
        Title = "Offensive Security Team"
        Department = "Cyber Department"
    },
    @{
        FirstName = "Happy"
        LastName = "Hogan"
        Title = "Facilities Manager"
        Department = "Cyber Department"
    },
    @{
        FirstName = "Carol"
        LastName = "Danvers"
        Title = "Chief Operations Officer"
        Department = "Sales"
    },
    @{
        FirstName = "Jing"
        LastName = "T'Challa"
        Title = "Divisional VP, Retail West"
        Department = "Sales"
    },
    @{
        FirstName = "Peggy"
        LastName = "Carter"
        Title = "Regional Manager, Washington, Idaho, Montana"
        Department = "Sales"
    },
    @{
        FirstName = "Bucky"
        LastName = "Barnes"
        Title = "Regional Manager, California & Oregon"
        Department = "Sales"
    },
    @{
        FirstName = "Princess"
        LastName = "Shuri"
        Title = "Divisional VP, Retail East"
        Department = "Sales"
    },
    @{
        FirstName = "Steve"
        LastName = "Evans"
        Title = "Regional Manager, New York, New Jersey, Connecticut"
        Department = "Sales"
    },
    @{
        FirstName = "Sam"
        LastName = "Wilson"
        Title = "Regional Manager, Florida, Georgia, Carolinas"
        Department = "Sales"
    }
)

foreach ($user in $userInfo) {
    $firstName = $user.FirstName
    $lastName = $user.LastName
    $name = "$firstName $lastName"
    $title = $user.Title
    $department = $user.Department
    $targetOU = "OU=$department,DC=corp,DC=net2grid,DC=com"
    New-ADUser -GivenName $firstName -Surname $lastName -Name $name -DisplayName $name -SamAccountName $name -Title $title -Department $department -AccountPassword (ConvertTo-SecureString "ABCdef123" -AsPlainText -Force) -Enabled $true
    $userObject = Get-ADUser -Filter { SamAccountName -eq $name }
    Move-ADObject -Identity $userObject -TargetPath $targetOU
}