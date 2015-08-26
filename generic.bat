For /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set mydate=%%c-%%a-%%b)
For /f "tokens=1-2 delims=/:" %%a in ("%TIME%") do (set mytime=%%a%%b)
set p_log="S:\resources\logs\processLogs\%~n1_%mydate%-%mytime%_generic.txt"
set p_log_tmp="S:\resources\logs\processLogs\%~n1_%mydate%-%mytime%_genericTmp.txt"

rem write scriptnames to file for ProcessLogger to rm on success:
(
	echo tmparchive
	echo htmlmaker
	echo filearchive
	echo imagechecker
	echo coverchecker
	echo stylesheets
	echo cacert
	echo pdfmaker
	echo epubmaker
	echo cleanup
) >%p_log%

@echo on
@echo %date% %time% >> %logfile% 2>&1

start /b PowerShell -NoProfile -ExecutionPolicy Bypass -Command "S:\resources\bookmaker_scripts\utilities\processwatch.ps1 %p_log% '%1'"
SLEEP 10
C:\Ruby193\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker\core\tmparchive\tmparchive.rb '%1' >> %logfile% 2>&1 && call :ProcessLogger tmparchive
C:\Ruby193\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker\core\htmlmaker\htmlmaker.rb '%1' >> %logfile% 2>&1 && call :ProcessLogger htmlmaker
C:\Ruby193\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker\core\filearchive\filearchive.rb '%1' >> %logfile% 2>&1 && call :ProcessLogger filearchive
C:\Ruby193\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker\core\imagechecker\imagechecker.rb '%1' >> %logfile% 2>&1 && call :ProcessLogger imagechecker
C:\Ruby193\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker\core\coverchecker\coverchecker.rb '%1' >> %logfile% 2>&1 && call :ProcessLogger coverchecker
C:\Ruby193\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker\core\stylesheets\stylesheets.rb '%1' >> %logfile% 2>&1 && call :ProcessLogger stylesheets
SET SSL_CERT_FILE=C:\Ruby193\lib\ruby\site_ruby\1.9.1\rubygems\ssl_certs\cacert.pem >> %logfile% 2>&1 && call :ProcessLogger cacert
C:\Ruby193\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker\core\pdfmaker\pdfmaker.rb '%1' >> %logfile% 2>&1 && call :ProcessLogger pdfmaker
C:\Ruby193\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker\core\epubmaker\epubmaker.rb '%1' >> %logfile% 2>&1 && call :ProcessLogger epubmaker
C:\Ruby193\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker\core\cleanup\cleanup.rb '%1' >> %logfile% 2>&1 && call :ProcessLogger cleanup

goto:eof
rem ************  Function *************
:ProcessLogger
set input=%1
findstr /v %1 %p_log% > %p_log_tmp%
move /Y %p_log_tmp% %p_log%
goto :eof
