@echo off
PAUSE
SET NEW_PACKAGE_NAME = %PACKAGE_NAME%

@rem 
ECHO Apk Checksum Verifier...
SET MD5_FILE=%RECOMPILE_FOLDER%%FULL_NAME%.hash.txt

ECHO APK file name: %NEW_PACKAGE_NAME% >> "%MD5_FILE%" 
ECHO %FULL_NAME%.apk >> "%MD5_FILE%"
ECHO: >> "%MD5_FILE%"

ECHO APK certificate fingerprints: >> "%MD5_FILE%"
call %TOOL_GCAM_FOLDER%print-apk-signature.bat "%APK_FILE%.apk" "SHA-1" >> "%MD5_FILE%"

ECHO: >> "%MD5_FILE%"
ECHO APK file hashes: >> "%MD5_FILE%"
FOR /f "tokens=*" %%i IN ('@certutil -hashfile %APK_FILE%.apk MD5 ^| find /v "hash of file" ^| find /v "CertUtil"') DO SET r=%%i
SET r=%r: =%
ECHO MD5: %r% >> "%MD5_FILE%"

FOR /f "tokens=*" %%i IN ('@certutil -hashfile %APK_FILE%.apk SHA1 ^| find /v "hash of file" ^| find /v "CertUtil"') DO SET r=%%i
SET r=%r: =%
ECHO SHA-1: %r% >> "%MD5_FILE%"