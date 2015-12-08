@echo off
set logfile="S:\resources\logs\%~n1-stdout-and-err.txt"
if not exist "S:\resources\logs\processLogs" mkdir "S:\resources\logs\processLogs"
For /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set mydate=%%c-%%a-%%b)
For /f "tokens=1-2 delims=/:" %%a in ("%TIME%") do (set mytime=%%a%%b)
set p_log="S:\resources\logs\processLogs\%~n1_%mydate%-%mytime%_torDOTcomFinal.txt"
set p_log_tmp="S:\resources\logs\processLogs\%~n1_%mydate%-%mytime%_torDOTcomFinalTmp.txt"

rem write scriptnames to file for ProcessLogger to rm on success:
(
  echo tmparchive
  echo htmlmaker_preprocessing
  echo htmlmaker
  echo cacert
  echo titlepage
  echo metadata_preprocessing
  echo htmlmaker_postprocessing
  echo filearchive
  echo filearchive_postprocessing
  echo imagechecker
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

start /b PowerShell -NoProfile -ExecutionPolicy Bypass -Command "S:\resources\bookmaker_scripts\utilities\processwatch.ps1 %p_log% '%1'"
C:\Ruby193\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker\core\tmparchive\tmparchive.rb '%1' >> %logfile% 2>&1 && call :ProcessLogger tmparchive
C:\Ruby193\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker_addons\htmlmaker_preprocessing.rb '%1' >> %logfile% 2>&1 && call :ProcessLogger htmlmaker_preprocessing
C:\Ruby193\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker\core\htmlmaker\htmlmaker.rb '%1' >> %logfile% 2>&1 && call :ProcessLogger htmlmaker
SET SSL_CERT_FILE=C:\Ruby193\lib\ruby\site_ruby\1.9.1\rubygems\ssl_certs\cacert.pem >> %logfile% 2>&1 && call :ProcessLogger cacert
C:\Ruby193\bin\ruby.exe S:\resources\bookmaker_scripts\covermaker\bookmaker_titlepage.rb '%1' >> %logfile% 2>&1 && call :ProcessLogger titlepage
C:\Ruby193\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker_addons\metadata_preprocessing.rb '%1' >> %logfile% 2>&1 && call :ProcessLogger metadata_preprocessing
C:\Ruby193\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker_addons\htmlmaker_postprocessing.rb '%1' >> %logfile% 2>&1 && call :ProcessLogger htmlmaker_postprocessing
C:\Ruby193\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker\core\filearchive\filearchive.rb '%1' >> %logfile% 2>&1 && call :ProcessLogger filearchive
C:\Ruby193\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker_addons\filearchive_postprocessing.rb '%1' >> %logfile% 2>&1 && call :ProcessLogger filearchive_postprocessing
C:\Ruby193\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker\core\imagechecker\imagechecker.rb '%1' >> %logfile% 2>&1 && call :ProcessLogger imagechecker
SET SSL_CERT_FILE=C:\Ruby193\lib\ruby\site_ruby\1.9.1\rubygems\ssl_certs\cacert.pem >> %logfile% 2>&1 && call :ProcessLogger cacert
C:\Ruby193\bin\ruby.exe S:\resources\bookmaker_scripts\covermaker\bookmaker_covermaker.rb '%1' >> %logfile% 2>&1 && call :ProcessLogger covermaker
C:\Ruby193\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker\core\coverchecker\coverchecker.rb '%1' >> %logfile% 2>&1 && call :ProcessLogger coverchecker
C:\Ruby193\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker_addons\stylesheets_preprocessing.rb '%1' >> %logfile% 2>&1 && call :ProcessLogger stylesheets_preprocessing
C:\Ruby193\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker\core\stylesheets\stylesheets.rb '%1' >> %logfile% 2>&1 && call :ProcessLogger stylesheets
C:\Ruby193\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker_addons\stylesheets_postprocessing.rb '%1' >> %logfile% 2>&1 && call :ProcessLogger stylesheets_postprocessing
C:\Ruby193\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker_addons\pdfmaker_preprocessing.rb '%1' >> %logfile% 2>&1 && call :ProcessLogger pdfmaker_preprocessing
SET SSL_CERT_FILE=C:\Ruby193\lib\ruby\site_ruby\1.9.1\rubygems\ssl_certs\cacert.pem >> %logfile% 2>&1 && call :ProcessLogger cacert
C:\Ruby193\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker\core\pdfmaker\pdfmaker.rb '%1' >> %logfile% 2>&1 && call :ProcessLogger pdfmaker
C:\Ruby193\bin\ruby.exe S:\resources\bookmaker_scripts\pitstop_watch\torDOTcom_pitstop_input.rb '%1' >> %logfile% 2>&1 && call :ProcessLogger torDOTcom_pitstop_input
C:\Ruby193\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker_addons\epubmaker_preprocessing.rb '%1' >> %logfile% 2>&1 && call :ProcessLogger epubmaker_preprocessing
C:\Ruby193\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker\core\epubmaker\epubmaker.rb '%1' >> %logfile% 2>&1 && call :ProcessLogger epubmaker
C:\Ruby193\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker_addons\epubmaker_postprocessing.rb '%1' >> %logfile% 2>&1 && call :ProcessLogger epubmaker_postprocessing
C:\Ruby193\bin\ruby.exe S:\resources\bookmaker_scripts\pitstop_watch\torDOTcom_pitstop_output.rb '%1' >> %logfile% 2>&1 && call :ProcessLogger torDOTcom_pitstop_output
C:\Ruby193\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker_addons\cleanup_preprocessing.rb '%1' >> %logfile% 2>&1 && call :ProcessLogger cleanup_preprocessing
C:\Ruby193\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker\core\cleanup\cleanup.rb '%1' >> %logfile% 2>&1 && call :ProcessLogger cleanup
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "S:\resources\bookmaker_scripts\utilities\mail-alert.ps1 '%1'" && call :ProcessLogger mail-alert


goto:eof
rem ************  Function *************
:ProcessLogger
set input=%1
findstr /v %1 %p_log% > %p_log_tmp%
move /Y %p_log_tmp% %p_log%
goto :eof
