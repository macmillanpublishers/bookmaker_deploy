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
  echo tmparchive_direct
  echo htmlmaker_preprocessing
  echo htmlmaker
  echo htmlmaker_postprocessing
  echo titlepage
  echo metadata_preprocessing
  echo filearchive
  echo filearchive_postprocessing
  echo imagechecker
  echo imagechecker_postprocessing
  echo coverchecker
  echo stylesheets
  echo pdfmaker_preprocessing
  echo pdfmaker
  echo send_to_pitstop
  echo epubmaker_preprocessing
  echo epubmaker
  echo epubmaker_postprocessing
  echo get_pitstop_output
  echo cleanup_preprocessing
  echo bookmaker-direct_return
  echo bookmaker_mailer
  echo bookmaker_log_this_run
  echo cleanup
	echo mail-alert
	
) >%p_log%

@echo on
@echo %date% %time% >> %logfile% 2>&1

start /b PowerShell -NoProfile -ExecutionPolicy Bypass -Command "S:\resources\bookmaker_scripts\utilities\processwatch.ps1 %p_log% '%infile%'"
ruby S:\resources\bookmaker_scripts\bookmaker\core\tmparchive\tmparchive_direct.rb '%infile%' '%2' '%3' '%4' >> %logfile% 2>&1 && call :ProcessLogger tmparchive_direct
ruby S:\resources\bookmaker_scripts\bookmaker_addons\htmlmaker_preprocessing.rb '%infile%' '%2' '%3' '%4' >> %logfile% 2>&1 && call :ProcessLogger htmlmaker_preprocessing
ruby S:\resources\bookmaker_scripts\bookmaker\core\htmlmaker\htmlmaker.rb '%infile%' '%2' '%3' '%4' >> %logfile% 2>&1 && call :ProcessLogger htmlmaker
ruby S:\resources\bookmaker_scripts\bookmaker_addons\htmlmaker_postprocessing.rb '%infile%' '%2' '%3' '%4' >> %logfile% 2>&1 && call :ProcessLogger htmlmaker_postprocessing
ruby S:\resources\bookmaker_scripts\covermaker\bookmaker_titlepage.rb '%infile%' '%2' '%3' '%4' >> %logfile% 2>&1 && call :ProcessLogger titlepage
ruby S:\resources\bookmaker_scripts\bookmaker_addons\metadata_preprocessing.rb '%infile%' '%2' '%3' '%4' >> %logfile% 2>&1 && call :ProcessLogger metadata_preprocessing
ruby S:\resources\bookmaker_scripts\bookmaker\core\filearchive\filearchive.rb '%infile%' '%2' '%3' '%4' >> %logfile% 2>&1 && call :ProcessLogger filearchive
ruby S:\resources\bookmaker_scripts\bookmaker_addons\filearchive_postprocessing.rb '%infile%' '%2' '%3' '%4' >> %logfile% 2>&1 && call :ProcessLogger filearchive_postprocessing
ruby S:\resources\bookmaker_scripts\bookmaker\core\imagechecker\imagechecker.rb '%infile%' '%2' '%3' '%4' >> %logfile% 2>&1 && call :ProcessLogger imagechecker
ruby S:\resources\bookmaker_scripts\bookmaker_addons\imagechecker_postprocessing.rb '%infile%' '%2' '%3' '%4' >> %logfile% 2>&1 && call :ProcessLogger imagechecker_postprocessing
ruby S:\resources\bookmaker_scripts\bookmaker\core\coverchecker\coverchecker.rb '%infile%' '%2' '%3' '%4' >> %logfile% 2>&1 && call :ProcessLogger coverchecker
ruby S:\resources\bookmaker_scripts\bookmaker\core\stylesheets\stylesheets.rb '%infile%' '%2' '%3' '%4' >> %logfile% 2>&1 && call :ProcessLogger stylesheets
ruby S:\resources\bookmaker_scripts\bookmaker_addons\pdfmaker_preprocessing.rb '%infile%' '%2' '%3' '%4' >> %logfile% 2>&1 && call :ProcessLogger pdfmaker_preprocessing
ruby S:\resources\bookmaker_scripts\bookmaker\core\pdfmaker\pdfmaker.rb '%infile%' '%2' '%3' '%4' >> %logfile% 2>&1 && call :ProcessLogger pdfmaker
ruby S:\resources\bookmaker_scripts\pitstop_watch\send_to_pitstop.rb '%infile%' '%2' '%3' '%4' >> %logfile% 2>&1 && call :ProcessLogger send_to_pitstop
ruby S:\resources\bookmaker_scripts\bookmaker_addons\epubmaker_preprocessing.rb '%infile%' '%2' '%3' '%4' >> %logfile% 2>&1 && call :ProcessLogger epubmaker_preprocessing
ruby S:\resources\bookmaker_scripts\bookmaker\core\epubmaker\epubmaker.rb '%infile%' '%2' '%3' '%4' >> %logfile% 2>&1 && call :ProcessLogger epubmaker
ruby S:\resources\bookmaker_scripts\bookmaker_addons\epubmaker_postprocessing.rb '%infile%' '%2' '%3' '%4' >> %logfile% 2>&1 && call :ProcessLogger epubmaker_postprocessing
ruby S:\resources\bookmaker_scripts\pitstop_watch\get_pitstop_output.rb '%infile%' '%2' '%3' '%4' >> %logfile% 2>&1 && call :ProcessLogger get_pitstop_output
ruby S:\resources\bookmaker_scripts\bookmaker_addons\cleanup_preprocessing.rb '%infile%' '%2' '%3' '%4' >> %logfile% 2>&1 && call :ProcessLogger cleanup_preprocessing
ruby S:\resources\bookmaker_scripts\bookmaker_connectors\bookmaker-direct_return.rb '%infile%' '%2' '%3' '%4' >> %logfile% 2>&1 && call :ProcessLogger bookmaker-direct_return
ruby S:\resources\bookmaker_scripts\bookmaker_addons\bookmaker_mailer.rb '%infile%' '%2' '%3' '%4' >> %logfile% 2>&1 && call :ProcessLogger bookmaker_mailer
ruby S:\resources\bookmaker_scripts\bookmaker_connectors\bookmaker_log_this_run.rb '%infile%' '%2' '%3' '%4' >> %logfile% 2>&1 && call :ProcessLogger bookmaker_log_this_run
ruby S:\resources\bookmaker_scripts\bookmaker\core\cleanup\cleanup.rb '%infile%' '%2' '%3' '%4' >> %logfile% 2>&1 && call :ProcessLogger cleanup
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "S:\resources\bookmaker_scripts\utilities\mail-alert.ps1 '%infile%'" && call :ProcessLogger mail-alert


goto:eof
rem ************  Function *************
:ProcessLogger
set input=%1
findstr /v %1 %p_log% > %p_log_tmp%
move /Y %p_log_tmp% %p_log%
goto :eof
