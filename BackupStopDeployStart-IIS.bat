@echo off
set BackupDestination=C:\inetpub\Backup\Backup
set SourceDestination=C:\inetpub\Source
set SolutionFile=C:\inetpub\wwwroot
set AppPoolName=DefaultAppPool

for /f "delims=" %%a in ('wmic OS Get localdatetime  ^| find "."') do set dt=%%a
set YYYY=%dt:~0,4%
set MM=%dt:~4,2%
set DD=%dt:~6,2%
set HH=%dt:~8,2%
set Min=%dt:~10,2%
set Sec=%dt:~12,2%

set stamp=%YYYY%.%MM%.%DD%_%HH%-%Min%-%Sec%

echo D|xcopy /s /y "%SolutionFile%" "%BackupDestination%-%stamp%"
echo"Backup Done"

echo Stopping application pool: %AppPoolName%
%windir%\system32\inetsrv\appcmd stop apppool /apppool.name:%AppPoolName%

echo Application pool stopped.

cd /d "%SolutionFile%"
rmdir /s /q "%SolutionFile%"
echo"File delete"
echo

cd /d "%SourceDestination%"

:: Get the latest folder in the source directory
FOR /F "delims=" %%I IN ('DIR "%SourceDestination%" /AD /B /O-D') DO (
    SET "latestFolder=%%I"
    GOTO :found
)
 
:found
echo Latest folder is %latestFolder%
 
:: Copy the latest folder to the destination
xcopy "%SourceDestination%\%latestFolder%" "%SolutionFile%\%latestFolder%" /E /I /Y
 
echo Folder copied successfully!

::echo Starting application pool: %AppPoolName%
%windir%\system32\inetsrv\appcmd Start apppool /apppool.name:%AppPoolName%
 
echo Application pool started.

pause