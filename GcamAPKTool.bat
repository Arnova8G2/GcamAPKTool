@IF "%DEBUG%" == "" @ECHO off
TITLE GcamAPKTool

@rem --------------------------
@rem ----- dir name Environment -
@rem --------------------------
SET DIRNAME=%~dp0
IF DEFINED DIRNAME IF %DIRNAME% == "" SET DIRNAME=.
CD /D %DIRNAME%

SET APP_BASE_NAME=%~nx1
SET DEST_BASE=%1
SET FILE=%~n1

CALL config.bat

IF [%1]==[] (
   GOTO _make_run
)


IF [%2]==[-c] (
  SET mode=compile
  CALL %TOOL_GCAM_FOLDER%Recompil.bat
)
IF [%2]==[-d] (
  SET mode=decompile
  CALL %TOOL_GCAM_FOLDER%Decompil.bat
)

:_make_run

net session>NUL 2>&1
IF %errorlevel%==0 GOTO :_make_choice
ECHO CreateObject("Shell.Application").ShellExecute "%~f0", "", "", "runas">"%temp%/elevate.vbs"
"%temp%/elevate.vbs"
DEL "%temp%/elevate.vbs"
EXIT 

:_make_choice 
cls
ECHO - GcamAPKTool all tools for gcam
ECHO.
ECHO   1 - Compile apktool
ECHO   2 - Run Logcat
ECHO   3 - Run Camera2Dump
ECHO   4 - Run Install
ECHO   5 - Help
ECHO   0 - cancel
ECHO.

SET INPUT=
ECHO.
SET /P INPUT=-- Choice :
IF /I "%INPUT%" EQU "1" GOTO :tool
IF /I "%INPUT%" EQU "2" GOTO :logcat
IF /I "%INPUT%" EQU "3" GOTO :Dumpsys
IF /I "%INPUT%" EQU "4" GOTO :Install
IF /I "%INPUT%" EQU "5" GOTO :Help
IF /I "%INPUT%" EQU "0" GOTO :end
GOTO _make_choice

:tool
CALL %TOOL_GCAM_FOLDER%run-BuildApktool.bat
GOTO _make_choice


:logcat
CALL %TOOL_GCAM_FOLDER%run-Logcat.bat
GOTO _make_choice


:Dumpsys
CALL %TOOL_GCAM_FOLDER%run-Dumpsys.bat
GOTO _make_choice


:Install
CALL %TOOL_GCAM_FOLDER%run-Install.bat %DIRNAME%
GOTO _make_choice


:Help
CALL %TOOL_GCAM_FOLDER%run-Help.bat
GOTO _make_choice

:end
EXIT