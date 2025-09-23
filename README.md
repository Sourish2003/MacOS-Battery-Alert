# 🔋 MacOS Battery Alert

A **professional**, **free** battery monitoring solution for macOS that alerts you at 20% (low battery) and 80% (optimal charging limit) with **customizable sounds** and **zero performance impact**.

![macOS](https://img.shields.io/badge/macOS-12%2B-blue)
![License](https://img.shields.io/badge/license-MIT-green)
![Apple Silicon](https://img.shields.io/badge/Apple%20Silicon-✅-success)
![Intel](https://img.shields.io/badge/Intel-✅-success)

## ✨ Features

- 🔔 **Smart Notifications**: Visual + audio alerts at optimal battery levels
- ⚡ **Zero Performance Impact**: Compiled AppleScript runs efficiently every 60 seconds
- 🎵 **Customizable Sounds**: Choose from 13+ system sounds
- 🚀 **Professional Integration**: Appears as "Battery Alert" in System Preferences
- 🛡️ **Smart Spam Prevention**: Only alerts when crossing thresholds
- 📱 **Automatic Startup**: Runs silently in background, starts with macOS
- 🆓 **Completely Free**: No subscriptions, no data collection, no network usage
- 🔓 **Open Source**: Full transparency, customize as needed

## 🚀 Installation

### **One-Command Installation** (Easiest)
```bash
curl -sSL https://raw.githubusercontent.com/Sourish2003/MacOS-Battery-Alert/main/web-install.sh | bash
```
*Downloads and installs automatically - no manual steps needed!*

### **Manual Installation**
1. **[Download Latest Release](../../releases/latest)**
2. **Double-click** the downloaded zip file to extract
3. **Open Terminal** and run:
   ```bash
   cd Downloads/MacOS-Battery-Alert-*
   chmod +x install.sh
   ./install.sh
   ```

### **From Source** (Developers)
```bash
git clone https://github.com/Sourish2003/MacOS-Battery-Alert.git
cd MacOS-Battery-Alert
chmod +x install.sh
./install.sh
```

**That's it!** The installer handles everything: compilation, app bundle creation, system integration, and testing.

## 📋 System Requirements

- ✅ **macOS 12 (Monterey)** or later
- ✅ **Intel** or **Apple Silicon** Macs
- ✅ **Admin privileges** for installation (one-time only)
- ✅ Any **MacBook** model (Air, Pro, etc.)

## 🔧 How It Works

### Intelligent Battery Monitoring
- **🔋 On Battery Power**: Alerts at ≤ 20% - *"Battery at X%. Please connect charger."*
- **🔌 While Charging**: Alerts at ≥ 80% - *"Battery reached 80%. Consider unplugging to preserve battery health."*
- **🧠 Smart Logic**: Only alerts when crossing thresholds (prevents notification spam)
- **⚡ High Performance**: Compiled AppleScript with 60-second monitoring interval

### Professional System Integration
- **📦 App Bundle Structure**: `/usr/local/bin/BatteryAlert.app` (proper macOS app)
- **🏷️ System Recognition**: Shows as "Battery Alert" in Login Items & Activity Monitor
- **📊 Background Process**: Low-priority background service with minimal resource usage
- **🔒 Secure & Private**: Only accesses battery status - no network, no data collection

## 🔊 Sound Troubleshooting

**Not hearing sounds?** Follow our [Complete Sound Troubleshooting Guide](docs/SOUND_TROUBLESHOOTING.md)

**Quick sound test:**
```bash
osascript -e 'display notification "Test sound!" with title "Sound Test" sound name "Glass"'
```

**Most common fix:** System Settings → Sound → Sound Effects → **"Play user interface sound effects"** ✅

## ⚙️ Customization

### Change Alert Percentages
Edit `scripts/batteryAlert.applescript` before installation:
```applescript
if batteryPercent ≤ 15 then  -- Change 20% to 15%
if batteryPercent ≥ 85 then  -- Change 80% to 85%
```

### Change Notification Sounds
Available sounds: `"Basso"`, `"Glass"`, `"Hero"`, `"Ping"`, `"Sosumi"`, `"Tink"` and more!

```applescript
sound name "Glass"   -- Low battery sound (instead of "Ping")
sound name "Sosumi"  -- High battery sound (instead of "Hero")
```

**Apply changes:**
```bash
./uninstall.sh && ./install.sh
```

## 🗑️ Uninstall

```bash
./uninstall.sh
```

Complete removal:
- ✅ Stops background service
- ✅ Removes app bundle and compiled script
- ✅ Clears launch agent and login items
- ✅ Deletes application data
- ✅ Optional log cleanup

## 🏗️ Project Structure

```
MacOS-Battery-Alert/
├── 📋 README.md                        # This documentation
├── ⚖️ LICENSE                          # MIT License
├── 🚀 install.sh                       # Smart installer with compilation
├── 🌐 web-install.sh                   # One-command web installer
├── 🗑️ uninstall.sh                     # Complete removal script
├── 📁 scripts/
│   ├── 📜 batteryAlert.applescript     # Source code (human-readable)
│   └── ⚙️ batteryAlert.plist           # Launch agent template
└── 📁 docs/
    └── 🔊 SOUND_TROUBLESHOOTING.md     # Complete sound fix guide
```

## 🔧 Technical Implementation

### The Smart Compilation Approach
Our innovative approach solves the source-vs-performance dilemma:

1. **📝 Development**: Human-readable `.applescript` source files stored in repository
2. **⚡ Installation**: Auto-compilation to binary `.scpt` for maximum performance  
3. **📦 System Integration**: Proper macOS app bundle with Info.plist metadata
4. **🔄 Benefits**: GitHub transparency + runtime speed + professional appearance

### Architecture
- **Language**: AppleScript (compiled for speed)
- **Scheduler**: launchd (macOS native process manager)
- **Battery API**: `pmset -g ps` (official macOS power management)
- **Notifications**: Native macOS notification center
- **Performance**: <1MB RAM, negligible CPU usage

### Runtime Files
- **App Bundle**: `/usr/local/bin/BatteryAlert.app/` (shows as "Battery Alert")
- **Compiled Script**: `/usr/local/bin/batteryAlert.scpt` (performance-optimized)
- **Launch Agent**: `~/Library/LaunchAgents/com.sourish.batteryalert.plist`
- **State Storage**: `~/Library/Application Support/BatteryAlert/`
- **Logs**: `~/Library/Logs/BatteryAlert.{out,err,log}`

## 🐛 Troubleshooting

### Service Not Running?
```bash
# Check if service is loaded:
launchctl list | grep batteryalert

# View logs:
tail -f ~/Library/Logs/BatteryAlert.out
tail -f ~/Library/Logs/BatteryAlert.err
```

### Test Manually
```bash
# Test app bundle:
/usr/local/bin/BatteryAlert.app/Contents/MacOS/BatteryAlert

# Test compiled script directly:
osascript /usr/local/bin/batteryAlert.scpt
```

### Permission Issues?
```bash
# Fix app bundle permissions:
sudo chmod 755 /usr/local/bin/BatteryAlert.app/Contents/MacOS/BatteryAlert
```

## 🤝 Contributing

1. **Fork** the repository
2. **Edit** `scripts/batteryAlert.applescript` (source code)
3. **Test** with `./install.sh`
4. **Submit** pull request

### Development Workflow
```bash
# Edit source code
nano scripts/batteryAlert.applescript

# Test changes
./uninstall.sh && ./install.sh

# Trigger test notifications by plugging/unplugging charger
```

## 📊 Comparison

| Feature | Battery Alert (Free) | Paid Apps ($10-20) |
|---------|---------------------|---------------------|
| 20%/80% Alerts | ✅ | ✅ |
| Custom Sounds | ✅ | ✅ |
| Zero Performance Impact | ✅ | ❓ |
| **Open Source** | **✅** | **❌** |
| **No Data Collection** | **✅** | **❓** |
| Professional Integration | ✅ | ✅ |
| Easy Customization | ✅ | ❌ |
| One-Command Install | ✅ | ❌ |
| **Cost** | **FREE** | **$10-20** |

## 📈 Version History

### v1.0.0 (Current)
- ✅ Smart compilation system (source transparency + runtime performance)
- ✅ Professional macOS app bundle integration
- ✅ Enhanced notification spam prevention
- ✅ Comprehensive sound troubleshooting documentation
- ✅ Complete installation and removal automation
- ✅ One-command web installer
- ✅ Professional system identification

## 📄 License

MIT License - see [LICENSE](LICENSE) file for complete terms.

## 🙏 Acknowledgments

- Built entirely with native macOS technologies
- Inspired by community need for reliable, free battery monitoring
- Thanks to all users who provided feedback and testing

---

**⭐ Found this useful? Please star the repository!**

**🐛 Issues?** [Report bugs here](../../issues) | **💡 Ideas?** [Start a discussion](../../discussions)

**🔋 Enjoy professional battery management for free! ✨**