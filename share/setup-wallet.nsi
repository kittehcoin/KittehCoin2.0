; KittehCoin2.0 Core — Windows 64-bit installer (NSIS)
; Maintainer script: packages prebuilt binaries from the sibling Wallet/
; folder in the full project tree (not a GitHub-only clone).
; From-source builds: run autogen/configure/make, then use setup.nsi.in.

Name "KittehCoin2.0 Core (64-bit)"
OutFile "..\..\Installer\KittehCoin2.0-Core-2.0.0-win64-setup.exe"
Unicode true
RequestExecutionLevel admin
SetCompressor /SOLID lzma
SetDateSave off

!define REGKEY "SOFTWARE\$(^Name)"
!define COMPANY "KittehCoin2.0 Core project"
!define URL "https://www.kittehcoin.ca/"
!define VERSION "2.0.0"
!define WALLET "..\..\Wallet"
!define PIXMAPS "pixmaps"
!define DOCS "..\doc"
!define ROOT_SRC ".."

!define MUI_ICON "${PIXMAPS}\kittehcoin.ico"
!define MUI_UNICON "${PIXMAPS}\kittehcoin.ico"
!define MUI_WELCOMEFINISHPAGE_BITMAP "${PIXMAPS}\nsis-wizard.bmp"
!define MUI_UNWELCOMEFINISHPAGE_BITMAP "${PIXMAPS}\nsis-wizard.bmp"
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_RIGHT
!define MUI_HEADERIMAGE_BITMAP "${PIXMAPS}\nsis-header.bmp"
!define MUI_ABORTWARNING
!define MUI_FINISHPAGE_NOAUTOCLOSE
!define MUI_UNFINISHPAGE_NOAUTOCLOSE
!define MUI_STARTMENUPAGE_REGISTRY_ROOT HKLM
!define MUI_STARTMENUPAGE_REGISTRY_KEY ${REGKEY}
!define MUI_STARTMENUPAGE_REGISTRY_VALUENAME StartMenuGroup
!define MUI_STARTMENUPAGE_DEFAULTFOLDER "KittehCoin2.0 Core"
!define MUI_FINISHPAGE_RUN
!define MUI_FINISHPAGE_RUN_FUNCTION LaunchWallet
!define MUI_FINISHPAGE_RUN_TEXT "Launch KittehCoin2.0 Core"

!include MUI2.nsh
!include x64.nsh
!include nsDialogs.nsh
!include LogicLib.nsh

Var StartMenuGroup
Var DataDir
Var DataDirDialog
Var DataDirLabel
Var DataDirEdit
Var DataDirBrowse

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "${ROOT_SRC}\COPYING"
!insertmacro MUI_PAGE_DIRECTORY
Page custom DataDirPage DataDirPageLeave
!insertmacro MUI_PAGE_STARTMENU Application $StartMenuGroup
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_LANGUAGE English

InstallDir "$PROGRAMFILES64\KittehCoin2.0"
InstallDirRegKey HKCU "${REGKEY}" Path
CRCCheck on
XPStyle on
BrandingText "KittehCoin2.0 — https://www.kittehcoin.ca"
ShowInstDetails show
ShowUninstDetails show

VIProductVersion 2.0.0.0
VIAddVersionKey ProductName "KittehCoin2.0 Core"
VIAddVersionKey ProductVersion "${VERSION}"
VIAddVersionKey CompanyName "${COMPANY}"
VIAddVersionKey CompanyWebsite "${URL}"
VIAddVersionKey FileVersion "${VERSION}"
VIAddVersionKey FileDescription "Installer for KittehCoin2.0 Core"
VIAddVersionKey LegalCopyright "Copyright (C) 2009-2026 The KittehCoin2.0 Core developers"

Section "KittehCoin2.0 Core" SEC_MAIN
    SectionIn RO
    SetOutPath $INSTDIR
    SetOverwrite on

    File "${WALLET}\kittehcoin-qt.exe"
    File "${WALLET}\kittehcoind.exe"
    File "${WALLET}\kittehcoin-cli.exe"
    File "${WALLET}\kittehcoin-tx.exe"
    File "${WALLET}\kittehcoin-wallet.exe"
    File "${WALLET}\*.dll"
    File "${WALLET}\qt.conf"
    File /oname=COPYING.txt "${ROOT_SRC}\COPYING"
    File /oname=readme.txt "${DOCS}\README_windows.txt"

    SetOutPath $INSTDIR\platforms
    File "${WALLET}\platforms\*.dll"
    SetOutPath $INSTDIR\styles
    File /nonfatal "${WALLET}\styles\*.dll"
    SetOutPath $INSTDIR\imageformats
    File /nonfatal "${WALLET}\imageformats\*.dll"

    SetOutPath $INSTDIR
    WriteRegStr HKCU "${REGKEY}\Components" Main 1
SectionEnd

Section -post
    WriteRegStr HKCU "${REGKEY}" Path $INSTDIR
    WriteUninstaller $INSTDIR\uninstall.exe

    WriteRegStr HKCU "${REGKEY}" DataDir $DataDir
    ; So kittehcoin-qt remembers the folder even if launched without a shortcut
    WriteRegStr HKCU "Software\KittehCoin\KittehCoin2.0-Qt" "strDataDir" $DataDir

    CreateDirectory "$DataDir"
    CreateDirectory "$DataDir\wallets"
    IfFileExists "$DataDir\kittehcoin.conf" skip_conf 0
        FileOpen $0 "$DataDir\kittehcoin.conf" w
        FileWrite $0 "# KittehCoin2.0 wallet / node$\r$\n"
        FileWrite $0 "addresstype=legacy$\r$\n"
        FileWrite $0 "changetype=legacy$\r$\n"
        FileClose $0
    skip_conf:

    !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
        CreateDirectory "$SMPROGRAMS\$StartMenuGroup"
        CreateShortcut "$SMPROGRAMS\$StartMenuGroup\KittehCoin2.0 Core.lnk" "$INSTDIR\kittehcoin-qt.exe" '-datadir="$DataDir"'
        CreateShortcut "$SMPROGRAMS\$StartMenuGroup\KittehCoin2.0 Core (testnet).lnk" "$INSTDIR\kittehcoin-qt.exe" '-testnet -datadir="$DataDir"'
        CreateShortcut "$SMPROGRAMS\$StartMenuGroup\Uninstall KittehCoin2.0 Core.lnk" "$INSTDIR\uninstall.exe"
    !insertmacro MUI_STARTMENU_WRITE_END

    CreateShortcut "$DESKTOP\KittehCoin2.0 Core.lnk" "$INSTDIR\kittehcoin-qt.exe" '-datadir="$DataDir"'

    WriteRegStr HKCU "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" DisplayName "$(^Name)"
    WriteRegStr HKCU "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" DisplayVersion "${VERSION}"
    WriteRegStr HKCU "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" Publisher "${COMPANY}"
    WriteRegStr HKCU "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" URLInfoAbout "${URL}"
    WriteRegStr HKCU "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" DisplayIcon "$INSTDIR\kittehcoin-qt.exe"
    WriteRegStr HKCU "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" UninstallString "$INSTDIR\uninstall.exe"
    WriteRegDWORD HKCU "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" NoModify 1
    WriteRegDWORD HKCU "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" NoRepair 1

    WriteRegStr HKCR "kittehcoin" "URL Protocol" ""
    WriteRegStr HKCR "kittehcoin" "" "URL:KittehCoin 2.0"
    WriteRegStr HKCR "kittehcoin\DefaultIcon" "" "$INSTDIR\kittehcoin-qt.exe"
    WriteRegStr HKCR "kittehcoin\shell\open\command" "" '"$INSTDIR\kittehcoin-qt.exe" "%1"'
SectionEnd

Section Uninstall
    Delete /REBOOTOK "$DESKTOP\KittehCoin2.0 Core.lnk"
    Delete /REBOOTOK "$SMPROGRAMS\$StartMenuGroup\KittehCoin2.0 Core.lnk"
    Delete /REBOOTOK "$SMPROGRAMS\$StartMenuGroup\KittehCoin2.0 Core (testnet).lnk"
    Delete /REBOOTOK "$SMPROGRAMS\$StartMenuGroup\Uninstall KittehCoin2.0 Core.lnk"
    RmDir /REBOOTOK "$SMPROGRAMS\$StartMenuGroup"

    RMDir /r /REBOOTOK "$INSTDIR\platforms"
    RMDir /r /REBOOTOK "$INSTDIR\styles"
    RMDir /r /REBOOTOK "$INSTDIR\imageformats"

    Delete /REBOOTOK "$INSTDIR\kittehcoin-qt.exe"
    Delete /REBOOTOK "$INSTDIR\kittehcoind.exe"
    Delete /REBOOTOK "$INSTDIR\kittehcoin-cli.exe"
    Delete /REBOOTOK "$INSTDIR\kittehcoin-tx.exe"
    Delete /REBOOTOK "$INSTDIR\kittehcoin-wallet.exe"
    Delete /REBOOTOK "$INSTDIR\*.dll"
    Delete /REBOOTOK "$INSTDIR\qt.conf"
    Delete /REBOOTOK "$INSTDIR\COPYING.txt"
    Delete /REBOOTOK "$INSTDIR\readme.txt"
    Delete /REBOOTOK "$INSTDIR\uninstall.exe"

    RmDir /REBOOTOK "$INSTDIR"

    DeleteRegKey HKCU "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)"
    DeleteRegKey HKCR "kittehcoin"
    DeleteRegKey HKCU "${REGKEY}"
SectionEnd

Function .onInit
    ${IfNot} ${RunningX64}
        MessageBox MB_OK|MB_ICONSTOP "KittehCoin2.0 Core requires 64-bit Windows."
        Abort
    ${EndIf}
    SetRegView 64
    ReadRegStr $DataDir HKCU "${REGKEY}" DataDir
    ${If} $DataDir == ""
        StrCpy $DataDir "$PROFILE\KittehCoin2.0"
    ${EndIf}
FunctionEnd

Function DataDirPage
    !insertmacro MUI_HEADER_TEXT "Wallet and blockchain data" "Choose where KittehCoin stores the wallet and block files. This is separate from the program folder."
    nsDialogs::Create 1018
    Pop $DataDirDialog
    ${If} $DataDirDialog == error
        Abort
    ${EndIf}

    ${NSD_CreateLabel} 0 0 100% 40u "Program files stay in the previous folder. You can type any path (for example D:\KittehCoin2.0) or click Browse — the folder picker starts at This PC so every local drive is listed."
    Pop $DataDirLabel

    ${NSD_CreateLabel} 0 46u 100% 12u "Data directory:"
    Pop $0

    ${NSD_CreateText} 0 62u 100% 14u $DataDir
    Pop $DataDirEdit

    ${NSD_CreateButton} 0 84u 35% 15u "Browse for folder..."
    Pop $DataDirBrowse
    ${NSD_OnClick} $DataDirBrowse DataDirBrowseClick

    nsDialogs::Show
FunctionEnd

Function DataDirBrowseClick
    ; Start at C:\ (exists on every Windows PC) so SHBrowseForFolder
    ; shows Computer/This PC and every drive. A non-existent default
    ; path makes the dialog fail immediately.
    nsDialogs::SelectFolderDialog "Select KittehCoin data directory" "C:\"
    Pop $0
    ${If} $0 != "error"
    ${AndIf} $0 != ""
        ${NSD_SetText} $DataDirEdit $0
    ${EndIf}
FunctionEnd

Function DataDirPageLeave
    ${NSD_GetText} $DataDirEdit $DataDir
    ${If} $DataDir == ""
        MessageBox MB_OK|MB_ICONEXCLAMATION "Please choose a data directory."
        Abort
    ${EndIf}
    ClearErrors
    CreateDirectory "$DataDir"
    ${If} ${Errors}
        MessageBox MB_OK|MB_ICONSTOP "Could not create:$\r$\n$DataDir$\r$\n$\r$\nType a full path such as D:\KittehCoin2.0"
        Abort
    ${EndIf}
FunctionEnd

Function LaunchWallet
    Exec '"$INSTDIR\kittehcoin-qt.exe" -datadir="$DataDir"'
FunctionEnd

Function un.onInit
    SetRegView 64
    !insertmacro MUI_STARTMENU_GETFOLDER Application $StartMenuGroup
FunctionEnd
