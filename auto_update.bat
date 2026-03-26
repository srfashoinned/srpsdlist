@echo off
echo ===================================
echo   SR STOCK AUTO UPDATE STARTED
echo ===================================

cd /d C:\Users\SR\Desktop\demmo

echo.
echo 🔄 Exporting stock from Busy...

sqlcmd -S DESKTOP-U5GLEE7 -U SA -P busy@123 -i query.sql -o stock.csv -s "," -W -h -1

IF %ERRORLEVEL% NEQ 0 (
echo ❌ SQL ERROR - EXPORT FAILED
pause
exit /b
)

echo.
echo 🔄 Converting CSV to JSON...

node convert.js

IF %ERRORLEVEL% NEQ 0 (
echo ❌ CONVERSION FAILED
pause
exit /b
)

echo.
echo 🔄 Syncing with GitHub...

git pull origin main --rebase
git add .
git commit -m "Auto stock update"
git push

echo.
echo ===================================
echo   ✅ UPDATE COMPLETED SUCCESSFULLY
echo ===================================

pause
