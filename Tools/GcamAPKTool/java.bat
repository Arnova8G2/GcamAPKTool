@echo off
SET ERROR = "error"		

if defined JAVA_HOME goto findJavaFromJavaHome

set SET_JAVA=java.exe
%SET_JAVA% -version >NUL 2>&1
if %ERRORLEVEL% equ 0 goto execute
echo.
echo ERROR: JAVA_HOME is not set and no 'java' command could be found in your PATH.
echo.
echo Download Java and use Java portable mod.

goto download

:findJavaFromJavaHome
set JAVA_HOME=%JAVA_HOME:"=%
set SET_JAVA="%JAVA_HOME%bin\java.exe"

if exist "%SET_JAVA%" goto execute

echo.
echo ERROR: JAVA_HOME is set to an invalid directory: %JAVA_HOME%
echo.
echo Download Java and use Java portable mod.

goto download

:java_error
echo %ERROR%
PAUSE

:download
IF EXIST "%JAVA_SDK_TOOL%" (
    SET SET_JAVA=%JAVA_SDK_TOOL%\bin\java.exe 
    SET JAVA_HOME=%JAVA_SDK_TOOL%
    GOTO execute
)

echo Download jdk8u252+9 java .....
if not exist "%systemdrive%\Program Files (x86)" (
    SET "JAVA_ZIP=https://download.bell-sw.com/java/8u252+9/bellsoft-jdk8u252+9-windows-i586.zip"
) else (
    SET "JAVA_ZIP=https://download.bell-sw.com/java/8u252+9/bellsoft-jdk8u252+9-windows-amd64.zip"
)

echo Download java...
%CURL_TOOL% "%JAVA_ZIP%" -o java.zip >> "%LOG_FILE%"
if errorlevel 1 (
	 SET ERROR="java error download"
	GOTO java_error
)

echo Install java .....
%ZIP% x -tzip "java.zip" -o%TOOL_FOLDER% >> "%LOG_FILE%"
if errorlevel 1 (
	SET ERROR="error unzip"
	GOTO java_error
)
IF EXIST "java.zip" (
   DEL "java.zip" >> "%LOG_FILE%"
)
GOTO download

:execute
ECHO Run Java Runtime Environment
SET path=%JAVA_HOME%/bin;%PATH%
ECHO %path% >nul