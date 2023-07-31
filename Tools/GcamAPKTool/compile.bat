@ECHO off
SET ERROR = "error"		


@rem
@rem 
IF EXIST "%USERPROFILE%\AppData\Local\apktool\framework\1.apk" (
    ECHO Framework-res is OK .....
    ECHO I: Framework-res is OK ..... >> "%LOG_FILE%"
) ELSE (
    ECHO Install framework-res .....
    %SET_JAVA% %DEFAULT_JVM% -jar "%APK_TOOL%" IF "%APK_INSTALL_FW%" >> "%LOG_FILE%"
)


@rem
@rem 
ECHO Creating name and version number...
ECHO Name : %FULL_NAME%
ECHO I: Creating name and version number... >> "%LOG_FILE%"
ECHO I: Name : %FULL_NAME% >> "%LOG_FILE%"
IF EXIST "%COMPILE_APK%\build" (
   RMDIR /S /Q %COMPILE_APK%\build > NUL
   ECHO Deleting build folder for a clean compilation...
   ECHO I: Deleting build folder for a clean compilation... >> "%LOG_FILE%"
)


@rem
@rem 
if %ENABLED_VERSION% EQU true (
    ECHO Creating version number in apk...
    ECHO I: Creating version number in apk... >> "%LOG_FILE%"
    %ANDROID_TOOL%sed-4.2.1\sed -i -r "s/versionName\:(.+)/versionName\: %BUILD_VERSION%/" "%COMPILE_APK%\apktool.yml"
)

@rem
@rem 
ECHO I: Compilation is ready... >> "%LOG_FILE%"
ECHO I: Compiling apk file... >> "%LOG_FILE%"
ECHO Compiling APK file...

@rem
SET APK_COMPILE=%APK_FILE%unsigned.apk


@rem
SET APK_ZIPALIGNED=%APK_FILE%zipaligned.apk


@rem 
%SET_JAVA% %DEFAULT_JVM% -jar "%APK_TOOL%" %APK_JVM_COMPIL% "%APK_COMPILE%" "%COMPILE_APK%" >> "%LOG_FILE%"

@rem
@rem 
ECHO Zipalign APK file...
ECHO I: Zipalign apk file... >> "%LOG_FILE%"
%ZIPALIGN% %ZIP_JVM% "%APK_COMPILE%" "%APK_ZIPALIGNED%" >> "%LOG_FILE%"

@rem
@rem 
ECHO ApkSigner APK file...
ECHO I: ApkSigner apk file... >> "%LOG_FILE%"
%SET_JAVA% %DEFAULT_JVM% -jar "%APKSIGNER_TOOL%" %SIGNER_JVM% --out "%APK_FILE%.apk" "%APK_ZIPALIGNED%"

@rem
@rem 
IF EXIST "%APK_COMPILE%" (
   DEL %APK_COMPILE% >> "%LOG_FILE%"
)
IF EXIST "%APK_ZIPALIGNED%" (
   DEL %APK_ZIPALIGNED% >> "%LOG_FILE%"
)
IF EXIST "%APK_FILE%.apk.idsig" (
   DEL %APK_FILE%.apk.idsig >> "%LOG_FILE%"
)
ECHO. >> "%LOG_FILE%"