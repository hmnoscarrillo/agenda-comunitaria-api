@echo off
title API Agenda Comunitaria + MariaDB
echo.
echo ============================================
echo   API Node.js + Express + MySQL (agenda_comunitaria)
echo ============================================
echo.

rem Load local, untracked settings from .env
if not exist "%~dp0.env" (
  echo ERROR: No existe .env. Copia .env.example y configura la base local.
  goto end
)
for /f "usebackq tokens=1,* delims==" %%A in ("%~dp0.env") do set "%%A=%%B"

rem --- 1) MariaDB (puerto 3306) ---
netstat -an | findstr ":3306" | findstr "LISTENING" > nul
if not errorlevel 1 goto db_ok
echo [1/2] Arrancando MariaDB (puerto 3306)...
if not exist "%MARIADB_BIN_DIR%\mariadbd.exe" (
  echo ERROR: Configura MARIADB_BIN_DIR en .env.
  goto end
)
if not exist "%MARIADB_DATA_DIR%" (
  echo ERROR: Configura MARIADB_DATA_DIR en .env.
  goto end
)
start "MariaDB" /min "%MARIADB_BIN_DIR%\mariadbd.exe" --datadir="%MARIADB_DATA_DIR%" --port=3306 --bind-address=127.0.0.1 --console
timeout /t 4 /nobreak > nul
goto db_done
:db_ok
echo [1/2] MariaDB ya esta corriendo (puerto 3306).
:db_done

rem --- 2) API (puerto 3000) ---
netstat -an | findstr ":3000" | findstr "LISTENING" > nul
if not errorlevel 1 goto api_ok
echo [2/2] Arrancando la API (http://localhost:3000)...
echo.
start "API Node" /min cmd /c "cd /d "%~dp0" ^&^& node index.js"
goto end
:api_ok
echo [2/2] La API ya esta corriendo (puerto 3000).
echo       Abre http://localhost:3000/api/eventos
echo.
:end
