echo.
echo Syncing with GitHub...

git pull origin main --rebase

git add .
git commit -m "Auto stock update"

git push origin main