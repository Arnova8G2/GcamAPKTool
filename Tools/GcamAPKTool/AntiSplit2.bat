@ECHO off

ECHO ************************************************************
ECHO * %mode% : %APP_BASE_NAME%
ECHO ************************************************************

@rem
@rem
@rem
ECHO AntiSplit2 apk...
ECHO I: AntiSplit2 apk file... >> "%LOG_FILE%"
ECHO Creating Logs %SET_TIME%
ECHO I: Creating Logs %SET_TIME% >> "%LOG_FILE%"

@rem 
@rem
@rem 
ECHO I: Set Apk file: "%DEST_BASE%" >> "%LOG_FILE%"

@rem --------------------------
@rem ------ Java Environment -
@rem --------------------------
CALL %TOOL_GCAM_FOLDER%java.bat


SET COMPILE_APK=%DECOMPILE_FOLDER%%FILE%

ECHO AntiSplit2 %COMPILE_APK%

ECHO AntiSplit2 %FILE%...

%SET_JAVA% %DEFAULT_JVM% -jar "%SPLIT_TOOL%" %SPLIT_JVM_DECOMPIL% %DEST_BASE% >> "%log_file%"

ECHO. >> "%LOG_FILE%"
ECHO AntiSplit2 successful. >> "%LOG_FILE%"
ECHO ------------------------------------------ >> "%LOG_FILE%"
ECHO AntiSplit2 successful.
pause