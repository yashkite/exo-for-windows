@echo off
REM Change to the directory where this script is located
cd /d "%~dp0"

echo ========================================
echo    Starting Exo Application
echo ========================================
echo.

REM Check if virtual environment exists
if not exist venv (
    echo ERROR: Virtual environment not found!
    echo Please run setup-windows.bat first.
    pause
    exit /b 1
)

echo Activating virtual environment...
call venv\Scripts\activate.bat

echo Starting exo application...
echo.
echo Press Ctrl+C to stop the application
echo.
python -m exo.main

echo.
echo Application stopped.
pause
