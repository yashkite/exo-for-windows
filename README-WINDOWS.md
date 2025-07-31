# Exo Windows Installation Guide

This guide provides a portable installation solution for deploying Exo on multiple Windows PCs.

## Quick Start

### Prerequisites
- Windows 10/11
- Python 3.10+ installed from [python.org](https://python.org)
- Administrator privileges (for firewall configuration)

### Installation Steps

1. **Download/Copy Files**: Copy these 4 essential files to your target PC:
   - `setup-windows.bat`
   - `run-windows.bat` 
   - `requirements-windows.txt`
   - `exo/` folder (complete directory)

2. **Run Setup**: Right-click `setup-windows.bat` → "Run as administrator"
   - Creates Python virtual environment (Python 3.13 compatible)
   - Installs pip using ensurepip with fallback method
   - Installs numpy 2.3.2 using pre-compiled wheel
   - Installs all dependencies from requirements-windows.txt
   - Installs pywin32 for Windows GPU detection
   - Installs pynvml for NVIDIA GPU detection
   - Configures Windows Defender firewall for UDP ports 5678 and 52415

3. **Start Application**: Double-click `run-windows.bat`
   - Activates virtual environment
   - Starts Exo cluster node with device capabilities detection
   - Shows web interface at http://localhost:52415

✅ **Works from anywhere**: The scripts automatically change to the correct directory, so you can run them from File Explorer, Command Prompt, or PowerShell.

That's it! The setup script handles all dependencies and Windows compatibility issues automatically.

### Essential Files
- `setup-windows.bat` - One-time setup (run as Administrator)
- `run-windows.bat` - Start the application
- `requirements-windows.txt` - Windows-compatible dependencies
- `README-WINDOWS.md` - This guide

## What the Setup Does

### Automatic Dependency Resolution
- Creates isolated Python virtual environment
- Installs numpy==2.3.2 with pre-compiled wheels (Python 3.13 compatibility)
- Installs all required dependencies from `requirements-windows.txt`
- Installs pywin32 for Windows GPU detection support
- Configures Windows-specific event loop (winloop instead of uvloop)

### Windows Compatibility Fixes Applied
- ✅ Numpy compilation issues resolved
- ✅ Unix-specific modules (uvloop, resource) handled
- ✅ Tinygrad inference engine configured
- ✅ Firewall rules for UDP discovery ports

### Firewall Configuration
Automatically configures Windows Defender firewall rules for:
- UDP port 5678 (incoming/outgoing)
- UDP port 52415 (incoming/outgoing)

## Manual Installation (if needed)

If the automated script fails, you can install manually:

```batch
# Create virtual environment
python -m venv venv
venv\Scripts\activate.bat

# Install numpy first (important for Python 3.13)
pip install numpy==2.3.2 --only-binary=numpy

# Install other dependencies
pip install -r requirements-windows.txt

# Configure firewall manually
netsh advfirewall firewall add rule name="Exo UDP 5678" dir=in action=allow protocol=UDP localport=5678
netsh advfirewall firewall add rule name="Exo UDP 52415" dir=in action=allow protocol=UDP localport=52415
```

## Testing Device Discovery

1. **Start exo on multiple PCs** using `run-windows.bat`
2. **Check the cluster UI** - should show connected nodes
3. **Test with llama-3.2-1b model**:
   ```
   python -m exo.main llama-3.2-1b "Hello, how are you?"
   ```

## Troubleshooting

### Common Issues

1. **"Failed to create virtual environment"**
   - Ensure Python 3.10+ is installed and in PATH
   - Try running: `python --version`
   - Script uses `--without-pip` flag for Python 3.13 compatibility

2. **"Failed to install numpy"**
   - The script uses pre-compiled wheels (numpy==2.3.2) for Python 3.13 compatibility
   - If issues persist, try Python 3.11 or 3.12

3. **"Failed to configure firewall rules"**
   - Must run setup-windows.bat as Administrator
   - Check Windows Defender settings
   - Script automatically deletes old rules before adding new ones

4. **"ModuleNotFoundError: No module named 'pynvml'"**
   - This is automatically resolved in the updated setup script
   - pynvml is now installed during setup for NVIDIA GPU detection

5. **"TypeError: DeviceCapabilities not awaitable"**
   - This has been fixed in the updated code
   - The windows_device_capabilities function is now properly async

6. **"No devices discovered"**
   - Ensure all PCs are on the same network
   - Check firewall allows UDP ports 5678 and 52415
   - Try temporarily disabling Windows Defender firewall for testing

7. **Application crashes on startup**
   - Check if all dependencies installed correctly
   - Try running from Command Prompt to see error messages
   - Ensure pywin32 and pynvml are installed for GPU detection

8. **"ModuleNotFoundError: No module named 'numpy'"**
   - Solution: Run `setup-windows.bat` as Administrator

9. **"uvloop does not support Windows"**
   - This is fixed automatically by using winloop instead
   - If you see this error, the code modifications weren't applied

10. **Python 3.13 compilation errors**
    - The setup script uses pre-compiled wheels to avoid this
    - If you see compilation errors, ensure you're using the provided setup script

### New PC Deployment Issues

1. **"Failed to connect to existing cluster"**
   - Ensure all PCs are on the same network
   - Check firewall settings on new PC
   - Try restarting the application on all PCs

2. **"Device not detected on new PC"**
   - Ensure GPU drivers are up-to-date
   - Check if pywin32 and pynvml are installed
   - Try restarting the application

3. **"Firewall rules not applied on new PC"**
   - Run setup-windows.bat as Administrator on new PC
   - Check Windows Defender settings
   - Script automatically deletes old rules before adding new ones

## Performance Tips

- Use SSDs for better model loading performance
- Ensure adequate RAM (8GB+ recommended)
- Close unnecessary applications during inference

## Deployment on Multiple PCs

### For IT Administrators

1. **Prepare master copy**:
   - Run setup once on a reference machine
   - Test that everything works
   - Copy the entire folder (including venv) to other PCs

2. **Network deployment**:
   - Share the folder on network drive
   - Run `setup-windows.bat` on each target PC
   - Or copy the entire folder locally to each PC

3. **Automated deployment**:
   - Use Group Policy or deployment tools
   - Include firewall rule configuration
   - Test device discovery across the network

### Files to Include in Deployment Package

Essential files for portable deployment:
```
exo-for-windows-main/
├── setup-windows.bat          # Main setup script (run as Administrator)
├── run-windows.bat            # Application launcher
├── requirements-windows.txt   # Windows-compatible dependencies
├── README-WINDOWS.md         # This installation guide
└── exo/                      # Application source code
```

Note: The virtual environment (venv/) is created automatically by setup-windows.bat

## Support

If you encounter issues:
1. Check this README first
2. Ensure you're running as Administrator
3. Verify Python version compatibility (3.10+)
4. Check Windows Defender firewall settings
5. Test network connectivity between PCs

The application has been successfully tested on Windows 10/11 with Python 3.13.
