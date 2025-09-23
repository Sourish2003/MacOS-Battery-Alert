#!/bin/bash

# MacOS Battery Alert - One-Command Web Installer
# Downloads and installs automatically - no manual steps needed!
# Usage: curl -sSL https://raw.githubusercontent.com/Sourish2003/MacOS-Battery-Alert/main/web-install.sh | bash

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Configuration
REPO_URL="https://github.com/Sourish2003/MacOS-Battery-Alert"
REPO_ZIP="$REPO_URL/archive/refs/heads/main.zip"
TEMP_DIR="/tmp/battery-alert-install-$(date +%s)"
PROJECT_NAME="MacOS-Battery-Alert-main"

# Clear screen and show banner
clear
echo -e "${BLUE}${BOLD}"
echo "🔋 MacOS Battery Alert - One-Command Installer"
echo "=============================================="
echo -e "${NC}"
echo -e "${GREEN}Professional battery monitoring for macOS${NC}"
echo -e "${GREEN}• Free & Open Source • Zero Performance Impact • Smart Notifications${NC}"
echo

# Check macOS version
OS_VERSION=$(sw_vers -productVersion)
MAJOR_VERSION=$(echo $OS_VERSION | cut -d. -f1)

if [ "$MAJOR_VERSION" -lt 12 ]; then
    echo -e "${RED}❌ Error: This requires macOS 12 (Monterey) or later.${NC}"
    echo -e "   Your version: macOS $OS_VERSION"
    echo
    echo "Please upgrade your macOS to use Battery Alert."
    exit 1
fi

echo -e "${GREEN}✅ macOS $OS_VERSION - Compatible!${NC}"
echo

# Check for required tools
echo "🔍 Checking system requirements..."
command -v curl >/dev/null 2>&1 || { echo -e "${RED}❌ curl is required but not installed.${NC}"; exit 1; }
command -v unzip >/dev/null 2>&1 || { echo -e "${RED}❌ unzip is required but not installed.${NC}"; exit 1; }
command -v osascript >/dev/null 2>&1 || { echo -e "${RED}❌ osascript is required but not installed.${NC}"; exit 1; }

echo -e "${GREEN}✅ All requirements met!${NC}"
echo

# Confirm installation
echo -e "${YELLOW}📋 This installer will:${NC}"
echo "   • Download latest MacOS Battery Alert"
echo "   • Install and compile the application"  
echo "   • Set up background monitoring service"
echo "   • Configure system integration"
echo "   • Test notifications with sound"
echo
read -p "Continue with installation? (Y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Nn]$ ]]; then
    echo "Installation cancelled by user."
    exit 0
fi

# Create temporary directory
echo "📁 Creating temporary directory..."
mkdir -p "$TEMP_DIR"
cd "$TEMP_DIR"

# Download latest version
echo "⬇️  Downloading latest Battery Alert..."
echo -e "${BLUE}   Source: $REPO_URL${NC}"

if ! curl -L --progress-bar "$REPO_ZIP" -o "battery-alert.zip"; then
    echo -e "${RED}❌ Failed to download Battery Alert${NC}"
    echo "Please check your internet connection and try again."
    rm -rf "$TEMP_DIR"
    exit 1
fi

echo -e "${GREEN}✅ Download complete!${NC}"

# Extract
echo "📦 Extracting files..."
if ! unzip -q "battery-alert.zip"; then
    echo -e "${RED}❌ Failed to extract files${NC}"
    rm -rf "$TEMP_DIR"
    exit 1
fi

# Navigate to project directory
if [ ! -d "$PROJECT_NAME" ]; then
    echo -e "${RED}❌ Project directory not found after extraction${NC}"
    echo "Expected: $PROJECT_NAME"
    ls -la
    rm -rf "$TEMP_DIR"
    exit 1
fi

cd "$PROJECT_NAME"

# Verify essential files
if [ ! -f "install.sh" ]; then
    echo -e "${RED}❌ Installation script not found${NC}"
    rm -rf "$TEMP_DIR"
    exit 1
fi

if [ ! -f "scripts/batteryAlert.applescript" ]; then
    echo -e "${RED}❌ AppleScript source not found${NC}"
    rm -rf "$TEMP_DIR"
    exit 1
fi

echo -e "${GREEN}✅ Files extracted successfully!${NC}"

# Make installer executable
chmod +x install.sh
chmod +x uninstall.sh 2>/dev/null || true

echo
echo -e "${BLUE}🚀 Starting installation process...${NC}"
echo "   (The installer will handle compilation and system integration)"
echo

# Run the main installer
if ! ./install.sh; then
    echo
    echo -e "${RED}❌ Installation failed${NC}"
    echo "Please check the error messages above and try again."
    echo
    echo "Manual installation alternative:"
    echo "1. Download: $REPO_URL"
    echo "2. Extract and run: ./install.sh"
    
    # Cleanup
    cd /
    rm -rf "$TEMP_DIR"
    exit 1
fi

# Installation successful
echo
echo -e "${GREEN}${BOLD}🎉 Installation Complete!${NC}"
echo
echo -e "${BLUE}Battery Alert is now active and monitoring your battery!${NC}"
echo
echo -e "${YELLOW}What happens next:${NC}"
echo "• 🔋 Low battery alerts at 20% (with sound)"
echo "• 🔌 Optimal charge alerts at 80% (with sound)"
echo "• 🚀 Automatic startup with macOS"
echo "• 📱 Shows as 'Battery Alert' in Login Items"
echo
echo -e "${BLUE}Quick verification:${NC}"
echo "• Check Activity Monitor → 'Battery Alert' should appear"
echo "• Check System Settings → Login Items → 'Battery Alert'"
echo "• Plug/unplug charger near 20% or 80% to test alerts"
echo

# Sound troubleshooting prompt
echo -e "${YELLOW}🔊 Heard the test sounds during installation?${NC}"
read -p "   (Y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Nn]$ ]]; then
    echo
    echo -e "${BLUE}📖 Sound Troubleshooting:${NC}"
    echo "1. System Settings → Sound → Sound Effects → 'Play user interface sound effects' ✅"
    echo "2. System Settings → Notifications → Battery Alert → Allow Notifications ✅" 
    echo "3. Turn off Focus/Do Not Disturb if enabled"
    echo
    echo "📋 Complete guide: $(pwd)/docs/SOUND_TROUBLESHOOTING.md"
    echo "🧪 Test command: osascript -e 'display notification \"Test!\" with title \"Test\" sound name \"Glass\"'"
fi

echo
echo -e "${BLUE}Useful commands:${NC}"
echo "• Uninstall: $(pwd)/uninstall.sh"
echo "• Customize: Edit $(pwd)/scripts/batteryAlert.applescript then reinstall"
echo "• Logs: tail -f ~/Library/Logs/BatteryAlert.out"
echo

# Cleanup temporary files
echo "🧹 Cleaning up temporary files..."
cd /
rm -rf "$TEMP_DIR"

echo
echo -e "${GREEN}${BOLD}✨ Enjoy professional battery management for free! 🔋${NC}"
echo
echo -e "${BLUE}Like this project? Star it on GitHub: $REPO_URL${NC}"
echo