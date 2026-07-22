@echo off
setlocal

cd /d C:\Users\SR\Desktop\demmo

:loop
echo.
echo ==========================================
echo   SR FASHION - RETAIL DADDY AUTO UPDATE
echo ==========================================
echo.

REM Remove stale Git lock if one exists
IF EXIST ".git\index.lock" (
    echo Removing old Git lock...
    del /f /q ".git\index.lock"
)

echo [%date% %time%] Exporting live stock from Retail Daddy...
echo.

node export-stock.js

IF ERRORLEVEL 1 (
    echo.
    echo ==========================================
    echo   EXPORT FAILED - NOTHING WILL BE PUSHED
    echo ==========================================
    echo Retrying in 30 seconds...
    timeout /t 30 /nobreak >nul
    goto loop
)

echo.
echo Export completed successfully.
echo Checking whether items.json changed...
echo.

REM Stage ONLY items.json.
REM Never use "git add ." here.
git add items.json

REM Check whether staged items.json actually changed
git diff --cached --quiet -- items.json

IF %ERRORLEVEL% EQU 0 (
    echo No stock changes detected.
    echo Nothing to commit or push.
    echo.
    echo Waiting 90 seconds...
    timeout /t 90 /nobreak >nul
    goto loop
)

echo Stock change detected.
echo Creating Git commit...
echo.

git commit -m "Auto Retail Daddy stock update"

IF ERRORLEVEL 1 (
    echo.
    echo GIT COMMIT FAILED.
    echo Retrying in 30 seconds...
    timeout /t 30 /nobreak >nul
    goto loop
)

echo.
echo Syncing latest GitHub changes...
echo.

REM Local branch is currently master, while GitHub branch is main.
REM Rebase this local branch onto origin/main.
git pull origin main --rebase

IF ERRORLEVEL 1 (
    echo.
    echo ==========================================
    echo   GIT PULL / REBASE FAILED
    echo ==========================================
    echo Auto push stopped to protect repository.
    echo Retrying in 30 seconds...
    timeout /t 30 /nobreak >nul
    goto loop
)

echo.
echo Pushing updated items.json to GitHub main...
echo.

git push origin HEAD:main

IF ERRORLEVEL 1 (
    echo.
    echo ==========================================
    echo   GIT PUSH FAILED
    echo ==========================================
    echo Retrying in 30 seconds...
    timeout /t 30 /nobreak >nul
    goto loop
)

echo.
echo ==========================================
echo   UPDATE COMPLETED SUCCESSFULLY
echo ==========================================
echo [%date% %time%]
echo.
echo Waiting 90 seconds before next update...

timeout /t 90 /nobreak >nul

goto loop