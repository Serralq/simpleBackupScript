@echo off
set sourceName=""
set sourcePath=""
set destinationPath=""

for %%I in (.) do echo %%~nxI> %cd%\dirNameTempFile.txt
set /p dirNames=<%cd%\dirNameTempFile.txt
del %cd%\dirNameTempFile.txt
@REM echo Directory Names is %dirNames%

set currDatetime=%date:~4,2%-%date:~7,2%-%date:~10,4%--%time:~3,2%-%time:~6,2%
@REM echo Current Datetime is %currDatetime%


FOR /F "delims=" %%i IN ('whoami') DO set useridTemp=%%i

set "userid=%useridTemp:~6,9%"
@REM echo Userid is %userid%

:flagLoop
if "%1" == "/help" goto :helpmenu
if "%1" == "/h" goto :helpmenu
if "%1" == "/s" goto :specifiedSource
if "%1" == "/d" goto :specifiedDestination
if "%1" == "/c" goto :configure
goto :flagEnd

:helpmenu
echo.
echo Backs up folders for you
echo.
echo BACKUP [/h] [/s] [/d] [/a]
echo If no flags are specified then a backup will be made of the current directory and place next in the same parent folder or preconfigured folder
echo    /h or /help Prints out the help menu
echo    /s          Specifies the source of the backup
echo    /d          Specifies the destination of the backup
echo    /c          Configure the destination for all future backups, or if left blank then delete configuration

goto :end

:specifiedSource
SHIFT
set sourcePath=%1
SHIFT
goto :flagLoop

:specifiedDestination
SHIFT
set destinationPath=%1
SHIFT
goto :flagLoop

:configure
SHIFT
if "%1" == "" (del C:\Users\%userid%\Documents\backupConfigurationFile.txt& echo Configuration deleted and no backups were made) else (echo %1>C:\Users\%userid%\Documents\backupConfigurationFile.txt& echo Configuration changed and no backups were made)
SHIFT
goto :death

:flagEnd

if %sourcePath% == "" (set sourceName=%dirNames%& set sourcePath=..\%dirNames%)
if NOT %sourcePath% == "" (for %%a in (%sourcePath:\= %) do set sourceName=%%a)
if %destinationPath% == "" (set destinationPath=..)
if exist C:\Users\%userid%\Documents\backupConfigurationFile.txt (set /p destinationPath=<C:\Users\%userid%\Documents\backupConfigurationFile.txt)
@REM xcopy %sourcePath%\%sourceName% %destinationPath%\%sourceName%%currDatetime% /E/H/C/I
echo From: %sourcePath% To: %destinationPath%\%sourceName%%currDatetime%

:end
echo.
echo "Backup process finished"
echo.

:death