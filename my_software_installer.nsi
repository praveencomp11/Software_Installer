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
	!include "x64.nsh"
; -----------------------------------------------------------------------
	!include myheader.nsh
	!include LogicLib.nsh
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
!define INSTALLED 0
!define UNINSTALLED 1


; ------------------------------------------------------------------------

; Few welcome Pages for my Installer
!define MUI_PAGE_CUSTOMFUNCTION_PRE SkipPageInPhase2
!insertmacro MUI_PAGE_WELCOME
!define MUI_PAGE_CUSTOMFUNCTION_PRE SkipPageInPhase2

!insertmacro MUI_PAGE_LICENSE 'license.txt'
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
 
; ----------------------------------------------------------------------------
!define WriteLogToFile "!insertmacro WriteToFile"
!define /date MYTIMESTAMP "%Y-%m-%d %H:%M:%S"
!define LogFile "$INSTDIR\log\Installer_log.txt"

!macro WriteToFile NewLine File String
  !if `${NewLine}` == true
  Push `${String}$\r$\n`
  !else
  Push `${String}`
  !endif
  Push `${File}`
  Call WriteToFile
!macroend


; ----------------------------------------------------------------------------
Var StrCmp
Var Phase
Var i
; ----------------------------------------------------------------------------

; The name of our Installer
ReserveFile "${NSISDIR}\Plugins\NSISList.dll""
Name "${MY_COMPANY_NAME}_${MY_SOFTWARE_NAME}_${MY_SOFTWARE_VERSION}"

; The output filname
OutFile "${MY_COMPANY_NAME}_${MY_SOFTWARE_NAME}_${MY_SOFTWARE_VERSION}.exe"

;The defaultinstallation directory
InstallDir $DESKTOP\${MY_SOFTWARE_NAME}

Icon "Logo_ico.ico"

;------------------------------------------------------------------------------
!macro Checksumcheck FileName
	StrCpy $STR ""
	md5dll::GetMD5File ${FileName}
	Pop $0
	StrCpy $STR $0
	DetailPrint "md5: $STR"
	${WriteLogFile} "Checked checksum of file= ${FileName}"
	Push $PLUGINDIR\Checksum.md5"
	Push $STR
	Push 1 #line should be displayed for occurence of search string, if empty string is passed 0r 0
	Call FileSearch
	Pop $2
	Pop $0
	Pop $1
!macroend

Section -SETTING
	SetOutPath "$INSTDIR"
	SetOverwrite ifnewer
SectionEnd

Section "ExtracterAndVerify" SEC_VRIFY
	${List.Create} My_LIST
	SetOutPath $INSTDIR
	File Checksum.md5d
	
	${List.Add} My_LIST "$PLUGINSDIR\1.cpp"
	; copy and add all files here
	${List.Count} $4 My_LIST
	IntOp $4 $4 - 1
	${ForEach} $i $4 0 - 1
		${List.Get} $5 My_LIST $i
		DetailPrint "Check File=$5"
		!insertmacro Checksumcheck $5
		StrCmp $0 0 FileTameredError
	${Next}
	${List.Destroy} My_LIST
	${List.Unload}
	
	WriteRegDWORD HKLM "${REG_UNINSTALL}" "Phase" 0
	Goto +3
	FileTameredError:
	  MessageBox MB_OK "Error"
	  Abort
 SectionEnd

Section "SEC_1"
  SetOutPath  $INSTDIR\Section1
  File Logo_ico.ico
  File license.txt
  ;Banner for progress
  nxs::Show /NOUNLOAD 'MyAPP' /top 'Overall Setup $ \n Please Wait$ \n If ...' /h 1 /can 1 /end
  nxs::Update /NOUNLOAD /sub "SECTION1" /pos 0 end
  
  
  nsExec::ExecToStack 'C:\Windows\Sysnative\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass .\1.ps1" --FFFeatureOff SW_HIDE'
  Pop $0
  ${If} $R0 == 0
	;Success MessageBox
  ${else}
	;Unsuccess
  
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
Function .onInit
	   InitPluginsDir
	   ; Copy "checkerrorcode.ini" File
	   ReadINIStr $0 "checkerrorcode.ini" ${ERROR_CODE} "Code"
	   ReadINIStr $1 "checkerrorcode.ini" 4 "Info"
	   MessageBox mb_iconstop "Reading ini file= $0 $1"
	   ReadRegDWORD $0 HKLM "${REG_UNINSTALL}" "Phase"
	   ${If} $0 == ${INSTALLED}
			StrCpy  $Phase 2
			${UnSelectSection} ${SEC_VERIFY}  ;check section name to deselect
	   ${EndIf}
		
	   
FunctionEnd

Function .onGUIEnd
	nxs::Destroy
	${List.Unload}
FunctionEnd


Function SkipPageInPhase2
	;https://nsis.sourceforge.io/Abort     read this for abort
	${IfThen} $Phase >= 2 $|} Abort ${|}
FunctionEnd


Function FileSearch
Pop $7 ;~~~~Piotrek occurance numberw
Exch $R0 ;search for
Exch
Exch $R1 ;input file
Push $R2
Push $R3
Push $R4
Push $R5
Push $R6
Push $R7
Push $R8
Push $R9
 
 
  StrLen $R4 $R0
  StrCpy $R7 0
  StrCpy $R8 0
  ;~~~~Piotrek start
  StrCpy $9 0
  ${If} $7 == ""
	StrCpy $7 0 ; occurence number user specified
  ${EndIf}
  ;~~~~Piotrek end
  ClearErrors
  FileOpen $R2 $R1 r
  IfErrors Done
 
  LoopRead:
    ClearErrors
    FileRead $R2 $R3
    IfErrors DoneRead
	IntOp $9 $9 + 1 ;Piotrek
 
    IntOp $R7 $R7 + 1
    StrCpy $R5 -1
    StrCpy $R9 0
 
    LoopParse:
      IntOp $R5 $R5 + 1
      StrCpy $R6 $R3 $R4 $R5
      StrCmp $R6 "" 0 +4
        StrCmp $R9 1 LoopRead
          IntOp $R7 $R7 - 1
          Goto LoopRead
 
      StrCmp $R6 $R0 0 LoopParse
        StrCpy $R9 1
        IntOp $R8 $R8 + 1
		;~~~~Piotrek start
		${If} $R8 == $7 ;if occurence is specified - outputs a specified occurence if not last occurence is output]
			StrCpy $0 $9
			StrCpy $7 "-1"
		${ElseIf} $7 == 0
			StrCpy $0 $9
		${EndIf}
		;~~~~Piotrek end
        Goto LoopParse
 
  DoneRead:
    FileClose $R2
  Done:
    StrCpy $R0 $R8
    StrCpy $R1 $R7
 
Pop $R9
Pop $R8
Pop $R7
Pop $R6
Pop $R5
Pop $R4
Pop $R3
Pop $R2
Exch $R1 ;number of lines found on
Exch
Exch $R0 ;output count found
Push $0 ;You need to pop that out after function call as first parameter ````Piotrek
FunctionEnd


Function WriteToFile
Exch $0 ;file to write to
Exch
Exch $1 ;text to write
 
  FileOpen $0 $0 a #open file
  FileSeek $0 0 END #go to end
  FileWrite $0 $1 #write to file
  FileClose $0
 
Pop $1
Pop $0
FunctionEnd

!insertmacro MUI_LANGUAGE "English"