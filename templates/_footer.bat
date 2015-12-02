PowerShell -NoProfile -ExecutionPolicy Bypass -Command "S:\resources\bookmaker_scripts\utilities\mail-alert.ps1 '%1'" && call :ProcessLogger mail-alert
REM STATUSHERE

goto:eof
rem ************  Function *************
:ProcessLogger
set input=%1
findstr /v %1 %p_log% > %p_log_tmp%
move /Y %p_log_tmp% %p_log%
goto :eof
