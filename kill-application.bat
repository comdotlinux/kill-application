@echo OFF
if NOT "%minimised%"=="" goto :MINIMISED
set minimised=true
start /min cmd /C "%~dpnx0"
goto :EOF
:MINIMISED
:: Anything after this line will run in a minimised window

::Script will sleep (MAXSLEEP * PINGTIME) seconds

set MAXSLEEP=20
set PINGTIME=2
set SLEEP=0
set PROG=firefox.exe

:: Check id 
for /F "TOKENS=1,2,*" %%a in ('tasklist /NH /FI "IMAGENAME eq %PROG%"') do set runningProg=%%a > nul
if NOT %runningProg%==%PROG% goto :EOF

echo "Killing %PROG%"
TASKKILL /T /FI "IMAGENAME eq %PROG%" > nul
:WHILE
	if NOT %SLEEP% EQU 0 echo "Been waiting..... for %SLEEP%"
	set /A SLEEP+=1
	ping -n %PINGTIME% 127.0.0.1 > nul

	for /F "TOKENS=1,2,*" %%a in ('tasklist /NH /FI "IMAGENAME eq %PROG%"') do set runningProg=%%a > nul
	if NOT %runningProg%==%PROG% goto :ENDWHILE

	if %SLEEP% GTR %MAXSLEEP% TASKKILL /T /F /FI "IMAGENAME eq %PROG%" > nul
	if %ERRORLEVEL% EQU 1 goto :ENDWHILE
	goto :WHILE
:ENDWHILE
