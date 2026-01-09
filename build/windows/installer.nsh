; Dasi Pharma NSIS Installer Custom Script
; This script extends the default electron-builder NSIS installer

!include "MUI2.nsh"
!include "FileFunc.nsh"
!include "LogicLib.nsh"

; Custom header
!macro customHeader
  !system "echo 'Building Dasi Pharma Installer'"
!macroend

; Pre-initialization - Check for admin privileges
!macro preInit
  UserInfo::GetAccountType
  Pop $0
  ${If} $0 != "admin"
    MessageBox MB_ICONSTOP "Administrator rights are required to install Dasi Pharma.$\n$\nPlease right-click the installer and select 'Run as administrator'."
    SetErrorLevel 740
    Quit
  ${EndIf}
  
  ; Check for minimum Windows version (Windows 10)
  ${If} ${AtMostWin7}
    MessageBox MB_ICONSTOP "Dasi Pharma requires Windows 10 or later."
    Quit
  ${EndIf}
!macroend

; Custom installation initialization
!macro customInit
  ; Check if previous version is installed
  ReadRegStr $0 HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\DasiPharma" "UninstallString"
  ${If} $0 != ""
    MessageBox MB_YESNO|MB_ICONQUESTION "A previous version of Dasi Pharma is already installed.$\n$\nDo you want to uninstall it first?" IDYES uninstall_prev IDNO continue_install
    uninstall_prev:
      ExecWait '$0 /S'
    continue_install:
  ${EndIf}
!macroend

; Custom installation steps
!macro customInstall
  ; Create data directories
  SetShellVarContext all
  CreateDirectory "$LOCALAPPDATA\DasiPharma"
  CreateDirectory "$LOCALAPPDATA\DasiPharma\database"
  CreateDirectory "$LOCALAPPDATA\DasiPharma\logs"
  CreateDirectory "$LOCALAPPDATA\DasiPharma\backups"
  CreateDirectory "$LOCALAPPDATA\DasiPharma\temp"
  
  ; Set directory permissions (full control for Users group)
  AccessControl::GrantOnFile "$LOCALAPPDATA\DasiPharma" "(BU)" "FullAccess"
  
  ; Copy default database if it doesn't exist
  ${IfNot} ${FileExists} "$LOCALAPPDATA\DasiPharma\database\database.sqlite"
    SetOutPath "$LOCALAPPDATA\DasiPharma\database"
    ; Database will be initialized on first run
  ${EndIf}
  
  ; Create desktop environment file
  FileOpen $0 "$INSTDIR\.env.desktop" w
  FileWrite $0 "APP_NAME=$\"Dasi Pharma$\"$\r$\n"
  FileWrite $0 "APP_ENV=production$\r$\n"
  FileWrite $0 "APP_DEBUG=false$\r$\n"
  FileWrite $0 "APP_URL=http://127.0.0.1:8100$\r$\n"
  FileWrite $0 "DB_CONNECTION=sqlite$\r$\n"
  FileWrite $0 "DB_DATABASE=$LOCALAPPDATA\DasiPharma\database\database.sqlite$\r$\n"
  FileWrite $0 "LOG_CHANNEL=daily$\r$\n"
  FileWrite $0 "LOG_LEVEL=warning$\r$\n"
  FileWrite $0 "CACHE_DRIVER=file$\r$\n"
  FileWrite $0 "QUEUE_CONNECTION=sync$\r$\n"
  FileWrite $0 "SESSION_DRIVER=file$\r$\n"
  FileWrite $0 "SESSION_LIFETIME=480$\r$\n"
  FileWrite $0 "NATIVEPHP_UPDATER_ENABLED=true$\r$\n"
  FileClose $0
  
  ; Write installation info to registry
  WriteRegStr HKLM "Software\DasiPharma" "InstallPath" "$INSTDIR"
  WriteRegStr HKLM "Software\DasiPharma" "DataPath" "$LOCALAPPDATA\DasiPharma"
  WriteRegStr HKLM "Software\DasiPharma" "Version" "${VERSION}"
  WriteRegStr HKLM "Software\DasiPharma" "InstallDate" "${{__DATE__}}"
  
  ; Register URL protocol handler for deep links
  WriteRegStr HKCR "dasipharma" "" "URL:Dasi Pharma Protocol"
  WriteRegStr HKCR "dasipharma" "URL Protocol" ""
  WriteRegStr HKCR "dasipharma\DefaultIcon" "" "$INSTDIR\${APP_EXECUTABLE_FILENAME},0"
  WriteRegStr HKCR "dasipharma\shell\open\command" "" '"$INSTDIR\${APP_EXECUTABLE_FILENAME}" "%1"'
  
  ; Create firewall exception
  nsExec::ExecToLog 'netsh advfirewall firewall add rule name="Dasi Pharma" dir=in action=allow program="$INSTDIR\${APP_EXECUTABLE_FILENAME}" enable=yes'
!macroend

; Custom uninstallation steps
!macro customUnInstall
  ; Remove data directories (ask user first)
  MessageBox MB_YESNO|MB_ICONQUESTION "Do you want to remove all Dasi Pharma data including the database?$\n$\nSelect 'No' to keep your data for future reinstallation." IDYES remove_data IDNO keep_data
  remove_data:
    RMDir /r "$LOCALAPPDATA\DasiPharma"
  keep_data:
  
  ; Remove registry entries
  DeleteRegKey HKLM "Software\DasiPharma"
  DeleteRegKey HKCR "dasipharma"
  
  ; Remove firewall exception
  nsExec::ExecToLog 'netsh advfirewall firewall delete rule name="Dasi Pharma"'
!macroend

; Custom pages
!macro customWelcomePage
  ; Add custom welcome text
  !define MUI_WELCOMEPAGE_TITLE "Welcome to Dasi Pharma Setup"
  !define MUI_WELCOMEPAGE_TEXT "This wizard will guide you through the installation of Dasi Pharma Management System.$\r$\n$\r$\nDasi Pharma is a comprehensive pharmacy management solution for:$\r$\n$\r$\n• Inventory Management$\r$\n• Point of Sale (POS)$\r$\n• Procurement & Suppliers$\r$\n• Regulatory Compliance$\r$\n$\r$\nClick Next to continue."
!macroend

; Installer attributes
!macro customInstallMode
  StrCpy $INSTDIR "$PROGRAMFILES64\DasiPharma"
!macroend

