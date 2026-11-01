@echo off
setlocal enabledelayedexpansion
title Push to GitHub - Headshot1128/Auth

:: Runs ONLY when you double-click or run this file
cd /d "%~dp0"

echo ===================================================
echo             Uploading to GitHub...
echo        https://github.com/Headshot1128/Auth
echo ===================================================
echo.

:: 1. Locate Git executable
where git >nul 2>&1
if errorlevel 1 (
    for %%P in (
        "C:\Program Files\Microsoft Visual Studio\18\Community\Common7\IDE\CommonExtensions\Microsoft\TeamFoundation\Team Explorer\Git\cmd"
        "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\CommonExtensions\Microsoft\TeamFoundation\Team Explorer\Git\cmd"
        "C:\Program Files\Microsoft Visual Studio\2022\Professional\Common7\IDE\CommonExtensions\Microsoft\TeamFoundation\Team Explorer\Git\cmd"
        "C:\Program Files\Microsoft Visual Studio\2022\Enterprise\Common7\IDE\CommonExtensions\Microsoft\TeamFoundation\Team Explorer\Git\cmd"
        "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\IDE\CommonExtensions\Microsoft\TeamFoundation\Team Explorer\Git\cmd"
        "C:\Program Files\Git\cmd"
        "C:\Program Files (x86)\Git\cmd"
        "%LOCALAPPDATA%\Programs\Git\cmd"
    ) do (
        if exist "%%~P\git.exe" (
            set "PATH=%%~P;!PATH!"
        )
    )
)

where git >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Git could not be found!
    pause
    exit /b 1
)

:: 2. Fix directory ownership permissions
git config --global --add safe.directory "%CD%" >nul 2>&1
git config --global --add safe.directory "*" >nul 2>&1

:: 3. Ensure Git identity
git -c safe.directory=* config user.name >nul 2>&1
if errorlevel 1 (
    git -c safe.directory=* config --local user.name "Headshot1128"
    git -c safe.directory=* config --local user.email "Headshot1128@users.noreply.github.com"
)

:: 4. Ensure branch and remote are set
git -c safe.directory=* branch -M main >nul 2>&1
git -c safe.directory=* remote get-url origin >nul 2>&1
if errorlevel 1 (
    git -c safe.directory=* remote add origin https://github.com/Headshot1128/Auth.git
) else (
    git -c safe.directory=* remote set-url origin https://github.com/Headshot1128/Auth.git
)

:: 5. Stage, commit, and push immediately
echo [*] Adding all changes...
git -c safe.directory=* add -A

git -c safe.directory=* diff --cached --quiet
if errorlevel 1 (
    echo [*] Committing changes...
    git -c safe.directory=* commit -m "Manual upload" >nul
) else (
    echo [*] No new changes detected.
)

echo [*] Pushing to GitHub...
git -c safe.directory=* push -u origin main

if not errorlevel 1 (
    echo.
    echo ===================================================
    echo  SUCCESS: Project successfully uploaded to GitHub!
    echo ===================================================
) else (
    echo.
    echo ===================================================
    echo  Push failed. If prompted, please complete GitHub
    echo  login in the browser window.
    echo ===================================================
)

echo.
pause
