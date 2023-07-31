@ECHO off

SET TIME=%DTIME:~2,2%%DTIME:~4,2%%DTIME:~6,2%.%DTIME:~8,2%%DTIME:~10,2%
SET DUMP_FOLDER=%DIRNAME%camera2dumpsys/
SET NAME=device
SET ADB=%PLATFORM_SDK_TOOL%adb.exe

SET /p lst="Enter name device for dump : " 
for %%a in (%lst%) do (
   SET "NAME=%%a"
)

%ADB% devices
%ADB% shell dumpsys media.camera > %DUMP_FOLDER%camera2dumpsys-%NAME%-%TIME%.txt
pause