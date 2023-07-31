@ECHO off

cls
SET TIME=%DTIME:~2,2%%DTIME:~4,2%%DTIME:~6,2%.%DTIME:~8,2%%DTIME:~10,2%
SET LOG_FOLDER=%DIRNAME%logcat/
SET LOG_TOOL=%ANDROID_TOOL%logcatmod/
SET ADB=%PLATFORM_SDK_TOOL%adb.exe


%ADB% devices
pause

cls
%ADB% logcat -c
cls
%ADB% logcat -c
cls
%ADB% logcat -c
cls
%ADB% logcat -c
cls
%ADB% logcat -c
cls
%ADB% logcat -c
cls

setLocal EnableExtensions EnableDelayedExpansion
set PYTHONIOENCODING=utf-8
pause

%ADB% logcat -vthreadtime | %LOG_TOOL%adb_mtee "%LOG_FOLDER%logcat_%TIME%.log
rem %ADB% logcat | findstr org.codeaurora.snapcam | adb_mtee "logcat_%TIME%.txt
echo save : "logcat%TIME%.txt"
endLocal
pause

%ADB% kill-server