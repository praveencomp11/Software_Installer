; ---------------------------------------------------------------------
; Author: Praveen Hore
; Date: 02 Jun 2022
; Time: 7:00 PM
; File: my_software_installer
; -----------------------------------------------------------------------
; Description
   ; This is the best script to create installer of your own software
   ; Need: Client is not able to find the correct path of file in their software 
   ; To provide them fast software only solution you can use this script
    
   ; You can customize this script as per your requirement
; -------------------------------------------------------------------------   
; Include the file for Modern UI
	!include  "MUI.nsh"
; -----------------------------------------------------------------------

; Few Declartion for My Software
;This is just checking
;This is second check
;this is third change
;This is fourth change
!define MY_SOFTWARE_NAME "FREE_LEARNING_APP"
!define MY_SOFTWARE_VERSION "1.0"
!define MY_COMPANY_NAME "MY_OWN_COMPANY"
!define REG_UNINSTALL "SOFTWARE\WOW6432Node\FreeLearning\EnvCheck"


; ------------------------------------------------------------------------

; Few welcome Pages for my Installer

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE 'license.txt'
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
 
; ----------------------------------------------------------------------------
; The name of our Installer
Name "${MY_COMPANY_NAME}_${MY_SOFTWARE_NAME}_${MY_SOFTWARE_VERSION}"

; The output filname
OutFile "${MY_COMPANY_NAME}_${MY_SOFTWARE_NAME}_${MY_SOFTWARE_VERSION}.exe"

;The defaultinstallation directory
InstallDir $DESKTOP\${MY_SOFTWARE_NAME}

Icon "Logo_ico.ico"

;------------------------------------------------------------------------------

Section "SEC_1"
  SetOutPath  $INSTDIR\Section1
  File Logo_ico.ico
  File license.txt
  
SectionEnd


; All beloew sections are for test only. I am just checking whether files are present or not best way is to call
; Installation checking file and rollback if there is nismatch


SectionGroup "Web Development Software" Group_1

	Section ".net"
		
		
		IfFileExists "$INSTDIR\.net\Demo_script.bat" 0 Alter 		
		File /oname=$INSTDIR\.net\Demo_script1.bat Demo_script.bat
		Goto AlreayInstalled
		
		Alter:
		IfFileExists "$INSTDIR\.net\Demo_script1.bat" 0 +2		
		File /oname=$INSTDIR\.net\Demo_script.bat Demo_script.bat
		
		AlreayInstalled:
		WriteRegStr HKLM "SOFTWARE\WOW6432Node\FreeLearning\EnvCheck" '.net' 'Installed'
	SectionEnd
	
	Section "PHP"
		SetOutPath  $INSTDIR\PHP
		WriteRegStr HKLM "SOFTWARE\WOW6432Node\FreeLearning\EnvCheck" 'PHP' 'Installed'
	SectionEnd
	
SectionGroupEnd

SectionGroup "Script Language" Group_2

	Section "Python"
		SetOutPath  $INSTDIR\Python
		WriteRegStr HKLM "SOFTWARE\WOW6432Node\FreeLearning\EnvCheck" 'Python' 'Installed'		
	SectionEnd
	
	Section "Batch"
	    MessageBox MB_YESNO "Do you really want to install Batch software?" IDNO skip_batch_installation
		SetOutPath  $INSTDIR\Batch
		File Demo_script.bat
		WriteRegStr HKLM "SOFTWARE\WOW6432Node\FreeLearning\EnvCheck" 'Batch' 'Installed'
		
		
		skip_batch_installation:		
	SectionEnd
	
SectionGroupEnd


!insertmacro MUI_LANGUAGE "English"