# Get the directory of the currently running script
$scriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Definition

# Define the path to Script2 relative to the script's directory
$script2Path = Join-Path -Path $scriptDirectory -ChildPath "SetupOU-UsersCSV.ps1"

# Define the name for the scheduled task
$taskName = "RunSetupOU-Users"

# Create the scheduled task with the logon trigger
schtasks /Create /TN $taskName /SC LOGON /TR "powershell.exe -ExecutionPolicy Bypass -File `"$script2Path`"" /RU "NT AUTHORITY\SYSTEM"

# Run the scheduled task immediately
schtasks /Run /TN $taskName