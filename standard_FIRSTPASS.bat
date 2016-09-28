@echo off
rem strip out single quotes and extra periods from new files
Setlocal EnableDelayedExpansion
for %%a in (%1) do set init_fname=%%~nxa
for %%a in (%1) do set filepath=%%~dpa
set name_test=%init_fname:'=%
if "%name_test:~-4%" == ".doc" (
set basename=%name_test:~0,-4%
set ext=.doc)
if "%name_test:~-5%" == ".docx" (
set basename=%name_test:~0,-5%
set ext=.docx)
set basename=%basename:.=%
set "newname=%basename%%ext%"
if NOT "%newname%" == "%init_fname%" (
echo "bad characters found, renaming file"
ren %1 "%newname%"
set "infile=""%filepath%%newname%"""
set "infile=!infile:""="!"
) else (set infile=%1)

rem get folder names for logging directories
set INPUT=%infile%
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
set logfile="%logfolder%\bookmaker_logs\%logsubfolder%\%projectfolder%\%basename%-stdout-and-err.txt"
if not exist "S:\resources\logs\processLogs" mkdir "S:\resources\logs\processLogs"
For /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set mydate=%%c-%%a-%%b)
For /f "tokens=1-2 delims=/:" %%a in ("%TIME%") do (set mytime=%%a%%b)
set p_log="S:\resources\logs\processLogs\%basename%_%mydate%-%mytime%_torDOTcomFinal.txt"
set p_log_tmp="S:\resources\logs\processLogs\%basename%_%mydate%-%mytime%_torDOTcomFinalTmp.txt"
if exist "%logfolder%\bookmaker_logs\%logsubfolder%\%projectfolder%\%basename%-stdout-and-err.txt" move "%logfolder%\bookmaker_logs\%logsubfolder%\%projectfolder%\%basename%-stdout-and-err.txt" "%logfolder%\bookmaker_logs\%logsubfolder%\%projectfolder%\past\%basename%-stdout-and-err_ARCHIVED_%mydate%-%mytime%.txt"

rem write scriptnames to file for ProcessLogger to rm on success:
(
  echo tmparchive
  echo htmlmaker_preprocessing
  echo htmlmaker
  echo htmlmaker_postprocessing
  echo cacert
  echo titlepage
  echo metadata_preprocessing
  echo filearchive
  echo filearchive_postprocessing
  echo imagechecker
  echo imagechecker_postprocessing
  echo cacert
  echo covermaker
  echo coverchecker
  echo stylesheets_preprocessing
  echo stylesheets
  echo stylesheets_postprocessing
  echo pdfmaker_preprocessing
  echo cacert
  echo pdfmaker
  echo torDOTcom_pitstop_input
  echo epubmaker_preprocessing
  echo epubmaker
  echo epubmaker_postprocessing
  echo torDOTcom_pitstop_output
  echo cleanup_preprocessing
  echo cleanup
	echo mail-alert
	
) >%p_log%

@echo on
@echo %date% %time% >> %logfile% 2>&1

start /b PowerShell -NoProfile -ExecutionPolicy Bypass -Command "S:\resources\bookmaker_scripts\utilities\processwatch.ps1 %p_log% '%infile%'"
C:\Ruby200\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker\core\tmparchive\tmparchive.rb '%infile%' >> %logfile% 2>&1 && call :ProcessLogger tmparchive
C:\Ruby200\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker_addons\htmlmaker_preprocessing.rb '%infile%' >> %logfile% 2>&1 && call :ProcessLogger htmlmaker_preprocessing
C:\Ruby200\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker\core\htmlmaker\htmlmaker.rb '%infile%' >> %logfile% 2>&1 && call :ProcessLogger htmlmaker
C:\Ruby200\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker_addons\htmlmaker_postprocessing.rb '%infile%' >> %logfile% 2>&1 && call :ProcessLogger htmlmaker_postprocessing
SET SSL_CERT_FILE=C:\Ruby193\lib\ruby\site_ruby\1.9.1\rubygems\ssl_certs\cacert.pem >> %logfile% 2>&1 && call :ProcessLogger cacert
C:\Ruby200\bin\ruby.exe S:\resources\bookmaker_scripts\covermaker\bookmaker_titlepage.rb '%infile%' >> %logfile% 2>&1 && call :ProcessLogger titlepage
C:\Ruby200\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker_addons\metadata_preprocessing.rb '%infile%' >> %logfile% 2>&1 && call :ProcessLogger metadata_preprocessing
C:\Ruby200\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker\core\filearchive\filearchive.rb '%infile%' >> %logfile% 2>&1 && call :ProcessLogger filearchive
C:\Ruby200\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker_addons\filearchive_postprocessing.rb '%infile%' >> %logfile% 2>&1 && call :ProcessLogger filearchive_postprocessing
C:\Ruby200\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker\core\imagechecker\imagechecker.rb '%infile%' >> %logfile% 2>&1 && call :ProcessLogger imagechecker
C:\Ruby200\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker_addons\imagechecker_postprocessing.rb '%infile%' >> %logfile% 2>&1 && call :ProcessLogger imagechecker_postprocessing
SET SSL_CERT_FILE=C:\Ruby193\lib\ruby\site_ruby\1.9.1\rubygems\ssl_certs\cacert.pem >> %logfile% 2>&1 && call :ProcessLogger cacert
C:\Ruby200\bin\ruby.exe S:\resources\bookmaker_scripts\covermaker\bookmaker_covermaker.rb '%infile%' >> %logfile% 2>&1 && call :ProcessLogger covermaker
C:\Ruby200\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker\core\coverchecker\coverchecker.rb '%infile%' >> %logfile% 2>&1 && call :ProcessLogger coverchecker
C:\Ruby200\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker_addons\stylesheets_preprocessing.rb '%infile%' >> %logfile% 2>&1 && call :ProcessLogger stylesheets_preprocessing
C:\Ruby200\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker\core\stylesheets\stylesheets.rb '%infile%' >> %logfile% 2>&1 && call :ProcessLogger stylesheets
C:\Ruby200\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker_addons\stylesheets_postprocessing.rb '%infile%' >> %logfile% 2>&1 && call :ProcessLogger stylesheets_postprocessing
C:\Ruby200\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker_addons\pdfmaker_preprocessing.rb '%infile%' >> %logfile% 2>&1 && call :ProcessLogger pdfmaker_preprocessing
SET SSL_CERT_FILE=C:\Ruby193\lib\ruby\site_ruby\1.9.1\rubygems\ssl_certs\cacert.pem >> %logfile% 2>&1 && call :ProcessLogger cacert
C:\Ruby200\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker\core\pdfmaker\pdfmaker.rb '%infile%' >> %logfile% 2>&1 && call :ProcessLogger pdfmaker
C:\Ruby200\bin\ruby.exe S:\resources\bookmaker_scripts\pitstop_watch\torDOTcom_pitstop_input.rb '%infile%' >> %logfile% 2>&1 && call :ProcessLogger torDOTcom_pitstop_input
C:\Ruby200\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker_addons\epubmaker_preprocessing.rb '%infile%' >> %logfile% 2>&1 && call :ProcessLogger epubmaker_preprocessing
C:\Ruby200\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker\core\epubmaker\epubmaker.rb '%infile%' >> %logfile% 2>&1 && call :ProcessLogger epubmaker
C:\Ruby200\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker_addons\epubmaker_postprocessing.rb '%infile%' >> %logfile% 2>&1 && call :ProcessLogger epubmaker_postprocessing
C:\Ruby200\bin\ruby.exe S:\resources\bookmaker_scripts\pitstop_watch\torDOTcom_pitstop_output.rb '%infile%' >> %logfile% 2>&1 && call :ProcessLogger torDOTcom_pitstop_output
C:\Ruby200\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker_addons\cleanup_preprocessing.rb '%infile%' >> %logfile% 2>&1 && call :ProcessLogger cleanup_preprocessing
C:\Ruby200\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker\core\cleanup\cleanup.rb '%infile%' >> %logfile% 2>&1 && call :ProcessLogger cleanup
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "S:\resources\bookmaker_scripts\utilities\mail-alert.ps1 '%infile%'" && call :ProcessLogger mail-alert


goto:eof
rem ************  Function *************
:ProcessLogger
set input=%1
findstr /v %1 %p_log% > %p_log_tmp%
move /Y %p_log_tmp% %p_log%
goto :eof
