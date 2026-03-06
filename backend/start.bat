@echo off
setlocal enabledelayedexpansion
cd /d "%~dp0"

:: Verifier si Docker est accessible
docker info >nul 2>&1
if %errorlevel% neq 0 (
    echo Docker n'est pas lance. Veuillez demarrer Docker Desktop et reessayer.
    pause
    exit /b
)

:: Verifier si les containers tournent deja
docker compose ps --status running 2>nul | findstr "questify" >nul 2>&1
if %errorlevel%==0 (
    echo Le backend tourne deja via Docker.
    set /p confirm="Voulez-vous le reconstruire et redemarrer ? (O/N) : "
    if /i "!confirm!"=="O" (
        echo Arret des containers...
        docker compose down
        echo Containers arretes.
    ) else (
        echo Abandon.
        pause
        exit /b
    )
)

echo Construction de l'image et lancement du backend...
docker compose up --build -d

if %errorlevel%==0 (
    echo.
    echo Backend demarre avec succes !
    echo Logs en temps reel (Ctrl+C pour quitter les logs) :
    echo.
    docker compose logs -f
) else (
    echo.
    echo Erreur lors du lancement du backend.
)

pause
