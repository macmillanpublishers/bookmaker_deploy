@echo off
set logfile="S:\resources\logs\%~n1-stdout-and-err.txt"
if not exist "S:\resources\logs\processLogs" mkdir "S:\resources\logs\processLogs"
For /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set mydate=%%c-%%a-%%b)
For /f "tokens=1-2 delims=/:" %%a in ("%TIME%") do (set mytime=%%a%%b)
set p_log="S:\resources\logs\processLogs\%~n1_%mydate%-%mytime%_swoon.txt"
set p_log_tmp="S:\resources\logs\processLogs\%~n1_%mydate%-%mytime%_swoonTmp.txt"

rem write scriptnames to file for ProcessLogger to rm on success:
(
	echo tmparchive
	echo htmlmaker
	echo metadata_preprocessing
	echo htmlmaker_postprocessing
	echo filearchive
	echo filearchive_postprocessing
	echo cleanup
	echo mail-alert
) >%p_log%

@echo on
@echo %date% %time% >> %logfile% 2>&1

start /b PowerShell -NoProfile -ExecutionPolicy Bypass -Command "S:\resources\bookmaker_scripts\utilities\processwatch.ps1 %p_log% '%1'"
SLEEP 10
C:\Ruby193\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker\core\tmparchive\tmparchive.rb '%1' >> %logfile% 2>&1 && call :ProcessLogger tmparchive
C:\Ruby193\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker\core\htmlmaker\htmlmaker.rb '%1' >> %logfile% 2>&1 && call :ProcessLogger htmlmaker
C:\Ruby193\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker_addons\metadata_preprocessing.rb '%1' >> %logfile% 2>&1 && call :ProcessLogger metadata_preprocessing
C:\Ruby193\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker_addons\htmlmaker_postprocessing.rb '%1' >> %logfile% 2>&1 && call :ProcessLogger htmlmaker_postprocessing
C:\Ruby193\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker\core\filearchive\filearchive.rb '%1' >> %logfile% 2>&1 && call :ProcessLogger filearchive
C:\Ruby193\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker_addons\filearchive_postprocessing.rb '%1' >> %logfile% 2>&1 && call :ProcessLogger filearchive_postprocessing
C:\Ruby193\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker\core\cleanup\cleanup.rb '%1' >> %logfile% 2>&1 && call :ProcessLogger cleanup
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "S:\resources\bookmaker_scripts\utilities\mail-alert.ps1 '%1'" && call :ProcessLogger mail-alert

goto:eof
rem ************  Function *************
:ProcessLogger
set input=%1
findstr /v %1 %p_log% > %p_log_tmp%
move /Y %p_log_tmp% %p_log%
goto :eof
