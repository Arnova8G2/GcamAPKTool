@ECHO off

cls
ECHO.
ECHO GcamAPKTool Decompile or Compile APK
ECHO.
ECHO.
ECHO GcamAPKTool.bat  source ["-d" or "-c"]
ECHO.
ECHO.
ECHO source           - path to the source file [APK/Folder]
ECHO                    GcamAPKTool.bat gcam.apk -d
ECHO                    GcamAPKTool.bat gcam -c
ECHO.
ECHO BuildApktool     - Build last commit Apktool
ECHO                    After build completes you should have a jar file at: %APK_TOOL%
ECHO.
ECHO Logcat           - connection to a device
ECHO                    you should have a log file at : %DIRNAME%logcat\
ECHO.
ECHO Camera2Dump      - connection to a device
ECHO                    you should have a txt file at : %DIRNAME%camera2dumpsys\
ECHO.
ECHO Install          - install in click right mod  
ECHO                    select gcam apk "click right" - "Decompile This APK"
ECHO                    select folder gcam "click right" - "Compile To APK"

ECHO.

PAUSE