@echo off

:: *****************************
:: Configure the User Environment for Cmder.exe
set cmder_path=%~dp0
set cmder_root=%cmder_path:~0,-1%
set str_cmp=ok-cmder
set end_flag=-xxxend

reg query HKCU\Environment\ /v path > a.txt

setlocal enabledelayedexpansion
for /f "tokens=1-3 delims= " %%i in (a.txt) do (
	set name=%%i
	set type=%%j
	set value=%%k
)

set tmp_val=%value%%end_flag%
:no_cmder_path
if not "%tmp_val%"=="%end_flag%" (
	if "%tmp_val:~0,8%"=="%str_cmp%" goto exist_cmder_path
	set tmp_val=%tmp_val:~1%
	goto no_cmder_path
)
set value=%value%;%cmder_root%
reg add "HKCU\Environment" /f /t %type% /v %name% /d "%value%"

:exist_cmder_path
del a.txt

:: *****************************
:: Configure local git config
:: set /p tip="if need to configure git?[y/n]: "
:: set gitcmd=%~dp0vendor\cygwin\bin\git.exe
:: if "%tip%"=="N" set tip=n
:: if "%tip%"=="n" goto nogitconfig
:: :: if "%tip%"=="Y" set tip=y
:: :: if "%tip%"=="y" goto gitconfig
:: ::
:: :: :gitconfig
:: set option=null
:: set /p option="Please input user name: "
:: if not "%option%"=="null" (
:: 	%gitcmd% config --local user.name %option%
:: )
:: set /p option="Please input user email: "
:: if not "%option%"=="null" (
:: 	%gitcmd% config --local user.email %option%
:: )
::
:: %gitcmd% config --local alias.st status
:: %gitcmd% config --local alias.co checkout
:: %gitcmd% config --local alias.ci commit
:: %gitcmd% config --local alias.br branch
:: %gitcmd% config --local alias.df diff
::
:: echo "Success to configure git conig..."
:: :nogitconfig

:: *****************************
:: To install cygwin
set /p tip="if the first install, recommend to install cygwin?[y/n]: "
if "%tip%"=="N" set tip=n
if "%tip%"=="n" goto configend

set INSTALL_DIR=%~dp0\src-install

:: Install cygwin command packages
:: %INSTALL_DIR%\setup-x86_64.exe -q -n -s http://mirrors.163.com/cygwin/ -R D:\ok-cmder\vendor\git-for-windows\cygwin

:: Install gcc compiler
%INSTALL_DIR%\setup-x86_64.exe -q -n -W -s http://mirrors.163.com/cygwin/ --root %~dp0\vendor\cygwin -l %INSTALL_DIR%\tmp ^
-P gcc-core -P gcc-g++ -P make -p gdb -P binutils ^
-P cmake ^
-P vim ^
-P git -P git-completion -P git-gui -P gitk ^
-P cscope ^
-P ctags ^
-P python -P python3 ^
-P inetutils ^
-P curl ^
-P patch

rd /s /q %INSTALL_DIR%\tmp

copy %CMDER_ROOT%\config\vimrc.orig %CMDER_ROOT%\vendor\cygwin\etc\vimrc
copy %CMDER_ROOT%\config\taglist_46\plugin\taglist.vim %CMDER_ROOT%\vendor\cygwin\usr\share\vim\vim81\plugin\taglist.vim
copy %CMDER_ROOT%\config\taglist_46\doc\taglist.txt %CMDER_ROOT%\vendor\cygwin\usr\share\vim\vim81\doc\taglist.txt

echo "Success to install..."

:configend
pause
