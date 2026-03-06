@echo off
setlocal enabledelayedexpansion
cd /d "%~dp0"

:: Verifier si le port 5000 est deja utilise (port par defaut de flutter web)
netstat -ano | findstr ":5000 " | findstr "LISTENING" >nul 2>&1
if %errorlevel%==0 (
    echo Le frontend tourne deja sur le port 5000.
    set /p confirm="Voulez-vous le redemarrer ? (O/N) : "
    if /i "!confirm!"=="O" (
        echo Arret du processus sur le port 5000...
        for /f "tokens=5" %%p in ('netstat -ano ^| findstr ":5000 " ^| findstr "LISTENING"') do (
            taskkill /PID %%p /F >nul 2>&1
        )
        timeout /t 2 /nobreak >nul
        echo Ancien processus arrete.
    ) else (
        echo Abandon.
        pause
        exit /b
    )
)

echo Lancement du frontend Flutter web...
flutter run -d chrome --web-port=5000
pause
