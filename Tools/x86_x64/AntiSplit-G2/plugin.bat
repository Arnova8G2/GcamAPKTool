@if "%DEBUG%" == "" @ECHO off
title BuildApkTool
FOR /f "tokens=2 delims==" %%a IN ('wmic OS Get localdatetime /value') DO SET "dt=%%a"
SET DIRNAME=%~dp0
if "%DIRNAME%" == "" SET DIRNAME=.

if not exist "%systemdrive%\Program Files (x86)" (
    SET "ARCH=x86"
) else (
    SET "ARCH=x64"
)
SET "TOOL=%DIRNAME%apks\"
SET "TOOL_FOLDER=%TOOL%%ARCH%\"
SET "ANDROID_TOOL=%TOOL%x86_x64\"
SET "ANDROID_SDK=%ANDROID_TOOL%Apk-tools\
@rem
@rem  Tools Environment
@rem 
@rem curl
SET "CURL_TOOL=%TOOL_FOLDER%curl-7.69.1\curl"
@rem 7z 
SET "ZIP=%TOOL_FOLDER%7z-2000\7z"
@rem Java version folder + command line
SET "JAVA_TOOL=%TOOL_FOLDER%jdk8u252"
SET DEFAULT_JVM_OPTS="-Xms128M" "-Xmx4g" "-Dawt.useSystemAAFontSettings=lcd" "-Dswing.aatext=true" "-XX:+UseG1GC"
@rem

java -jar ArscMerge.jar split %TOOL%
PAUSE
:_make_choice
SET INPUT=
echo.
SET /P INPUT=-- Choice :
if /I "%INPUT%" EQU "1" goto :ready
if /I "%INPUT%" EQU "2" goto :ready
if /I "%INPUT%" EQU "3" goto :config
if /I "%INPUT%" EQU "0" goto :eof

goto _make_choice

:ready

set log_file=AntiSplit2.txt

type nul >"%log_file%"

set TEMPNAME=
for /f "delims=" %%a in ('FileToOpen "set TEMPNAME=" "%DIRNAME%\_INPUT_APK\*.apks;*.zip;*.xapk" "str_selectfile"') do %%a
if '%TEMPNAME%'=='' (
    goto _make_choice
)

if %INPUT%==1 (
    echo [*] str_working %TEMPNAME%
    call :checksplit %TEMPNAME%
)
if %INPUT%==2 (
    echo [*] str_working %TEMPNAME%
    call :checklang %TEMPNAME%
)

echo.
echo Log %log_file%
echo.
if %open_log%==ON (
    start "" "%log_file%"
) else (
    SET INPUT=
    SET /P INPUT=str_press1
    IF %INPUT%==1 start "" "%log_file%"
)
pause
goto:eof

:checksplit

java -version >> "%log_file%" 2>&1
echo.>>"%log_file%"
echo "Check Java InitialHeapSize & MaxHeapSize" >> "%log_file%"
echo "1048576 = 1 MB; 262144000 = 250 MB; 536870912 = 512 MB"; 1073741824 = 1024 MB = 1 GB >> "%log_file%"
echo.>>"%log_file%"
java -XX:+PrintFlagsFinal -version | findstr /i "HeapSize PermSize ThreadStackSize" >> "%log_file%"
echo.>>"%log_file%"
echo "%~1" >> "%log_file%"
echo.>>"%log_file%"

start cmd /k ^(java -Dfile.encoding=utf-8 -jar "ArscMerge.jar" split %~1 2>^&1 ^| mtee /+ "%log_file%"^)
::output only in cmd
::start cmd /k java -Dfile.encoding=utf-8 -jar "ArscMerge.jar" split  %~1 >>"%log_file%" 2>&1
:: write only in log
::java -Dfile.encoding=utf-8 -jar "ArscMerge.jar" split %~1 >>"%log_file%" 2>&1 
goto:eof

:checklang
java -version >> "%log_file%" 2>&1
echo.>>"%log_file%"

start cmd /k ^(java -Dfile.encoding=utf-8 -jar "ArscMerge.jar" lang %~1 2>^&1 ^| mtee /+ "%log_file%"^)
::output only in cmd
::start cmd /k java -Dfile.encoding=utf-8 -jar "ArscMerge.jar" lang %~1 >>"%log_file%" 2>&1
:: write only in log
::java -Dfile.encoding=utf-8 -jar "ArscMerge.jar" lang %~1 >>"%log_file%" 2>&1 
goto:eof
