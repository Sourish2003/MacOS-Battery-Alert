#!/bin/bash

# MacOS Battery Alert - Uninstall Script
# Completely removes battery monitoring from your system

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

# Stop and unload the service
if [ -f "$PLIST_PATH" ]; then
    echo "⏹️  Stopping battery monitoring service..."
    launchctl unload "$PLIST_PATH" 2>/dev/null || true
    echo "🗂️  Removing launch agent..."
    rm -f "$PLIST_PATH"
else
    echo -e "${YELLOW}⚠️  Launch agent not found (may already be removed)${NC}"
fi

# Remove the script file
if [ -f "$SCRIPT_PATH" ]; then
    echo "📜 Removing AppleScript..."
    sudo rm -f "$SCRIPT_PATH"
else
    echo -e "${YELLOW}⚠️  Script file not found (may already be removed)${NC}"
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

if launchctl list | grep -q "com.user.batteryalert"; then
    echo -e "${RED}❌ Service still appears to be loaded${NC}"
    REMOVED_SUCCESSFULLY=false
fi

if [ -f "$PLIST_PATH" ]; then
    echo -e "${RED}❌ Launch agent file still exists${NC}"
    REMOVED_SUCCESSFULLY=false
fi

if [ -f "$SCRIPT_PATH" ]; then
    echo -e "${RED}❌ Script file still exists${NC}"
    REMOVED_SUCCESSFULLY=false
fi

if $REMOVED_SUCCESSFULLY; then
    echo -e "${GREEN}✅ Battery Alert has been completely removed!${NC}"
    echo
    echo "All components have been successfully uninstalled:"
    echo "• Battery monitoring service stopped"
    echo "• Launch agent removed"
    echo "• Script files deleted"
    echo "• Application data cleaned up"
    echo
    echo -e "${BLUE}Thank you for using Battery Alert! 🔋${NC}"
else
    echo -e "${YELLOW}⚠️  Some components may not have been fully removed.${NC}"
    echo "You may need to manually check and remove remaining files."
    echo
    echo "Manual cleanup commands:"
    echo "launchctl unload ~/Library/LaunchAgents/com.user.batteryalert.plist"
    echo "rm ~/Library/LaunchAgents/com.user.batteryalert.plist"
    echo "sudo rm /usr/local/bin/batteryAlert.scpt"
fi

echo