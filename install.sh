#!/bin/bash

# MacOS Battery Alert - Installation Script
# This script automatically sets up battery monitoring on macOS

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script paths
SCRIPT_PATH="/usr/local/bin/batteryAlert.scpt"
PLIST_PATH="$HOME/Library/LaunchAgents/com.user.batteryalert.plist"
LOG_DIR="$HOME/Library/Logs"

echo -e "${BLUE}🔋 MacOS Battery Alert Installer${NC}"
echo "=================================="
echo

# Check macOS version
OS_VERSION=$(sw_vers -productVersion)
MAJOR_VERSION=$(echo $OS_VERSION | cut -d. -f1)

if [ "$MAJOR_VERSION" -lt 12 ]; then
    echo -e "${RED}❌ Error: This script requires macOS 12 (Monterey) or later.${NC}"
    echo -e "   Your version: macOS $OS_VERSION"
    exit 1
fi

echo -e "${GREEN}✅ macOS $OS_VERSION detected - Compatible!${NC}"
echo

# Check if already installed
if [ -f "$PLIST_PATH" ]; then
    echo -e "${YELLOW}⚠️  Battery Alert appears to be already installed.${NC}"
    read -p "Do you want to reinstall? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Installation cancelled."
        exit 0
    fi
    
    # Unload existing service
    echo "🔄 Unloading existing service..."
    launchctl unload "$PLIST_PATH" 2>/dev/null || true
fi

# Create necessary directories
echo "📁 Creating directories..."
sudo mkdir -p /usr/local/bin
mkdir -p "$HOME/Library/LaunchAgents"
mkdir -p "$LOG_DIR"
mkdir -p "$HOME/Library/Application Support/BatteryAlert"

# Copy AppleScript
echo "📝 Installing AppleScript..."
if [ -f "scripts/batteryAlert.scpt" ]; then
    sudo cp "scripts/batteryAlert.scpt" "$SCRIPT_PATH"
else
    echo -e "${RED}❌ Error: batteryAlert.scpt not found in scripts/ directory${NC}"
    echo "Please make sure you're running this from the project root directory."
    exit 1
fi

# Set permissions
sudo chmod +x "$SCRIPT_PATH"

# Install plist (replace %USER% placeholder)
echo "⚙️  Installing launch agent..."
if [ -f "scripts/batteryAlert.plist" ]; then
    sed "s/%USER%/$USER/g" "scripts/batteryAlert.plist" > "$PLIST_PATH"
else
    echo -e "${RED}❌ Error: batteryAlert.plist not found in scripts/ directory${NC}"
    exit 1
fi

# Load the service
echo "🚀 Starting battery monitoring service..."
launchctl load "$PLIST_PATH"

# Wait a moment and check if it's running
sleep 2
if launchctl list | grep -q "com.user.batteryalert"; then
    echo -e "${GREEN}✅ Service loaded successfully!${NC}"
else
    echo -e "${YELLOW}⚠️  Service may not have started. Check logs if issues occur.${NC}"
fi

# Check notification permissions
echo
echo -e "${BLUE}🔔 Notification Setup${NC}"
echo "To receive battery alerts, please ensure notifications are enabled:"
echo "1. Go to System Settings → Notifications"
echo "2. Find 'Script Editor' or 'osascript' in the list"
echo "3. Enable 'Allow Notifications'"
echo

# Test notification
echo "🧪 Testing notification system..."
osascript -e 'display notification "Battery Alert is now active! 🔋" with title "Installation Complete" sound name "Glass"'

echo
echo -e "${GREEN}🎉 Installation Complete!${NC}"
echo
echo "Battery Alert will now:"
echo "• Alert you at 20% battery (when unplugged)"
echo "• Alert you at 80% battery (when charging)"
echo "• Run automatically at startup"
echo
echo "Logs are saved to: $LOG_DIR/BatteryAlert.{out,err}"
echo
echo "To uninstall, run: ./uninstall.sh"
echo "To customize settings, edit: $SCRIPT_PATH"
echo
echo -e "${BLUE}Enjoy your optimized battery management! 🔋✨${NC}"