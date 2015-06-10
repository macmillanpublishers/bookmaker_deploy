@echo off
set logfile="S:\resources\logs\%~n1-stdout-and-err.txt"
@echo on

C:\Ruby193\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker\core\tmparchive\tmparchive.rb %1 >> %logfile% 2>&1
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "S:\resources\bookmaker_scripts\WordXML-to-HTML\DocxToXml.ps1 '%1'" >> %logfile% 2>&1
C:\Ruby193\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker\core\htmlmaker\htmlmaker.rb %1 >> %logfile% 2>&1
C:\Ruby193\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker_addons\metadata_preprocessing.rb %1 >> %logfile% 2>&1
C:\Ruby193\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker\core\filearchive\filearchive.rb %1 >> %logfile% 2>&1
SET SSL_CERT_FILE=C:\Ruby193\lib\ruby\site_ruby\1.9.1\rubygems\ssl_certs\cacert.pem >> %logfile% 2>&1
C:\Ruby193\bin\ruby.exe S:\resources\bookmaker_scripts\covermaker\bookmaker_covermaker.rb %1 >> %logfile% 2>&1
C:\Ruby193\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker\core\coverchecker\coverchecker.rb %1 >> %logfile% 2>&1
C:\Ruby193\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker\core\imagechecker\imagechecker.rb %1 >> %logfile% 2>&1
C:\Ruby193\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker\core\stylesheets\stylesheets.rb %1 >> %logfile% 2>&1
C:\Ruby193\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker_addons\stylesheets_postprocessing.rb %1 >> %logfile% 2>&1
C:\Ruby193\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker\core\epubmaker\epubmaker.rb %1 >> %logfile% 2>&1
C:\Ruby193\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker\core\cleanup\cleanup.rb %1 >> %logfile% 2>&1
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "S:\resources\bookmaker_scripts\utilities\mail-alert.ps1 '%1'"