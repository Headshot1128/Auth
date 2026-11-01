@echo off
setlocal enabledelayedexpansion
title Upload to GitHub - Headshot1128/Auth

:: Always run in the directory of this batch file
cd /d "%~dp0"

echo ===================================================
echo             Upload to GitHub Repository
echo        https://github.com/Headshot1128/Auth
echo ===================================================
echo.

:: 1. Check if Git is in PATH, or find it in Visual Studio / standard directories
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
    echo [ERROR] Git could not be found on your system!
    echo.
    echo Please download and install Git from:
    echo https://git-scm.com/download/win
    echo Note: make sure to check "Add Git to PATH" during installation.
    echo.
    goto finish
)

echo [OK] Git found:
git --version
echo.

:: 2. Configure safe directory to prevent Windows Administrator ownership warnings
git config --global --add safe.directory "%CD%" >nul 2>&1
git config --global --add safe.directory "*" >nul 2>&1

:: 3. Initialize git repository if not already initialized
if not exist ".git" (
    echo [*] Initializing local Git repository...
    git -c safe.directory=* init
    git -c safe.directory=* branch -M main
    git -c safe.directory=* remote add origin https://github.com/Headshot1128/Auth.git
    echo.
) else (
    git -c safe.directory=* branch -M main >nul 2>&1
    git -c safe.directory=* remote get-url origin >nul 2>&1
    if errorlevel 1 (
        git -c safe.directory=* remote add origin https://github.com/Headshot1128/Auth.git
    ) else (
        git -c safe.directory=* remote set-url origin https://github.com/Headshot1128/Auth.git
    )
)

:: 4. Check / configure user identity
git -c safe.directory=* config user.name >nul 2>&1
if errorlevel 1 (
    git -c safe.directory=* config --local user.name "Headshot1128"
    git -c safe.directory=* config --local user.email "Headshot1128@users.noreply.github.com"
)

:: 5. Prompt user for commit message
set "COMMIT_MSG="
set /p "COMMIT_MSG=Enter commit message (Press Enter for default 'Auto update'): "
if "!COMMIT_MSG!"=="" set "COMMIT_MSG=Auto update: %date% %time%"

:: 6. Stage all files
echo.
echo [*] Staging files...
git -c safe.directory=* add -A

:: 7. Commit changes if there are staged differences
git -c safe.directory=* diff --cached --quiet
if errorlevel 1 (
    echo [*] Committing changes with message: "!COMMIT_MSG!"
    git -c safe.directory=* commit -m "!COMMIT_MSG!"
) else (
    echo [*] No new file changes to commit.
)

:: 8. Push to GitHub
echo.
echo [*] Pushing to GitHub (main branch)...
git -c safe.directory=* push -u origin main

if errorlevel 1 (
    echo.
    echo [!] Push failed. Checking if remote contains newer commits...
    echo [*] Attempting to pull and rebase...
    git -c safe.directory=* pull --rebase origin main
    if not errorlevel 1 (
        echo [*] Retrying push...
        git -c safe.directory=* push -u origin main
    )
)

if not errorlevel 1 (
    echo.
    echo ===================================================
    echo  SUCCESS: Code successfully uploaded to GitHub!
    echo ===================================================
) else (
    echo.
    echo ===================================================
    echo  Push encountered an issue.
    echo  Note: If this is your first time pushing to GitHub,
    echo  make sure you sign in when prompted, or verify you
    echo  have write permissions to the repository.
    echo ===================================================
)

:finish
echo.
pause
