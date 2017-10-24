@echo off
rem strip single quotes, parentheses, exclamation pts, and extra periods from filenames
REM for %%a in (%1) do (set init_fname=%%~nxa)
REM for %%a in (%1) do (set filepath=%%~dpa)
REM set name_test=%init_fname:!=%
REM Setlocal EnableDelayedExpansion
REM set name_test=!name_test:'=!
REM set name_test=!name_test:^(=!
REM set name_test=!name_test:^)=!
REM for %%a in ("!name_test!") do (set basename=%%~na)
REM for %%a in (!name_test!) do (set extension=%%~xa)
REM set basename=%basename:.=%
REM set "newname=!basename!%extension%"
REM Setlocal DisableDelayedExpansion
REM if NOT "%newname%" == "%init_fname%" (
REM echo "bad characters found, renaming file"
REM ren %1 "%newname%"
REM set "infile=""%filepath%%newname%"""
REM Setlocal EnableDelayedExpansion
REM set "infile=!infile:""="!"
REM ) else (set infile=%1)

rem get folder names for logging directories
REM set INPUT=%infile%
REM tester = "1.plaintest"
REM echo %test%


python S:\resources\bookmaker_scripts\sectionstart_converter\xml_docx_stylechecks\shared_utils\filenametest.py doubledoublequotes ""%1""
