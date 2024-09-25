<#
.SYNOPSIS
    Tracks RDP sessions on a remote server and logs details such as user, session start time, session end time, and IP address.

.DESCRIPTION
    This script retrieves RDP session information from a specified server, including session start time, end time, and user information.
    It saves the session details into a CSV file for auditing purposes.

.PARAMETER server
    The name of the remote server you want to monitor.

.EXAMPLE
    .\RDPSessionTracker.ps1 -server "RemoteServer01"

    This command will retrieve RDP session data from "RemoteServer01" and log it into a CSV file.

.NOTES
    Author: Mr. Lohumi
    Version: 1.1
    License: MIT License
#>

param (
    [string]$server
)

# If no server name is provided, prompt the user for input
if (-not $server) {
    $server = Read-Host "Please enter the remote server name"
}

# Define the output CSV file path
$logFile = "C:\RDPSessionLogs.csv"

# Get current RDP session details
$rdpSessions = Get-WmiObject -Class Win32_LogonSession -ComputerName $server | Where-Object { $_.LogonType -eq 10 }

# Loop through each RDP session and gather details
foreach ($session in $rdpSessions) {
    $sessionID = $session.LogonId
    $sessionStart = $session.StartTime
    $users = Get-WmiObject -Class Win32_LoggedOnUser -ComputerName $server | Where-Object { $_.Dependent -like "*LogonId=$sessionID*" }

    foreach ($user in $users) {
        $userName = ([wmi]"$($user.Antecedent)").Name
        $userDomain = ([wmi]"$($user.Antecedent)").Domain
        $ipAddress = (qwinsta /server:$server | Where-Object { $_ -match $userName }) -replace "\s+", " " | Out-String
        $ipAddress = $ipAddress.Trim().Split(" ")[2]

        # Create a custom object to store session data
        $sessionData = [PSCustomObject]@{
            "UserName"      = "$userDomain\$userName"
            "SessionID"     = $sessionID
            "SessionStart"  = $sessionStart
            "IPAddress"     = $ipAddress
        }

        # Export the session data to a CSV file
        $sessionData | Export-Csv -Path $logFile -Append -NoTypeInformation
    }
}

Write-Host "RDP session details logged successfully to $logFile" -ForegroundColor Green
