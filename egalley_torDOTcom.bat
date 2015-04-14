C:\Ruby193\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker_tmparchive\tmparchive.rb %1
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "S:\resources\bookmaker_scripts\WordXML-to-HTML\DocxToXml.ps1 '%1'"
C:\Ruby193\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker_htmlmaker\htmlmaker.rb %1
C:\Ruby193\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker_filearchive\filearchive.rb %1
SET SSL_CERT_FILE=C:\Ruby193\lib\ruby\site_ruby\1.9.1\rubygems\ssl_certs\cacert.pem
C:\Ruby193\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker_covermaker.rb %1
C:\Ruby193\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker_coverchecker\coverchecker.rb %1
C:\Ruby193\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker_imagechecker\imagechecker.rb %1
C:\Ruby193\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker_chapterheads\chapterheads.rb %1
SET SSL_CERT_FILE=C:\Ruby193\lib\ruby\site_ruby\1.9.1\rubygems\ssl_certs\cacert.pem
C:\Ruby193\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker_pdfmaker\pdfmaker.rb %1
C:\Ruby193\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker_epubmaker\epubmaker.rb %1
C:\Ruby193\bin\ruby.exe S:\resources\bookmaker_scripts\bookmaker_cleanup\cleanup.rb %1