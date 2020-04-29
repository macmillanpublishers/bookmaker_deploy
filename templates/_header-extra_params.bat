@echo off
rem strip single quotes, parentheses, exclamation pts, and extra periods from filenames
for %%a in (%1) do (set init_fname=%%~nxa)
for %%a in (%1) do (set filepath=%%~dpa)
set name_test=%init_fname:!=%
Setlocal EnableDelayedExpansion
set name_test=!name_test:'=!
set name_test=!name_test:^(=!
set name_test=!name_test:^)=!
for %%a in ("!name_test!") do (set basename=%%~na)
for %%a in (!name_test!) do (set extension=%%~xa)
set basename=%basename:.=%
set "newname=!basename!%extension%"
Setlocal DisableDelayedExpansion
if NOT "%newname%" == "%init_fname%" (
echo "bad characters found, renaming file"
ren %1 "%newname%"
set "infile=""%filepath%%newname%"""
Setlocal EnableDelayedExpansion
set "infile=!infile:""="!"
) else (set infile=%1)

rem get project name for log directory
set INPUT=%infile%
for %%f in (%INPUT%) do set currfolder=%%~dpf
set LOGDIR1=%currfolder:~0,-1%
for %%f in ("%LOGDIR1%") do set logfolder=%%~dpf
set logfolder1=%logfolder:~0,-1%
for %%f in ("%logfolder1%") do set projectfolder=%%~nxf

REM set stdout/stderr logfile path
set base_logfolder="S:\bookmaker_logs"
if not exist "%base_logfolder%" mkdir "%base_logfolder%"
set logfolder="%base_logfolder%\%projectfolder%"
if not exist "%logfolder%" mkdir "%logfolder%"
for %%a in (%infile%) do for %%b in ("%%~dpa\.") do set "inputdirname=%%~nxb"
set logfile="%logfolder%\%inputdirname%-stdout-and-err.txt"

REM setup processlog paths
if not exist "S:\resources\logs\processLogs" mkdir "S:\resources\logs\processLogs"
For /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set mydate=%%c-%%a-%%b)
For /f "tokens=1-2 delims=/:" %%a in ("%TIME%") do (set mytime=%%a%%b)
set p_log="S:\resources\logs\processLogs\%basename%_%mydate%-%mytime%_%projectfolder%.txt"
set p_log_tmp="S:\resources\logs\processLogs\%basename%_%mydate%-%mytime%_%projectfolder%Tmp.txt"

rem write scriptnames to file for ProcessLogger to rm on success:
(
