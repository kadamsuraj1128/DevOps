@echo off

set APPPOOL_NAME=DefaultAppPool
 
echo Stopping application pool: %APPPOOL_NAME%
%windir%\system32\inetsrv\appcmd stop apppool /apppool.name:%APPPOOL_NAME%
 
echo Application pool stopped.



pause