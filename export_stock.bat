@echo off

echo Exporting BusyWin Stock Data...

sqlcmd -S DESKTOP-U5GLEE7 -U SA -P busy@123 -d BusyComp0002_db -i query.sql -o stock.csv -s "," -W

echo.
echo Export Completed.
echo File saved as stock.csv
pause