@ECHO off

ECHO ************************************************************
ECHO * %mode% : %APP_BASE_NAME%
ECHO ************************************************************

@rem
@rem
@rem
ECHO Decompiling apk...
ECHO I: Decompiling apk file... >> "%LOG_FILE%"
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

ECHO Decompiling %COMPILE_APK%

ECHO Decompiling %FILE%...

%SET_JAVA% %DEFAULT_JVM% -jar "%APK_TOOL%" %APK_JVM_DECOMPIL% "%COMPILE_APK%" "%DEST_BASE%" >> "%LOG_FILE%"

ECHO Copying...
COPY /Y "%COMPILE_APK%\AndroidManifest.xml" "%COMPILE_APK%\original\back.xml" >> "%LOG_FILE%"

COPY /Y "%COMPILE_APK%\apktool.yml" "%COMPILE_APK%\original\back.yml" >> "%LOG_FILE%"

ECHO. >> "%LOG_FILE%"
ECHO Decompil successful. >> "%LOG_FILE%"
ECHO ------------------------------------------ >> "%LOG_FILE%"
ECHO Decompil successful.
pause