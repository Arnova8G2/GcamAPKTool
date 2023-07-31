@echo off
setlocal enabledelayedexpansion

if [%1]==[] (
  echo Error: Filepath to APK is undefined.
  exit /B 1
)

set apk_path="%~1"

if not [%2]==[] (
  set fingerprint=%~2
  if not "!fingerprint!"=="MD5" if not "!fingerprint!"=="SHA-1" if not "!fingerprint!"=="SHA-256" (
    echo Error: fingerprint_hash_algorithm is invalid.
    exit /B 1
  )
)

if not defined fingerprint (
  %SET_JAVA% %DEFAULT_JVM% -jar %APKSIGNER_TOOL% verify --print-certs -v %apk_path%
) else (
  for /F "tokens=* delims=" %%L in ('%SET_JAVA% %DEFAULT_JVM% -jar %APKSIGNER_TOOL% verify --print-certs %apk_path%') do call :filter_line %%L
  if defined filtered_fingerprint echo !fingerprint! : !filtered_fingerprint!
)
goto done

:filter_line
  set line=%*
  call set filtered_line=%%line:Signer #1 certificate !fingerprint! digest: =%%
  if not "!line!"=="!filtered_line!" (
    set filtered_fingerprint=!filtered_line!
    set filtered_fingerprint=!filtered_fingerprint: =!
  )
  goto :eof

:done
endlocal