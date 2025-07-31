@echo off
REM Change to the directory where this script is located
cd /d "%~dp0"

echo ========================================
echo    Exo Windows Setup Script
echo ========================================
echo.
echo Script location: %~dp0
echo Current directory: %CD%
echo.

REM Check if essential files exist
echo Checking essential files...
if not exist "requirements-windows.txt" (
    echo ERROR: requirements-windows.txt not found!
    echo Please ensure you are running this script from the exo-for-windows-main folder
    echo Current directory: %CD%
    pause
    exit /b 1
)
if not exist "exo" (
    echo ERROR: exo directory not found!
    echo Please ensure you have the complete exo application files
    pause
    exit /b 1
)
echo ✅ All essential files found
echo.

REM Check if Python is installed
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Python is not installed or not in PATH
    echo Please install Python 3.10+ from https://python.org
    pause
    exit /b 1
)

echo [1/6] Creating Python virtual environment...
if exist venv (
    echo Virtual environment already exists, removing old one...
    rmdir /s /q venv
)
echo Creating virtual environment without pip (Python 3.13 compatibility)...
python -m venv venv --without-pip
if %errorlevel% neq 0 (
    echo ERROR: Failed to create virtual environment
    pause
    exit /b 1
)

echo [2/6] Activating virtual environment...
call venv\Scripts\activate.bat

echo [3/6] Installing and upgrading pip...
echo Installing pip in virtual environment...
python -m ensurepip --upgrade
if %errorlevel% neq 0 (
    echo WARNING: Failed to install pip with ensurepip, trying alternative method...
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
    python get-pip.py
    del get-pip.py
)
echo Upgrading pip to latest version...
python -m pip install --upgrade pip

echo [4/6] Installing numpy with pre-compiled wheel (Python 3.13 compatibility)...
pip install numpy==2.3.2 --only-binary=numpy
if %errorlevel% neq 0 (
    echo ERROR: Failed to install numpy
    pause
    exit /b 1
)

echo [5/6] Installing remaining Windows-specific dependencies...
if not exist "requirements-windows.txt" (
    echo ERROR: requirements-windows.txt not found in current directory
    echo Please ensure you are running this script from the exo-for-windows-main folder
    echo Current directory: %CD%
    pause
    exit /b 1
)
pip install -r requirements-windows.txt
if %errorlevel% neq 0 (
    echo ERROR: Failed to install dependencies
    pause
    exit /b 1
)

echo [6/7] Installing pywin32 for Windows GPU detection...
python -m pip install pywin32
if %errorlevel% neq 0 (
    echo ERROR: Failed to install pywin32
    pause
    exit /b 1
)

echo [7/7] Installing pynvml for NVIDIA GPU detection...
python -m pip install pynvml
if %errorlevel% neq 0 (
    echo ERROR: Failed to install pynvml
    pause
    exit /b 1
)

echo [8/8] Configuring Windows Defender firewall for UDP discovery...
echo Adding firewall rules for UDP ports 5678 and 52415...
netsh advfirewall firewall delete rule name="Exo UDP 5678" >nul 2>&1
netsh advfirewall firewall delete rule name="Exo UDP 52415" >nul 2>&1
netsh advfirewall firewall delete rule name="Exo UDP 5678 Out" >nul 2>&1
netsh advfirewall firewall delete rule name="Exo UDP 52415 Out" >nul 2>&1

netsh advfirewall firewall add rule name="Exo UDP 5678" dir=in action=allow protocol=UDP localport=5678
netsh advfirewall firewall add rule name="Exo UDP 52415" dir=in action=allow protocol=UDP localport=52415
netsh advfirewall firewall add rule name="Exo UDP 5678 Out" dir=out action=allow protocol=UDP localport=5678
netsh advfirewall firewall add rule name="Exo UDP 52415 Out" dir=out action=allow protocol=UDP localport=52415

if %errorlevel% neq 0 (
    echo WARNING: Failed to configure firewall rules. You may need to run as Administrator.
    echo You can manually add firewall rules for UDP ports 5678 and 52415.
)

echo.
echo ========================================
echo    Setup completed successfully!
echo ========================================
echo.
echo To start the application, run: run-windows.bat
echo Or manually: venv\Scripts\activate.bat && python -m exo.main
echo.
echo For device discovery to work properly, ensure:
echo 1. Firewall allows UDP ports 5678 and 52415
echo 2. All devices are on the same network
echo 3. Run this setup on each PC you want to use
echo.
pause
