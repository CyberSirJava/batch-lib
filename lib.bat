:: A general library batch file that can be used.
:: Argument: call %0 :[label] [arguments]
:: Methods be used with labels and "goto :eof" at the end.
:: A value that can be used to return a value for each method

call %*
exit /b

:return
set returns=%*
goto :eof

:validate_ip
setlocal enabledelayedexpansion
set returns=1
for /f "delims=. tokens=1-4" %%i in ("%*") do (
	if not "%%i.%%j.%%k.%%l"=="%*" set returns=0
	for %%I in (%%i %%j %%k %%l) do (
		if %%I lss 0 set returns=0
		if %%I gtr 255 set returns=0
	)
)
set var=%*
set var=!var:.=!
for /l %%n in (0,1,9) do echo !var!| find "%%n">nul && set "var=!var:%%n=!"
if not "!var!"=="" set returns=0
for /f "delims=" %%r in ("!returns!") do (
	endlocal
	call :return %%r
)
goto :eof


:: Not fully working, still in test.
:del_var
if "%1"=="" goto :eof
if %1==* (
	for /f "tokens=1 delims==" %%a in ('set') do set "%%a="
	for /f "tokens=*" %%b in ('start "" /i /wait /b "C:\Windows\system32\cmd.exe" /c set') do echo;%%b
	
	goto :eof
)
set "%1="
goto :eof


:32or64bit
if %PROCESSOR_ARCHITECTURE%==x86 call :return 32
if %PROCESSOR_ARCHITECTURE%==AMD64 call :return 64
goto :eof


:get_windows_version
for /f "tokens=3" %%a in ('wmic os get Caption /value') do call :return %%a
goto :eof


:check_privilages
net session >nul 2>&1
if %errorlevel% equ 0 (call :return 1) else (call :return 0)
goto :eof


:get_shortcuts_target
set temp=%~1
if exist %1 for /f "delims=" %%a in ('wmic path win32_shortcutfile where "name='%temp:\=\\%'" get target /value') do for /f "tokens=2 delims==" %%a in ("%%~a") do call :return %%a
goto :eof


:get_file_hash
for /f "skip=1" %%a in ('CertUtil -hashfile %1 %~2') do call :return %%a

rem Deprecated method
rem for /f "skip=1" %%a in ('CertUtil -hashfile %1 %~2 ^| findstr /b /x /v /c:"CertUtil: "') do set returns=%%a
goto :eof


:: This method only works in powershell v5.1 above.
:check_exe_signature
for /f "delims=" %%a in ('powershell /c (Get-AuthenticodeSignature -FilePath "%~1"^).Status') do call :return %%a
goto :eof


:download_file [URL] [Path]
bitsadmin /transfer mydownloadjob /download /priority FOREGROUND "%~1" "%~2\%~nx1"
goto :eof


:execute_wsciprt [Command]
mshta vbscript:Execute("%*")(window.close)
goto :eof


:: Lock the file before launching it. This protects the file from editing, deleting, etc.
:secure_launch [Path]
@powershell /c ^[System.io.File^]::Open^('%~1', 'Open', 'Read', 'Read'^) *^> $null; cmd /c '%1'
goto :eof


:: For single use in script, "call cmd /c exit /b [Number]"
:set_errorlevel [Number]
exit /b %1
