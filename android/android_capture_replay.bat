@echo off

set curdir=%~dp0
cd /d %~dp0

adb remount


set /a n=0
setlocal enabledelayedexpansion
for /r %curdir%gfx %%i in (*.gfxr) do (
  echo !n!. %%~ni.gfxr
  set fileArray[!n!]=%%~ni.gfxr
  set /a n+=1
)


set /p num=Please Input the index of the file choosed by you:

adb push %curdir%gfx\!fileArray[%num%]! /sdcard/!fileArray[%num%]!

python scripts\gfxrecon.py replay /sdcard/!fileArray[%num%]!
