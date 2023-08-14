@ECHO off

ECHO ************************************************************
ECHO * %mode% : %APP_BASE_NAME%
ECHO ************************************************************


@rem 
SET BASE_VERSION=%APP_BASE_NAME:*_=%
SET COMPILE_APK=%DECOMPILE_FOLDER%%APP_BASE_NAME%
SET NEW_PACKAGE_NAME=%PACKAGE_NAME%

ECHO.
ECHO - Compilation by default use config.bat info
ECHO.
ECHO   1 - Default compile
ECHO   2 - Manual compile

SET /P DEFAULT=Choice : 

IF /I NOT "%DEFAULT%" == "1" (

    SET /p BUILD="Enter number version : "

    SET /p CERT="Enter sign folder in \Tools\key ex : testkey: "

    SET /p NAME="Enter Name *ex Gcam :  "
	
	SET /P USE_AAPT=Choice aapt = 1 - aapt2 = 2: 
	IF /I "%USE_AAPT%" EQU "1" SET APK_USE_AAPT=
	
	SET /P USE_VERSION=Add number version in apk enter 1: 
	IF /I "%USE_VERSION%" EQU "1" SET ENABLED_VERSION=true

	setlocal enabledelayedexpansion
    SET /a counter=1

    FOR %%f IN (!TOOL!package\*) DO (
	    ECHO *          !counter! - %%~nf%%~xf
	    SET "USE_NAME_!counter!=%%~nf%%~xf"
        SET /a counter+=1
    )
	SET /P NUMBER=*          Choose number :
	
    IF NOT DEFINED NUMBER GOTO :END
	IF /I "%NUMBER%" GEQ "%counter%" GOTO rename
	IF /I "%NUMBER%" LSS 1 GOTO rename
	
	:rename
	CALL %TOOL_GCAM_FOLDER%package.bat "!USE_NAME_%NUMBER%!"
    endlocal
	 
	:END
    IF "%USE_AAPT%" EQU "1" ECHO use aapt1
)

FOR %%a IN (%TOOL%key\%CERT%\*.pk8) DO (SET PK8=%%a)
FOR %%a IN (%TOOL%key\%CERT%\*.pem) DO (SET PEM=%%a)
SET SIGNER_JVM=sign --key "%PK8%" --cert "%PEM%" %SIGNER_USE_ME_SIGNE%


IF DEFINED NAME IF "%NAME%" == "Gcam" (
    SET BUILD_VERSION=%BASE_VERSION:~0,7%.build-%BUILD%.%DTIME:~2,4%%DTIME:~6,2%.%DTIME:~8,2%%DTIME:~10,2%
) ELSE (
    SET BUILD_VERSION=%BUILD%build-%BASE_VERSION:~0,14%
)

ECHO Creating name version...
ECHO I: Creating name version... >> "%LOG_FILE%"
SET FULL_NAME=%NAME%-%BUILD_VERSION%


SET APK_FILE=%RECOMPILE_FOLDER%%FULL_NAME%


@rem --------------------------
@rem ------ Java Environment -
@rem --------------------------
CALL %TOOL_GCAM_FOLDER%java.bat


ECHO Compiling apk : %SET_TIME% .....
ECHO I: Creating Logs %SET_TIME% >> "%LOG_FILE%"

@rem
@rem 
CALL %TOOL_GCAM_FOLDER%compile.bat

@rem
@rem 
IF EXIST "%APK_FILE%.apk" (
    CALL %TOOL_GCAM_FOLDER%checksum.bat
)
EXIT