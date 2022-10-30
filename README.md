# Software_Installer

**Software_Installer**

I have added this Software installer script for all the developers to release their software

This script is just start up point which can be extended upto great extent

Following features will be added in the installer

Latest UI-Added
Setting registry-Added
Checkpointing- Added
If previously installed version is not required then rollback facility
Uninstaller
Silent Installation
User input for optional installtion
Checksum validation- Added


Use :

Get-FileHash -Algorithm MD5 -Path ((Get-ChildItem "Path" -Recurse -Force)) | export-csv C:\checksum.md5"
(for creating checksum file"

