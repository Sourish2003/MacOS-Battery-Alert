#!/bin/bash

# MacOS Battery Alert - Smart Installation Script
# Compiles AppleScript during installation for best performance

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script paths
SOURCE_SCRIPT="scripts/batteryAlert.applescript"
COMPILED_SCRIPT="/usr/local/bin/batteryAlert.scpt"
PLIST_PATH="$HOME/Library/LaunchAgents/com.sourish.batteryalert.plist"
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

# Check if source file exists
if [ ! -f "$SOURCE_SCRIPT" ]; then
    echo -e "${RED}❌ Error: $SOURCE_SCRIPT not found${NC}"
    echo "Please make sure you're running this from the project root directory."
    exit 1
fi

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

# Compile AppleScript for optimal performance
echo "⚙️  Compiling AppleScript for optimal performance..."
TEMP_SCRIPT="/tmp/batteryAlert_temp.scpt"
if osacompile -o "$TEMP_SCRIPT" "$SOURCE_SCRIPT"; then
    echo -e "${GREEN}✅ Successfully compiled AppleScript!${NC}"
    
    # Move compiled script to final location with sudo
    echo "📦 Installing compiled script..."
    sudo mv "$TEMP_SCRIPT" "$COMPILED_SCRIPT"
    
    # Set proper permissions and ownership
    echo "🔐 Setting permissions..."
    sudo chmod 755 "$COMPILED_SCRIPT"
    sudo chown root:wheel "$COMPILED_SCRIPT"
else
    echo -e "${RED}❌ Failed to compile AppleScript${NC}"
    echo "Please check that scripts/batteryAlert.applescript exists and is valid."
    exit 1
fi

# Create app bundle structure for better identification
echo "📦 Creating app bundle for better system integration..."
APP_BUNDLE="/usr/local/bin/BatteryAlert.app"
sudo mkdir -p "$APP_BUNDLE/Contents/MacOS"
sudo mkdir -p "$APP_BUNDLE/Contents/Resources"

# Create Info.plist for the app bundle
sudo tee "$APP_BUNDLE/Contents/Info.plist" > /dev/null << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>BatteryAlert</string>
    <key>CFBundleIdentifier</key>
    <string>com.sourish.batteryalert</string>
    <key>CFBundleName</key>
    <string>Battery Alert</string>
    <key>CFBundleDisplayName</key>
    <string>Battery Alert</string>
    <key>CFBundleVersion</key>
    <string>1.0.0</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0.0</string>
    <key>CFBundleDevelopmentRegion</key>
    <string>en</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>LSUIElement</key>
    <true/>
    <key>LSBackgroundOnly</key>
    <true/>
</dict>
</plist>
EOF

# Create wrapper script
sudo tee "$APP_BUNDLE/Contents/MacOS/BatteryAlert" > /dev/null << 'EOF'
#!/bin/bash
exec /usr/bin/osascript /usr/local/bin/batteryAlert.scpt "$@"
EOF

sudo chmod +x "$APP_BUNDLE/Contents/MacOS/BatteryAlert"
sudo chown -R root:wheel "$APP_BUNDLE"

# Install plist with app bundle reference
echo "⚙️  Installing launch agent..."
if [ -f "scripts/batteryAlert.plist" ]; then
    # Create updated plist that uses our app bundle
    cat > "$PLIST_PATH" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.sourish.batteryalert</string>
    
    <key>ProgramArguments</key>
    <array>
        <string>/usr/local/bin/BatteryAlert.app/Contents/MacOS/BatteryAlert</string>
    </array>
    
    <key>StartInterval</key>
    <integer>60</integer>
    
    <key>KeepAlive</key>
    <false/>
    
    <key>RunAtLoad</key>
    <true/>
    
    <key>LimitLoadToSessionType</key>
    <string>Aqua</string>
    
    <key>StandardErrorPath</key>
    <string>/Users/$USER/Library/Logs/BatteryAlert.err</string>
    
    <key>StandardOutPath</key>
    <string>/Users/$USER/Library/Logs/BatteryAlert.out</string>
    
    <key>ProcessType</key>
    <string>Background</string>
    
    <key>LowPriorityIO</key>
    <true/>
    
    <key>Nice</key>
    <integer>1</integer>
</dict>
</plist>
EOF
else
    echo -e "${RED}❌ Error: batteryAlert.plist template not found${NC}"
    exit 1
fi

# Load the service
echo "🚀 Starting battery monitoring service..."
launchctl load "$PLIST_PATH"

# Wait a moment and check if it's running
sleep 2
if launchctl list | grep -q "com.sourish.batteryalert"; then
    echo -e "${GREEN}✅ Service loaded successfully!${NC}"
else
    echo -e "${YELLOW}⚠️  Service may not have started. Check logs if issues occur.${NC}"
fi

# Check and guide notification setup
echo
echo -e "${BLUE}🔔 Notification Setup${NC}"
echo "To receive battery alerts with sound, please ensure:"
echo "1. System Settings → Notifications → Battery Alert (enable notifications)"
echo "2. System Settings → Sound → Sound Effects (ensure system sounds are on)"
echo "3. Check Focus/Do Not Disturb is not blocking notifications"
echo

# Test notification with sound
echo "🧪 Testing notification system with sound..."
osascript -e 'display notification "🔋 Battery Alert is now active and ready!" with title "Installation Complete" sound name "Glass"'

# Additional sound test
echo "🔊 Testing specific alert sounds..."
osascript -e 'display notification "🔌 This is your 80% charging alert sound" with title "Test: Charging Alert" sound name "Hero"'
sleep 2
osascript -e 'display notification "⚠️ This is your 20% low battery sound" with title "Test: Low Battery Alert" sound name "Ping"'

echo
echo -e "${GREEN}🎉 Installation Complete!${NC}"
echo
echo -e "${BLUE}Battery Alert Features:${NC}"
echo "• ⚡ Compiled for optimal performance (no lag)"
echo "• 🔊 Sound alerts at 20% (low) and 80% (optimal charge)"
echo "• 🚀 Automatic startup with proper app identification"
echo "• 📱 Smart spam prevention"
echo "• 📊 Background monitoring every 60 seconds"
echo
echo -e "${BLUE}Files created:${NC}"
echo "• App Bundle: /usr/local/bin/BatteryAlert.app"
echo "• Compiled Script: $COMPILED_SCRIPT"
echo "• Launch Agent: $PLIST_PATH"
echo "• Logs: $LOG_DIR/BatteryAlert.{out,err}"
echo
echo -e "${BLUE}Next Steps:${NC}"
echo "1. If you heard the test sounds above, you're all set! 🎉"
echo "2. If no sound, check System Settings → Sound → Sound Effects"
echo "3. Check System Settings → Notifications for 'Battery Alert'"
echo "4. Your login items will now show 'Battery Alert' instead of 'osascript'"
echo
echo "To uninstall: ./uninstall.sh"
echo "To customize: Source code is in scripts/batteryAlert.applescript"
echo
echo -e "${BLUE}Enjoy your professional battery management! 🔋✨${NC}"