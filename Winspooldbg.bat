@echo off
setlocal enabledelayedexpansion
color 0A
title Printer Troubleshooting and Management Tool

REM --- Check for Administrator Privileges ---
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo This script must be run as an administrator.
    echo Prompting for elevated privileges...
    pause
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:menu
echo ==============================================
echo   Printer Troubleshooting and Management Menu
echo ==============================================
echo [1] Resolve Spooler Issues (Stop/Clear/Restart)
echo [2] List and Remove a Specific Printer
echo [3] Fix 0x0000011b Network Printing Error
echo [Q] Quit
echo.
set /p choice=Your selection (1/2/3/Q): 
if /i "%choice%"=="1" goto fixit
if /i "%choice%"=="2" goto removeprinter
if /i "%choice%"=="3" goto fixerror0x0000011b
if /i "%choice%"=="Q" goto end
echo Invalid selection!
echo.
goto menu

:fixit
echo Stopping the Print Spooler service...
net stop spooler

echo Terminating printfilterpipelinesvc.exe if running...
taskkill.exe /f /im printfilterpipelinesvc.exe >nul 2>&1

echo Clearing print queues...
del /F /Q %systemroot%\System32\spool\PRINTERS\* >nul 2>&1
del /F /Q %systemroot%\System32\spool\SERVERS\* >nul 2>&1

echo Restarting the Print Spooler service...
net start spooler

echo Spooler issues resolved successfully.
echo.
pause
goto menu

:removeprinter
cls
echo Retrieving installed printers...
echo This may take a moment.
echo.

set cnt=1
set keyBase3=HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Print\Environments\Windows x64\Drivers\Version-3
set keyBase4=HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Print\Environments\Windows x64\Drivers\Version-4

echo [Printers under Version-3:]
for /f "skip=2 delims=" %%A in ('reg query "%keyBase3%"') do (
    echo %%A | findstr /I "HKEY_" >nul
    if not errorlevel 1 (
        set printer_!cnt!=%%A
        echo !cnt!. %%A
        set /a cnt+=1
    )
)

echo.
echo [Printers under Version-4:]
for /f "skip=2 delims=" %%A in ('reg query "%keyBase4%"') do (
    echo %%A | findstr /I "HKEY_" >nul
    if not errorlevel 1 (
        set printer_!cnt!=%%A
        echo !cnt!. %%A
        set /a cnt+=1
    )
)

if %cnt%==1 (
    echo No printers found.
    pause
    goto menu
)

echo.
set /p prnSel=Enter the number of the printer you want to remove: 
if "%prnSel%"=="" (
    echo Invalid selection!
    pause
    goto menu
)

set selectedPrinter=!printer_%prnSel%!

if "!selectedPrinter!"=="" (
    echo Invalid selection!
    pause
    goto menu
)

echo You selected:
echo !selectedPrinter!
echo Are you sure you want to remove this printer? [Y/N]
set /p confirm=:
if /i "%confirm%"=="Y" (
    echo Removing the selected printer...
    reg delete "!selectedPrinter!" /f
    echo Removal complete.
) else (
    echo Operation canceled.
)

echo.
pause
goto menu

:fixerror0x0000011b
cls
echo Applying fix for 0x0000011b network printing error...
echo Creating/Setting RpcAuthnLevelPrivacyEnabled to 0...
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Print" /v RpcAuthnLevelPrivacyEnabled /t REG_DWORD /d 0 /f

echo Restarting the Print Spooler service...
net stop spooler
net start spooler

echo The fix for 0x0000011b has been applied.
echo.
pause
goto menu

:end
echo Exiting the program...
endlocal
