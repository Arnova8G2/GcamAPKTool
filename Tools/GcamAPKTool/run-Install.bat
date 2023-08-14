@ECHO Off

cls
ECHO Install click right mod
ECHO.
ECHO   1 - install Compile/Decompile
ECHO   2 - uninstall Compile/Decompile
ECHO   0 - cancel
ECHO.
SET DIRNAMES=%1

:_make_choice
SET INPUT=
ECHO.
SET /P INPUT=-- Choice : 
IF /I "%INPUT%" EQU "1" GOTO :install
IF /I "%INPUT%" EQU "2" GOTO :uninstall
IF /I "%INPUT%" EQU "0" GOTO :end

GOTO _make_choice

:install
reg delete "HKCR\Directory\shell\compile" /F >NUL 2>&1
reg add "HKCR\Directory\shell\compile" /F /VE /T REG_SZ /D "Compile To APK"
reg add "HKCR\Directory\shell\compile\command" /F /VE /T REG_SZ /D "\"%DIRNAMES%GcamAPKTool.bat\" %%1 -c"

reg delete "HKCR\SystemFileAssociations\.apk\shell\subtitle" /F >NUL 2>&1
reg add "HKCR\SystemFileAssociations\.apk\shell\subtitle" /F /VE /T REG_SZ /D "Decompile This APK"
reg add "HKCR\SystemFileAssociations\.apk\shell\subtitle\command" /F /VE /T REG_SZ /D "\"%DIRNAMES%GcamAPKTool.bat\" %%1 -d"

reg delete "HKCR\SystemFileAssociations\.apks\shell\subtitle" /F >NUL 2>&1
reg add "HKCR\SystemFileAssociations\.apks\shell\subtitle" /F /VE /T REG_SZ /D "Decompile This APK"
reg add "HKCR\SystemFileAssociations\.apks\shell\subtitle\command" /F /VE /T REG_SZ /D "\"%DIRNAMES%GcamAPKTool.bat\" %%1 -s"

reg delete "HKCR\SystemFileAssociations\.apks\shell\subtitle" /F >NUL 2>&1
reg add "HKCR\SystemFileAssociations\.apks\shell\subtitle" /F /VE /T REG_SZ /D "AntiSplit2 This APK"
reg add "HKCR\SystemFileAssociations\.apks\shell\subtitle\command" /F /VE /T REG_SZ /D "\"%DIRNAMES%GcamAPKTool.bat\" %%1 -s"

reg delete "HKCR\SystemFileAssociations\.apkm\shell\subtitle" /F >NUL 2>&1
reg add "HKCR\SystemFileAssociations\.apkm\shell\subtitle" /F /VE /T REG_SZ /D "AntiSplit2 This APK"
reg add "HKCR\SystemFileAssociations\.apkm\shell\subtitle\command" /F /VE /T REG_SZ /D "\"%DIRNAMES%GcamAPKTool.bat\" %%1 -s"

reg delete "HKCR\SystemFileAssociations\.apkm\shell\subtitle" /F >NUL 2>&1
reg add "HKCR\SystemFileAssociations\.apkm\shell\subtitle" /F /VE /T REG_SZ /D "AntiSplit2 This APK"
reg add "HKCR\SystemFileAssociations\.apkm\shell\subtitle\command" /F /VE /T REG_SZ /D "\"%DIRNAMES%GcamAPKTool.bat\" %%1 -s"

reg delete "HKCR\SystemFileAssociations\.xapk\shell\subtitle" /F >NUL 2>&1
reg add "HKCR\SystemFileAssociations\.xapk\shell\subtitle" /F /VE /T REG_SZ /D "AntiSplit2 This APK"
reg add "HKCR\SystemFileAssociations\.xapk\shell\subtitle\command" /F /VE /T REG_SZ /D "\"%DIRNAMES%GcamAPKTool.bat\" %%1 -s"

reg delete "HKCR\SystemFileAssociations\.xapk\shell\subtitle" /F >NUL 2>&1
reg add "HKCR\SystemFileAssociations\.xapk\shell\subtitle" /F /VE /T REG_SZ /D "AntiSplit2 This APK"
reg add "HKCR\SystemFileAssociations\.xapk\shell\subtitle\command" /F /VE /T REG_SZ /D "\"%DIRNAMES%GcamAPKTool.bat\" %%1 -s"
GOTO _make_choice

:uninstall
CALL reg delete "HKCR\Directory\shell\compile" /F >NUL 2>&1
CALL reg delete "HKCR\SystemFileAssociations\.apk\shell\subtitle" /F >NUL 2>&1
CALL reg delete "HKCR\SystemFileAssociations\.apks\shell\subtitle" /F >NUL 2>&1
CALL reg delete "HKCR\SystemFileAssociations\.apkm\shell\subtitle" /F >NUL 2>&1
CALL reg delete "HKCR\SystemFileAssociations\.xapk\shell\subtitle" /F >NUL 2>&1

GOTO _make_choice

:end
CALL %DIRNAMES%GcamAPKTool.bat