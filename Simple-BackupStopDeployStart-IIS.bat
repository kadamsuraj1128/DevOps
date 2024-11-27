@echo off
set BackupDestination=C:\inetpub\Backup\Backup
set SourceDestination=C:\inetpub\Source
set SolutionFilesDestination=C:\inetpub\wwwroot
set AppPoolName=DefaultAppPool

for /f "delims=" %%a in ('wmic OS Get localdatetime  ^| find "."') do set dt=%%a
set YYYY=%dt:~0,4%
set MM=%dt:~4,2%
set DD=%dt:~6,2%
set HH=%dt:~8,2%
set Min=%dt:~10,2%
set Sec=%dt:~12,2%

set stamp=%YYYY%.%MM%.%DD%_%HH%-%Min%-%Sec%

echo D|xcopy /s /y "%SolutionFilesDestination%" "%BackupDestination%-%stamp%"
echo"Backup Done"

"C:\Program Files\7-Zip\7z.exe" a -tzip "SolutionFilesDestination" "%BackupDestination%-%stamp%"

echo Stopping application pool: %AppPoolName%
%windir%\system32\inetsrv\appcmd stop apppool /apppool.name:%AppPoolName%

echo Application pool stopped.

cd /d "%SolutionFilesDestination%"
rmdir /s /q "%SolutionFilesDestination%"
echo"File delete"
echo

robocopy %SourceDestination% C:\inetpub\wwwroot /E /IS /MOVE /XD C:\inetpub\Source\Config /move /R:100 /W:60
robocopy C:\inetpub\Source\Config\uat-config C:\inetpub\wwwroot /E /IS /MOVE /XD C:\inetpub\Source\Config\prod-config /move /R:100 /W:60

echo Folder copied successfully!

::echo Starting application pool: %AppPoolName%
%windir%\system32\inetsrv\appcmd Start apppool /apppool.name:%AppPoolName%
 
echo Application pool started.

pause