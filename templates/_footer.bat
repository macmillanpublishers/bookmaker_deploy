PowerShell -NoProfile -ExecutionPolicy Bypass -Command "S:\resources\bookmaker_scripts\utilities\mail-alert.ps1 '%infile%'" && call :ProcessLogger mail-alert
REM STATUSHERE

goto:eof
rem ************  Function *************
:ProcessLogger
set input=%infile%
findstr /v %infile% %p_log% > %p_log_tmp%
move /Y %p_log_tmp% %p_log%
goto :eof
