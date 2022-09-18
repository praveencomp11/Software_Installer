@echo off
pushd %~dp0
cd %~dp0
IF EXIST "C:\try\Software_Installer\Final\Manifest.MD5" del /F C:\try\Software_Installer\Final\Manifest.MD5
IF Exist "C:\try\Software_Installer\Final\MY_OWN_COMPANY_FREE_LEARNING_APP_1.0.zip" del C:\try\Software_Installer\Final\MY_OWN_COMPANY_FREE_LEARNING_APP_1.0.zip
powershell -ExecutionPolicy Bypass .\create_manifest_for_installer.ps1
