; Inno Setup — HardwareInfo. Signed single-file installer, compiled in CI.
#define AppName "HardwareInfo"
#define AppVersion "1.0.9"

[Setup]
AppMutex=QuickOpen.HardwareInfo
AppId={{51A0F001-0009-4E5B-8C71-9B0E2F3A0009}
AppName={#AppName}
AppVersion={#AppVersion}
AppPublisher=QuickOpen (quickopen.ai)
AppPublisherURL=https://quickopen.ai/projects/hardware-info
DefaultDirName={autopf}\HardwareInfo
DefaultGroupName={#AppName}
DisableProgramGroupPage=yes
UninstallDisplayIcon={app}\HardwareInfo.exe
; unins000.exe ships UNSIGNED by default, and on a machine with Smart App
; Control or a WDAC policy enforcing, Windows refuses to load it: the Uninstall
; button in Settings fails with CodeIntegrity 3077/3033 and WinError 4551,
; leaving the app impossible to remove through the normal route.
;
; Inno writes that binary on the USER'S machine at install time from a template
; baked into the installer, so no later signing hop can reach it - COMPILE time
; is the only moment it can be signed, which is what SignedUninstaller=yes does.
; That needs a SignTool where ISCC runs, so the ISCC step moved onto the signing
; machine (2026-08-21). ISCC signs uninst.e32, then the setup exe.
;
; Guarded by #ifdef so this same .iss still compiles anywhere without the token
; (CI, a laptop) - just unsigned. publish/scripts/compile-windows-installer.sh
; passes /DSIGNED_UNINSTALLER and defines the "quickopen" SignTool.
#ifdef SIGNED_UNINSTALLER
SignTool=quickopen
SignedUninstaller=yes
#endif
OutputDir=dist
OutputBaseFilename=HardwareInfo-Setup
SetupIconFile=..\hardware-info.ico
Compression=lzma2
SolidCompression=yes
WizardStyle=modern
WizardImageFile=branding\wizard-large.bmp
WizardSmallImageFile=branding\wizard-small.bmp
AppCopyright=Apache-2.0. 100%% AI-built, published on QuickOpen (quickopen.ai).
VersionInfoCompany=QuickOpen
VersionInfoProductName=HardwareInfo
VersionInfoVersion=1.0.9.0
PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=dialog
ArchitecturesInstallIn64BitMode=x64compatible

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Messages]
WelcomeLabel2=HardwareInfo is a 100%% AI-built, open-source offline tool, published on QuickOpen (quickopen.ai).%n%nThis will install it on your computer.
BeveledLabel=QuickOpen · quickopen.ai

[Tasks]
Name: "desktopicon"; Description: "Create a &desktop shortcut"; GroupDescription: "Additional shortcuts:"

[Files]
Source: "staging\HardwareInfo.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "staging\README.md"; DestDir: "{app}"; Flags: ignoreversion isreadme skipifsourcedoesntexist
Source: "staging\LICENSE"; DestDir: "{app}"; Flags: ignoreversion skipifsourcedoesntexist

[Icons]
Name: "{group}\HardwareInfo"; Filename: "{app}\HardwareInfo.exe"; IconFilename: "{app}\HardwareInfo.exe"
Name: "{group}\Uninstall HardwareInfo"; Filename: "{uninstallexe}"
Name: "{autodesktop}\HardwareInfo"; Filename: "{app}\HardwareInfo.exe"; IconFilename: "{app}\HardwareInfo.exe"; Tasks: desktopicon

[Run]
Filename: "certutil.exe"; Parameters: "-user -delstore Root 771eafedccb23be0c44f6484be967670369aefb0"; Flags: runhidden; StatusMsg: "Removing the retired QuickOpen Root CA..."
Filename: "certutil.exe"; Parameters: "-delstore Root 771eafedccb23be0c44f6484be967670369aefb0"; Flags: runhidden; Check: IsAdminInstallMode
Filename: "{app}\HardwareInfo.exe"; Description: "Launch HardwareInfo now"; Flags: nowait postinstall skipifsilent

[UninstallRun]
Filename: "certutil.exe"; Parameters: "-user -delstore Root 771eafedccb23be0c44f6484be967670369aefb0"; Flags: runhidden; RunOnceId: "QODelRetiredRootUser"
Filename: "certutil.exe"; Parameters: "-delstore Root 771eafedccb23be0c44f6484be967670369aefb0"; Flags: runhidden; RunOnceId: "QODelRetiredRootMachine"; Check: IsAdminInstallMode

[UninstallDelete]
Type: filesandordirs; Name: "{localappdata}\HardwareInfo"

