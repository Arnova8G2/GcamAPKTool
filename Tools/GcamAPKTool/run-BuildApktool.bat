@ECHO off

:_make_choice_apktool
cls
ECHO.
ECHO   1 - build last commit apktool
ECHO   2 - clean build
ECHO   0 - cancel
ECHO.

SET INPUT=
ECHO.
SET /P INPUT=-- Choice :
IF /I "%INPUT%" EQU "1" GOTO :build_apktool
IF /I "%INPUT%" EQU "2" GOTO :work_clean
IF /I "%INPUT%" EQU "3" GOTO :build_smali
IF /I "%INPUT%" EQU "0" GOTO :eof

GOTO _make_choice_apktool

:build_smali
@rem --------------------------
@rem ------ Java Environment -
@rem --------------------------
CALL %TOOL_GCAM_FOLDER%java.bat

CD /D "%DIRNAME%"

%CURL_TOOL% https://codeload.github.com/JesusFreke/smali/zip/master -o smali.zip
IF errorlevel 1 (
	ECHO smali error download
	GOTO work_error
)

RD /f /q /a "smali-master" >> "%LOG_FILE%"
%ZIP% x -tzip "smali.zip" -aoa -sccWIN >> "%LOG_FILE%"
IF errorlevel 1 (
	ECHO error unzip
	GOTO work_error
)
pause


CD "smali-master"
CALL gradlew.bat -w build shadowJar proguard

CD /D "%DIRNAME%"

GOTO _make_choice_apktool

:build_apktool

@rem --------------------------
@rem ------ Java Environment -
@rem --------------------------
CALL %TOOL_GCAM_FOLDER%java.bat

SET "urlcommit=https://codeload.github.com/iBotPeaches/Apktool/zip/master"
SET "foldercommit=Apktool-master"

SET "FileDate=%DTIME:~2,2%%DTIME:~4,2%%DTIME:~6,2%.%DTIME:~8,2%%DTIME:~10,2%"

ECHO I: Creating Logs %DTIME:~0,4%/%DTIME:~4,2%/%DTIME:~6,2% %DTIME:~8,2%:%DTIME:~10,2% >> "%LOG_FILE%"



CD /D "%DIRNAME%"
IF EXIST "commitHistory.txt" (
   DEL "commitHistory.txt" >> "%LOG_FILE%"
)
%CURL_TOOL% https://api.github.com/repos/iBotPeaches/Apktool/git/refs/heads/master > commitHistory.txt

SETLOCAL enabledelayedexpansion
SET commit=
FOR /f "delims=" %%x IN (commitHistory.txt) DO SET "commit=!commit!%%x"
SET commit=%commit:{    =%
SET commit=%commit:sha": "=%
SET commit=%commit:"=%
SET "commit=%commit:~2,-2%"
SET "commit=%commit:: ==%"
SET "%commit:, =" & SET "%"
SET "commit=%object%"


IF EXIST "commitHistory.txt" (
   DEL "commitHistory.txt" >> "%LOG_FILE%"
)
SET "urlcommit=https://codeload.github.com/iBotPeaches/Apktool/zip/%commit%"
SET "foldercommit=Apktool-%commit%"

IF EXIST "%foldercommit%" (
   rmdir /f /q /a "%foldercommit%" >> "%LOG_FILE%"
)

%CURL_TOOL% %urlcommit% -o Apktool.zip
IF errorlevel 1 (
	ECHO apktool error download
	GOTO work_error
)

%ZIP% x -tzip "Apktool.zip" -aoa -sccWIN >> "%LOG_FILE%"
IF errorlevel 1 (
	ECHO error unzip
	GOTO work_error
)

SET "build_file=%foldercommit%\build.gradle"
SET "build_files=%foldercommit%\build.txt"


SET "search=getCheckedOutGitCommitHash();"
SET "replace='%commit%'"
%ANDROID_TOOL%sed-4.2.1\sed  -e "s/%search%/%replace%/" "%build_file%" > "%build_files%"

IF EXIST "%build_file%" (
   DEL "%build_file%" >> "%LOG_FILE%"
)

IF EXIST "%build_files%" (
   COPY "%build_files%" "%build_file%" >> "%LOG_FILE%"
   DEL "%build_files%" >> "%LOG_FILE%"
)

SET MapFile=%foldercommit%\brut.apktool\apktool-lib\src\main\resources\properties\apktool.properties
SET ReplaceFile=%foldercommit%\brut.apktool\apktool-lib\src\main\resources\properties\apktool.txt

SET "SEARCHTEXT=@version@"
SET "REPLACETEXT=@version@-!FileDate!"

FOR /f "usebackq delims=" %%A IN (%MapFile%) DO (
   SET "string=%%A"
   SET "string=!string:%SEARCHTEXT%=%REPLACETEXT%!"
   SET str=!string:~-9!
   SET str3=!string!
   IF EXIST "%MapFile%" find /i ^"!str!^" %MapFile% >> "%LOG_FILE%"
   IF EXIST "%ReplaceFile%" find /i ^"!str!^" %ReplaceFile% >> "%LOG_FILE%"
   IF errorlevel 1 ECHO !str3!>>%ReplaceFile% 2>nul
)

IF EXIST "Apktool.zip" (
   DEL "Apktool.zip" >> "%LOG_FILE%"
)
IF EXIST "%MapFile%" (
   DEL "%MapFile%" >> "%LOG_FILE%"
)

IF EXIST "%ReplaceFile%" (
   COPY "%ReplaceFile%" "%MapFile%" >> "%LOG_FILE%"
   DEL "%ReplaceFile%" >> "%LOG_FILE%"
)


CD "%foldercommit%"
CALL gradlew.bat -w build shadowJar proguard

CD /D "%DIRNAME%"

SET count=0
FOR %%i IN ("%foldercommit%\brut.apktool\apktool-cli\build\libs\apktool*small*.jar") DO (
   SET /A count+=1
   SET search=%%~nxi
   SET "search=!search:-=_!"
   SET "search=!search:_small=!"
   SET "search=!search:_dirty=!"
   SET FileName=%%~i
)

SET "search=%search:~0,-4%"
COPY "%FileName%" "ApkTool\%search%_%FileDate%.jar" >> "%LOG_FILE%"
COPY "%FileName%" "%APK_SDK_TOOL%apktool.jar" >> "%LOG_FILE%"
IF EXIST "%APK_SDK_TOOL%apktool.jar" (
   DEL "%APK_SDK_TOOL%apktool.jar" >> "%LOG_FILE%"
)
cls
ECHO build done : %search%_%FileDate%.jar

IF %count%==0 (
	ECHO error build
)

IF EXIST "%foldercommit%" (
   rmdir /f /q /a "%foldercommit%" >> "%LOG_FILE%"
)

ENDLOCAL
GOTO work_clean

:work_error
IF EXIST "Apktool.zip" (
   DEL "Apktool.zip" >> "%LOG_FILE%"
)
IF EXIST "Apktool-master" (
   rmdir /f /q /a "Apktool-master" >> "%LOG_FILE%"
)

:work_clean
cls
IF EXIST "java.zip" (
   DEL "java.zip" >> "%LOG_FILE%"
)
IF EXIST "Apktool.zip" (
   DEL "Apktool.zip" >> "%LOG_FILE%"
)
IF EXIST "Apktool-master" (
   rmdir /s /q "Apktool-master" >> "%LOG_FILE%"
)
IF EXIST "%foldercommit%" (
   rmdir /f /q /a "%foldercommit%" >> "%LOG_FILE%"
)
IF EXIST "commitHistory.txt" (
   DEL "commitHistory.txt" >> "%LOG_FILE%"
)

SET folder=%foldercommit%
IF EXIST "%folder%" (
    CD /d %folder%
    FOR /F "delims=" %%i IN ('DIR /b') DO (RMDIR "%%i" /s/q || DEL "%%i" /s/q)
)
GOTO _make_choice_apktool