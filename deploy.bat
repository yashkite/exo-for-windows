@echo off
echo ========================================
echo    Exo Windows Deployment Script
echo ========================================
echo.
echo This script will create a portable deployment package
echo that can be easily copied to multiple PCs.
echo.

REM Create deployment directory
set DEPLOY_DIR=exo-windows-portable
if exist %DEPLOY_DIR% (
    echo Removing existing deployment directory...
    rmdir /s /q %DEPLOY_DIR%
)

echo Creating deployment package...
mkdir %DEPLOY_DIR%

REM Copy essential files
echo Copying application files...
xcopy /E /I /H exo %DEPLOY_DIR%\exo
copy setup-windows.bat %DEPLOY_DIR%\
copy run-windows.bat %DEPLOY_DIR%\
copy requirements-windows.txt %DEPLOY_DIR%\
copy README-WINDOWS.md %DEPLOY_DIR%\
if exist LICENSE copy LICENSE %DEPLOY_DIR%\

REM Create a simple installer script for the package
echo Creating installer script...
echo @echo off > %DEPLOY_DIR%\INSTALL.bat
echo echo ======================================== >> %DEPLOY_DIR%\INSTALL.bat
echo echo    Exo Windows Quick Installer >> %DEPLOY_DIR%\INSTALL.bat
echo echo ======================================== >> %DEPLOY_DIR%\INSTALL.bat
echo echo. >> %DEPLOY_DIR%\INSTALL.bat
echo echo This will install Exo on this PC. >> %DEPLOY_DIR%\INSTALL.bat
echo echo Make sure you are running as Administrator! >> %DEPLOY_DIR%\INSTALL.bat
echo echo. >> %DEPLOY_DIR%\INSTALL.bat
echo pause >> %DEPLOY_DIR%\INSTALL.bat
echo call setup-windows.bat >> %DEPLOY_DIR%\INSTALL.bat

REM Create test script
echo Creating test script...
echo @echo off > %DEPLOY_DIR%\test-llama.bat
echo echo Testing with llama-3.2-1b model... >> %DEPLOY_DIR%\test-llama.bat
echo call venv\Scripts\activate.bat >> %DEPLOY_DIR%\test-llama.bat
echo python -m exo.main llama-3.2-1b "Hello, how are you?" >> %DEPLOY_DIR%\test-llama.bat
echo pause >> %DEPLOY_DIR%\test-llama.bat

echo.
echo ========================================
echo    Deployment package created!
echo ========================================
echo.
echo Package location: %DEPLOY_DIR%\
echo.
echo To deploy on other PCs:
echo 1. Copy the entire '%DEPLOY_DIR%' folder to target PC
echo 2. Run INSTALL.bat as Administrator
echo 3. Run run-windows.bat to start the application
echo.
echo Files included:
dir /b %DEPLOY_DIR%
echo.
pause
