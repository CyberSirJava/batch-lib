
set locale_en=^
a~A ^
b~B ^
c~C ^
d~D ^
e~E ^
f~F ^
g~G ^
h~H ^
i~I ^
j~J ^
k~K ^
l~L ^
m~M ^
n~N ^
o~O ^
p~P ^
q~Q ^
r~R ^
s~S ^
t~T ^
u~U ^
v~V ^
w~W ^
x~X ^
y~Y ^
z~Z


call %* & exit /b


:validate
goto :eof


:trim
for /f "tokens=*" %%a in ("%*") do echo %%a
goto :eof


:upper_case
setlocal enabledelayedexpansion
set result=%*

for %%l in (%locale_en%) do for /f "tokens=1,2 delims=~" %%a in ("%%l") do (
	echo !result! | find /v "%%a" > nul || set result=!result:%%a=%%b!
)

for /f "delims=" %%a in ("!result!") do endlocal & set result=%%a
goto :eof


:lower_case
setlocal enabledelayedexpansion
set result=%*

for %%l in (%locale_en%) do for /f "tokens=1,2 delims=~" %%a in ("%%l") do (
	echo !result! | find /v "%%b" > nul || set result=!result:%%b=%%a!
)

for /f "delims=" %%a in ("!result!") do endlocal & set result=%%a
goto :eof