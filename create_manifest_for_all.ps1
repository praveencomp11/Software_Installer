$Currentlocation=Get-Location
If (Test-Path C:\try\Software_Installer\Manifest.MD5) {
     Remove-Item -Path C:\try\Software_Installer\Manifest.MD5 -Force
}
Get-FileHash -Algorithm MD5 -Path ((Get-ChildItem "C:\try\Software_Installer\*.*" -Recurse -Force)) | export-csv C:\try\Software_Installer\Manifest.MD5
Write-host "Manifest file created for all"