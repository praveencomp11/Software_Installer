$Currentlocation=Get-Location
If (Test-Path C:\try\Software_Installer\Final\Manifest.MD5) {
     Remove-Item -Path C:\try\Software_Installer\Final\Manifest.MD5 -Force
}

If (Test-Path C:\try\Software_Installer\Final\MY_OWN_COMPANY_FREE_LEARNING_APP_1.0.zip) {
     Remove-Item -Path C:\try\Software_Installer\Final\Manifest.MD5 -Force
}
Compress-Archive -Path C:\try\Software_Installer\Final\MY_OWN_COMPANY_FREE_LEARNING_APP_1.0.exe -DestinationPath C:\try\Software_Installer\Final\MY_OWN_COMPANY_FREE_LEARNING_APP_1.0.zip
Get-FileHash -Algorithm MD5 -Path ((Get-ChildItem "C:\try\Software_Installer\Final\*.*" -Recurse -Force)) | export-csv C:\try\Software_Installer\Final\Manifest.MD5