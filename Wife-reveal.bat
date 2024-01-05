@echo off

setlocal enabledelayedexpansion

echo;
echo Wifies and their passwords:
echo;

for /f "tokens=1,2 delims=^:" %%a in ('netsh wlan show profiles') do (
	set result=%%b
	set result=!result:~1!
	if not "%%b"=="" set wifi_list=!wifi_list! "!result!"
)

for %%a in (%wifi_list%) do for /f "tokens=1,2 delims=:" %%i in ('netsh wlan show profile name^=%%a key^=clear') do (
	if "%%i"=="    Key Content            " echo %%~a:%%j
)

echo;

pause