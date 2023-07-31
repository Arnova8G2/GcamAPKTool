@echo off
SET ERROR = "error"		

IF EXIST "%JAVA_SDK_TOOL%" (
   GOTO build_with_java
)
echo Download jdk8u252+9 java .....
if not exist "%systemdrive%\Program Files (x86)" (
    SET "JAVA_ZIP=https://download.bell-sw.com/java/8u252+9/bellsoft-jdk8u252+9-windows-i586.zip"
) else (
    SET "JAVA_ZIP=https://download.bell-sw.com/java/8u252+9/bellsoft-jdk8u252+9-windows-amd64.zip"
)

echo Download java .....
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
GOTO build_with_java

:java_error
echo %ERROR%
PAUSE

:build_with_java
ECHO Run Java Runtime Environment
SET SET_JAVA=%JAVA_SDK_TOOL%\bin\java.exe 
SET JAVA_HOME=%JAVA_SDK_TOOL%
SET path=%JAVA_HOME%/bin;%PATH%
ECHO %path% >nul