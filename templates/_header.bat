@echo off

rem get folder names for logging directories
set INPUT=%1
for %%f in (%INPUT%) do set currfolder=%%~dpf
set LOGDIR1=%currfolder:~0,-1%
for %%f in ("%LOGDIR1%") do set logfolder=%%~dpf
set logfolder1=%logfolder:~0,-1%
for %%f in ("%logfolder1%") do set projectfolder=%%~nxf
for %%f in ("%logfolder1%") do set logfolder2=%%~dpf
set logfolder3=%logfolder2:~0,-1%
for %%f in ("%logfolder3%") do set logsubfolder=%%~nxf
for %%f in ("%logfolder3%") do set logfolder=%%~dpf
set logfolder=%logfolder:~0,-1%

if not exist "%logfolder%\bookmaker_logs\%logsubfolder%" mkdir "%logfolder%\bookmaker_logs\%logsubfolder%"
if not exist "%logfolder%\bookmaker_logs\%logsubfolder%\%projectfolder%" mkdir "%logfolder%\bookmaker_logs\%logsubfolder%\%projectfolder%"
if not exist "%logfolder%\bookmaker_logs\%logsubfolder%\%projectfolder%\past" mkdir "%logfolder%\bookmaker_logs\%logsubfolder%\%projectfolder%\past"
set logfile="%logfolder%\bookmaker_logs\%logsubfolder%\%projectfolder%\%~n1-stdout-and-err.txt"
if not exist "S:\resources\logs\processLogs" mkdir "S:\resources\logs\processLogs"
For /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set mydate=%%c-%%a-%%b)
For /f "tokens=1-2 delims=/:" %%a in ("%TIME%") do (set mytime=%%a%%b)
set p_log="S:\resources\logs\processLogs\%~n1_%mydate%-%mytime%_torDOTcomFinal.txt"
set p_log_tmp="S:\resources\logs\processLogs\%~n1_%mydate%-%mytime%_torDOTcomFinalTmp.txt"
if exist "%logfolder%\bookmaker_logs\%logsubfolder%\%projectfolder%\%~n1-stdout-and-err.txt" move "%logfolder%\bookmaker_logs\%logsubfolder%\%projectfolder%\%~n1-stdout-and-err.txt" "%logfolder%\bookmaker_logs\%logsubfolder%\%projectfolder%\past\%~n1-stdout-and-err_ARCHIVED_%mydate%-%mytime%.txt"

rem write scriptnames to file for ProcessLogger to rm on success:
(