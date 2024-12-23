# Winspooldbg
# Windows Printer Troubleshooting & Management Script
A comprehensive batch script designed to help IT administrators and end users quickly troubleshoot and manage Windows printers. This script covers common printing issues, printer removal, and fixes the well-known 0x0000011b network printing error.

Features
Resolve Spooler Issues

Stops the Print Spooler service
Kills printfilterpipelinesvc.exe if running
Clears the print queue
Restarts the Print Spooler service
List & Remove Installed Printers

Enumerates printers located under the Version-3 and Version-4 registry keys
Provides a numbered list for easy selection
Removes the chosen printer registry key
Fix 0x0000011b Network Printing Error

Automatically sets the RpcAuthnLevelPrivacyEnabled registry entry to 0 under HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Print
Restarts the Print Spooler service to apply changes immediately
Why Use This Script?
Time-Saving: Automates repetitive tasks for both end users and IT admins.
Easy to Use: Clear menu-driven interface—no manual registry editing needed for most tasks.
Administrator Rights Check: Prompts for elevation to ensure registry and spooler operations run successfully.
Common Issues Addressed: Overcomes typical printer-related headaches, especially in environments with shared or networked devices.
How It Works
Administrative Privileges
When launched, the script checks for admin rights. If they are absent, it tries to re-run itself with elevated permissions.

Menu Options

Option [1]: Resolve common spooler/print queue issues.
Option [2]: List all printers in the registry and remove a selected printer.
Option [3]: Apply the workaround for the 0x0000011b network printing error.
Registry Interaction
The script uses reg query to list printers in:

mathematica
Kodu kopyala
HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Print\Environments\Windows x64\Drivers\Version-3
HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Print\Environments\Windows x64\Drivers\Version-4
After the user selects a printer by number, the script calls reg delete to remove the corresponding registry entry.

Spooler Service Control
For troubleshooting and applying the 0x0000011b fix, the script stops and restarts the Print Spooler service via net stop spooler and net start spooler.

Getting Started
Download the Script

Clone this repository or download the .bat file directly.
Run the Script as Administrator

Double-click the .bat file.
If not run as an administrator, the script will prompt for elevated privileges.
Follow the On-Screen Menu

Choose [1] to clear spooler issues, [2] to remove a printer, or [3] to fix the 0x0000011b error.
Provide any requested confirmations (e.g., “Y/N” for deleting a printer).
Prerequisites
Windows OS with administrator privileges.
PowerShell (used to relaunch the script with elevated permissions if needed).
Disclaimer
While this script is intended to address common issues safely, always ensure you have proper backups and test in a non-production environment if your setup is critical or highly customized.

Contributing
Contributions are welcome!

Issues: Report any bugs or enhancement requests in the Issues section.
Pull Requests: Fork the repo, create a new branch for your improvement, and open a PR when ready.
