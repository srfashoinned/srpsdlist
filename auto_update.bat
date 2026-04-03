@echo off

:loop
echo ===================================
echo   SR STOCK AUTO UPDATE STARTED
echo ===================================

cd /d C:\Users\SR\Desktop\demmo

echo.
echo Exporting stock from Busy...

sqlcmd -S DESKTOP-U5GLEE7 -U SA -P busy@123 -i query.sql -o stock.csv -s "," -W -h -1

IF %ERRORLEVEL% NEQ 0 (
    echo ❌ SQL ERROR
    timeout /t 30 >nul
    goto loop
)

echo.
echo Converting CSV to JSON...

node convert.js

IF %ERRORLEVEL% NEQ 0 (
    echo ❌ CONVERSION FAILED
    timeout /t 30 >nul
    goto loop
)

echo.
echo Syncing with GitHub...

:: STEP 1: ADD + COMMIT FIRST (IMPORTANT FIX)
git add .
git commit -m "Auto stock update"

:: STEP 2: PULL AFTER COMMIT
git pull origin main --rebase

IF %ERRORLEVEL% NEQ 0 (
    echo ❌ GIT PULL FAILED
    timeout /t 30 >nul
    goto loop
)

:: STEP 3: PUSH
git push origin main

IF %ERRORLEVEL% NEQ 0 (
    echo ❌ GIT PUSH FAILED
    timeout /t 30 >nul
    goto loop
)

echo.
echo ===================================
echo   ✅ UPDATE COMPLETED SUCCESSFULLY
echo ===================================

echo Waiting 110 seconds...
timeout /t 110 >nul

goto loop