@echo off
echo ==========================================
echo Syncing project to https://github.com/Headshot1128/Auth
echo ==========================================
cd /d "%~dp0"
set "GIT_EXE=C:\Program Files\Microsoft Visual Studio\18\Community\Common7\IDE\CommonExtensions\Microsoft\TeamFoundation\Team Explorer\Git\cmd\git.exe"

"%GIT_EXE%" -c safe.directory=* add -A
"%GIT_EXE%" -c safe.directory=* commit -m "Update site assets" >nul 2>&1
"%GIT_EXE%" -c safe.directory=* push origin main

echo.
echo All done! Render will automatically deploy your updates in 1-2 minutes.
pause
