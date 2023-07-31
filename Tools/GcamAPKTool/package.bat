@ECHO off
IF [%1]==[] (
    ECHO Rename package name in apk .....
)

IF DEFINED NEW_PACKAGE_NAME IF %NEW_PACKAGE_NAME% == "" SET NEW_PACKAGE_NAME=%1

ECHO %NEW_PACKAGE_NAME% package name in apk .....

ECHO Rename package name in apk .....

(ECHO "%NEW_PACKAGE_NAME%" & ECHO.) | findstr /O . | more /e +1 | (SET /P RESULT= & CALL EXIT /B %%RESULT%%)

SET /A STRLENGTH=%ERRORLEVEL%-5

CALL %TOOL_GCAM_FOLDER%replacer.bat %COMPILE_APK%\AndroidManifest.xml "%PACKAGE_NAME%" "%NEW_PACKAGE_NAME%"

ECHO Rename package name %PACKAGE_NAME% by %NEW_PACKAGE_NAME%

CALL SET SUBSTRING=%%NEW_PACKAGE_NAME:~-3,%STRLENGTH%%%

CALL SET NEWPROVIDER=%%PROVIDER:Eng=%SUBSTRING%%%

CALL %TOOL_GCAM_FOLDER%replacer.bat %COMPILE_APK%\AndroidManifest.xml "%PROVIDER%" "%NEWPROVIDER%"

ECHO %SUBSTRING% Rename provider %PROVIDER:~-23,67% by %NEWPROVIDER:~-23,67%