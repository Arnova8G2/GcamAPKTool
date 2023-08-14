@ECHO off

FOR /f "tokens=2 delims==" %%d IN ('wmic OS Get localdatetime /value') DO SET DTIME=%%d

SET SET_TIME=%DTIME:~0,4%/%DTIME:~4,2%/%DTIME:~6,2% %DTIME:~8,2%:%DTIME:~10,2%

@rem --------------------------
@rem ----- Folder Environment -
@rem --------------------------

IF NOT EXIST "%systemdrive%\Program Files (x86)" (
    SET ARCH=x86
) ELSE (
    SET ARCH=x64
)
SET TOOL=%DIRNAME%Tools\
SET TOOL_FOLDER=%TOOL%%ARCH%\
SET ANDROID_TOOL=%TOOL%x86_x64\

SET TOOL_GCAM_FOLDER=%TOOL%GcamAPKTool\

SET ANDROID_SDK_TOOL=%ANDROID_TOOL%AndroidSDK-34.0.0\
SET PLATFORM_SDK_TOOL=%ANDROID_TOOL%platform-tools-34.0.4\
SET APK_SDK_TOOL=%ANDROID_TOOL%Apk-tools\



SET LOG_FILE=%TOOL%Logs\Log_Apk.txt

@rem --------------------------
@rem ------ Config by default -
@rem --------------------------

SET BUILD=BetaTest

SET CERT=testkey

SET APK_USE_AAPT=--use-aapt2 --aapt %ANDROID_SDK_TOOL%aapt2.exe
SET APK_USE_AAPT1=2

SET NAME=Gcam

SET ENABLED_VERSION=false

SET PROVIDER=com.google.android.apps.camera.specialtypes.SpecialTypesProviderEng
SET PACKAGE_NAME=com.google.android.GoogleCamera


@rem --------------------------
@rem ------ Tools Environment -
@rem --------------------------


@rem 7z
SET ZIP=%TOOL_FOLDER%7z-2000\7z


@rem curl
SET CURL_TOOL=%TOOL_FOLDER%curl-7.69.1\curl


@rem apktool + command line
SET APK_INSTALL_FW=%TOOL%framework\framework-res_api32.apk
SET APK_TOOL=%APK_SDK_TOOL%apktool.jar
SET APK_USE_FW_API=-p %TOOL%framework\
SET APK_JVM_COMPIL=b -nc %APK_USE_AAPT% %APK_USE_FW_API% -o
SET APK_JVM_DECOMPIL= d -f -api 31 --only-main-classes %APK_USE_FW_API% -o


@rem zipalign + command line
SET ZIPALIGN=%ANDROID_SDK_TOOL%zipalign
SET ZIP_JVM=-p 4


@rem ApkSigner + command line 
@rem
@rem  older : --v2-signing-enabled true 
@rem  older : --v3-signing-enabled true 
@rem  older : --stamp-signer
@rem
SET APKSIGNER_TOOL=%ANDROID_SDK_TOOL%lib\apksigner.jar
SET SIGNER_USE_ME_SIGNE=--force-stamp-overwrite --min-sdk-version 30 --max-sdk-version 34 --v4-signing-enabled true


@rem Java command line
SET JAVA_SDK_TOOL=%TOOL_FOLDER%jdk8u252
SET DEFAULT_JVM="-Xms128M" "-XX:MaxRAMPercentage=70.0" "-XX:+UseG1GC" "-Dawt.useSystemAAFontSettings=lcd" "-Dswing.aatext=true" "-Djava.util.Arrays.useLegacyMergeSort=true" "-Djdk.util.zip.disableZip64ExtraFieldValidation=true"

@rem AntiSplit
SET SPLIT_TOOL=%APK_SDK_TOOL%AntiSplit-G2\ArscMerge.jar
SET SPLIT_JVM_COMPIL=split


@rem --------------------------
@rem ---- Install Environment -
@rem --------------------------

SET DECOMPILE_FOLDER=%DIRNAME%Decompiled\
SET RECOMPILE_FOLDER=%DIRNAME%Recompiled\
IF EXIST "%DECOMPILE_FOLDER%" (
   ECHO GcamAPKTool startup...
) ELSE (
   ECHO GcamAPKTool install...
   mkdir %DECOMPILE_FOLDER% > NUL
   mkdir %RECOMPILE_FOLDER% > NUL
)

