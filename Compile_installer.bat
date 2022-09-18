@echo on
cd C:\try\Software_Installer\
powershell -ExecutionPolicy Bypass .\create_manifest_for_all.ps1
cd C:\Program Files (x86)\NSIS
makensis C:\try\Software_Installer\my_software_installer.nsi
echo "Installer created successfully"
cd C:\try\Software_Installer\
copy MY_OWN_COMPANY_FREE_LEARNING_APP_1.0.exe  C:\try\Software_Installer\Final\
create_checksum.bat
pause
pause

