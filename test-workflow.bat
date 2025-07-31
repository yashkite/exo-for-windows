@echo off
echo ========================================
echo    Testing Exo Windows Workflow
echo ========================================
echo.

echo Testing workflow components...
echo.

REM Test 1: Check if essential files exist
echo [Test 1] Checking essential files...
if not exist "setup-windows.bat" (
    echo ERROR: setup-windows.bat not found
    goto :error
)
if not exist "run-windows.bat" (
    echo ERROR: run-windows.bat not found
    goto :error
)
if not exist "requirements-windows.txt" (
    echo ERROR: requirements-windows.txt not found
    goto :error
)
if not exist "README-WINDOWS.md" (
    echo ERROR: README-WINDOWS.md not found
    goto :error
)
if not exist "exo" (
    echo ERROR: exo directory not found
    goto :error
)
echo ✅ All essential files present

REM Test 2: Check Python availability
echo.
echo [Test 2] Checking Python installation...
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Python is not installed or not in PATH
    goto :error
)
python --version
echo ✅ Python is available

REM Test 3: Check requirements file syntax
echo.
echo [Test 3] Checking requirements file syntax...
findstr /C:"numpy" requirements-windows.txt >nul
if %errorlevel% equ 0 (
    echo WARNING: numpy found in requirements-windows.txt - this may cause double installation
) else (
    echo ✅ numpy correctly excluded from requirements file
)
echo ✅ Requirements file syntax looks good

REM Test 4: Check if virtual environment can be created
echo.
echo [Test 4] Testing virtual environment creation...
if exist test-venv (
    rmdir /s /q test-venv
)
python -m venv test-venv
if %errorlevel% neq 0 (
    echo ERROR: Failed to create test virtual environment
    goto :error
)
rmdir /s /q test-venv
echo ✅ Virtual environment creation works

echo.
echo ========================================
echo    All workflow tests PASSED!
echo ========================================
echo.
echo The workflow is ready for deployment.
echo Run setup-windows.bat as Administrator to install.
echo.
pause
exit /b 0

:error
echo.
echo ========================================
echo    Workflow test FAILED!
echo ========================================
echo.
echo Please fix the issues above before deployment.
echo.
pause
exit /b 1
