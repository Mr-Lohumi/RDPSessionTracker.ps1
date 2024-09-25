# RDPSessionTracker.ps1

# RDP Session Tracker Script

## Overview

This PowerShell script tracks RDP sessions on a remote server, logging user details, session start time, session ID, and IP address to a CSV file.

## Requirements

- PowerShell (v5.0+)
- Remote server access
- The `qwinsta` command

## Usage

1. **Run the script**:
   - To be prompted for the server name:
     ```powershell
     .\RDPSessionTracker.ps1
     ```
   - Or specify the server directly:
     ```powershell
     .\RDPSessionTracker.ps1 -server "RemoteServer01"
     ```

2. **CSV Output**:  
   The script logs data to `C:\RDPSessionLogs.csv`.

## Example

```powershell
.\RDPSessionTracker.ps1 -server "RemoteServer01"
```

## License

Licensed under the MIT License.

