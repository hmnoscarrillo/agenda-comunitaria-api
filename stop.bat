@echo off
echo Deteniendo MariaDB...
if not exist "%~dp0.env" (
  echo ERROR: No existe .env.
  exit /b 1
)
for /f "usebackq tokens=1,* delims==" %%A in ("%~dp0.env") do set "%%A=%%B"
"%MARIADB_BIN_DIR%\mysqladmin.exe" -u root --host=127.0.0.1 --port=3306 shutdown
