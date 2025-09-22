#!/bin/bash

# MacOS Battery Alert - Smart Uninstall Script
# Completely removes battery monitoring and app bundle from your system

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# All possible file locations
APP_BUNDLE="/usr/local/bin/BatteryAlert.app"
COMPILED_SCRIPT="/usr/local/bin/batteryAlert.scpt"
OLD_SCRIPT="/usr/local/bin/batteryAlert.applescript"
PLIST_PATH="$HOME/Library/LaunchAgents/com.sourish.batteryalert.plist"
OLD_PLIST_PATH="$HOME/Library/LaunchAgents/com.user.batteryalert.plist"
LOG_DIR="$HOME/Library/Logs"
DATA_DIR="$HOME/Library/Application Support/BatteryAlert"

echo -e "${BLUE}🗑️  MacOS Battery Alert Uninstaller${NC}"
echo "===================================="
echo

# Confirm uninstallation
read -p "Are you sure you want to remove Battery Alert? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Uninstallation cancelled."
    exit 0
fi

echo "🔄 Removing Battery Alert..."

# Stop and unload the services (check both old and new plist locations)
SERVICE_STOPPED=false

if [ -f "$PLIST_PATH" ]; then
    echo "⏹️  Stopping battery monitoring service..."
    launchctl unload "$PLIST_PATH" 2>/dev/null || true
    echo "🗂️  Removing launch agent..."
    rm -f "$PLIST_PATH"
    SERVICE_STOPPED=true
fi

if [ -f "$OLD_PLIST_PATH" ]; then
    echo "⏹️  Stopping old battery monitoring service..."
    launchctl unload "$OLD_PLIST_PATH" 2>/dev/null || true
    echo "🗂️  Removing old launch agent..."
    rm -f "$OLD_PLIST_PATH"
    SERVICE_STOPPED=true
fi

if [ "$SERVICE_STOPPED" = false ]; then
    echo -e "${YELLOW}⚠️  No active services found (may already be removed)${NC}"
fi

# Remove app bundle (new installation method)
if [ -d "$APP_BUNDLE" ]; then
    echo "📦 Removing app bundle..."
    sudo rm -rf "$APP_BUNDLE"
fi

# Remove script files (various possible locations)
FILES_REMOVED=false

if [ -f "$COMPILED_SCRIPT" ]; then
    echo "📜 Removing compiled script..."
    sudo rm -f "$COMPILED_SCRIPT"
    FILES_REMOVED=true
fi

if [ -f "$OLD_SCRIPT" ]; then
    echo "📜 Removing old script file..."
    sudo rm -f "$OLD_SCRIPT"
    FILES_REMOVED=true
fi

if [ "$FILES_REMOVED" = false ]; then
    echo -e "${YELLOW}⚠️  No script files found (may already be removed)${NC}"
fi

# Remove data directory
if [ -d "$DATA_DIR" ]; then
    echo "📁 Removing application data..."
    rm -rf "$DATA_DIR"
fi

# Remove log files (optional)
echo
read -p "Do you want to remove log files? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🗂️  Removing log files..."
    rm -f "$LOG_DIR/BatteryAlert.out"
    rm -f "$LOG_DIR/BatteryAlert.err"
    rm -f "$LOG_DIR/BatteryAlert.log"
fi

# Verify removal
echo
echo "🔍 Verifying removal..."
sleep 1

REMOVED_SUCCESSFULLY=true

# Check for running services
if launchctl list | grep -q "batteryalert"; then
    echo -e "${RED}❌ Service still appears to be loaded${NC}"
    REMOVED_SUCCESSFULLY=false
fi

# Check for remaining files
REMAINING_FILES=()
[ -f "$PLIST_PATH" ] && REMAINING_FILES+=("Launch agent (new)")
[ -f "$OLD_PLIST_PATH" ] && REMAINING_FILES+=("Launch agent (old)")
[ -d "$APP_BUNDLE" ] && REMAINING_FILES+=("App bundle")
[ -f "$COMPILED_SCRIPT" ] && REMAINING_FILES+=("Compiled script")
[ -f "$OLD_SCRIPT" ] && REMAINING_FILES+=("Old script")

if [ ${#REMAINING_FILES[@]} -gt 0 ]; then
    echo -e "${RED}❌ Some files still exist:${NC}"
    for file in "${REMAINING_FILES[@]}"; do
        echo "  • $file"
    done
    REMOVED_SUCCESSFULLY=false
fi

if $REMOVED_SUCCESSFULLY; then
    echo -e "${GREEN}✅ Battery Alert has been completely removed!${NC}"
    echo
    echo "All components have been successfully uninstalled:"
    echo "• 🛑 Battery monitoring service stopped"
    echo "• 📦 App bundle removed"
    echo "• 🗂️  Launch agent removed"
    echo "• 📜 Script files deleted"
    echo "• 📁 Application data cleaned up"
    echo "• 🚀 Login items cleared"
    echo
    echo -e "${BLUE}Thank you for using Battery Alert! 🔋${NC}"
    echo
    echo "If you reinstall later, you'll get:"
    echo "• ⚡ Even better performance"
    echo "• 🎯 Better system integration"
    echo "• 🔊 Improved sound notifications"
else
    echo -e "${YELLOW}⚠️  Some components may not have been fully removed.${NC}"
    echo "You may need to manually check and remove remaining files."
    echo
    echo "Manual cleanup commands:"
    echo "launchctl unload ~/Library/LaunchAgents/com.*batteryalert.plist"
    echo "rm ~/Library/LaunchAgents/com.*batteryalert.plist"
    echo "sudo rm -rf /usr/local/bin/BatteryAlert.app"
    echo "sudo rm -f /usr/local/bin/batteryAlert.*"
fi

echo