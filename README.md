# 🔋 MacOS Battery Alert

A **professional**, **free** battery monitoring solution for macOS that alerts you at 20% (low battery) and 80% (optimal charging limit) with **customizable sounds** and **zero performance impact**.

![macOS](https://img.shields.io/badge/macOS-12%2B-blue)
![License](https://img.shields.io/badge/license-MIT-green)
![Apple Silicon](https://img.shields.io/badge/Apple%20Silicon-✅-success)
![Intel](https://img.shields.io/badge/Intel-✅-success)

## ✨ Features

- 🔔 **Smart Notifications**: Visual + audio alerts at optimal battery levels
- ⚡ **Zero Lag**: Compiled AppleScript for maximum performance
- 🎵 **Customizable Sounds**: Choose from 13+ system sounds
- 🚀 **Professional Integration**: Shows as "Battery Alert" in system preferences
- 🛡️ **Spam Prevention**: Smart threshold detection prevents notification spam
- 📱 **Automatic Startup**: Runs silently in background, starts with macOS
- 🆓 **Completely Free**: No subscriptions, no data collection
- 🔓 **Open Source**: Full transparency, customize as needed

## 🚀 Quick Install

### One-Click Installation
```bash
# Download the latest release, unzip, then:
./install.sh
```

### From Source
```bash
git clone https://github.com/yourusername/MacOS-Battery-Alert.git
cd MacOS-Battery-Alert
chmod +x install.sh
./install.sh
```

**That's it!** The installer handles compilation, system integration, and setup.

## 📋 System Requirements

- ✅ **macOS 12 (Monterey)** or later
- ✅ **Intel** or **Apple Silicon** Macs
- ✅ **Admin privileges** for installation
- ✅ Any **MacBook** model (Air, Pro, etc.)

## 🔧 How It Works

### Intelligent Battery Monitoring
- **📱 On Battery Power**: Alerts when ≤ 20% - "Please connect charger" 
- **🔌 While Charging**: Alerts when ≥ 80% - "Consider unplugging to preserve battery health"
- **🧠 Smart Logic**: Only alerts when crossing thresholds (no spam!)
- **⚡ Performance**: Compiled script runs efficiently every 60 seconds

### Professional System Integration
- **📦 App Bundle**: Proper macOS app structure
- **🏷️ Clear Identification**: Shows as "Battery Alert by Sourish M" in Login Items
- **📊 Background Process**: Minimal system impact
- **🔒 Secure**: Uses only standard macOS APIs

## 🔊 Sound Troubleshooting

**Not hearing sounds?** Check our [Sound Troubleshooting Guide](docs/SOUND_TROUBLESHOOTING.md)

**Quick test:**
```bash
osascript -e 'display notification "Test sound!" with title "Sound Test" sound name "Glass"'
```

**Common fixes:**
1. System Settings → Sound → Sound Effects → "Play user interface sound effects" ✅
2. System Settings → Notifications → Battery Alert → Allow Notifications ✅
3. Turn off Do Not Disturb/Focus modes

## ⚙️ Customization

### Change Alert Percentages
Edit `scripts/batteryAlert.applescript` before installation:
```applescript
if batteryPercent ≤ 20 then  -- Change to your preferred low %
if batteryPercent ≥ 80 then  -- Change to your preferred high %
```

### Change Notification Sounds
Available sounds: `"Basso"`, `"Glass"`, `"Hero"`, `"Ping"`, `"Sosumi"`, `"Tink"` and more!

```applescript
sound name "Ping"   -- Low battery sound
sound name "Hero"   -- High battery sound  
```

**After changes, reinstall:**
```bash
./uninstall.sh && ./install.sh
```

## 🗑️ Uninstall

```bash
./uninstall.sh
```

Removes everything cleanly:
- ✅ Stops background service
- ✅ Removes app bundle  
- ✅ Clears login items
- ✅ Deletes all files
- ✅ Optional log cleanup

## 🏗️ Project Structure

```
MacOS-Battery-Alert/
├── 📋 README.md              # This file
├── ⚖️ LICENSE                # MIT License
├── 🚀 install.sh             # Smart installer
├── 🗑️ uninstall.sh           # Clean removal
├── 📁 scripts/
│   ├── 📜 batteryAlert.applescript  # Source code (human-readable)
│   └── ⚙️ batteryAlert.plist        # Launch agent template
├── 📁 docs/
│   └── 🔊 SOUND_TROUBLESHOOTING.md  # Sound fix guide
└── 📁 .github/
    └── workflows/
        └── 🔄 release.yml    # Auto-release system
```

## 🔧 Development

### The Smart Compilation Approach
- **📝 Source**: Human-readable `.applescript` files in repository
- **⚡ Runtime**: Auto-compiled to `.scpt` during installation for performance
- **🔄 Benefits**: Transparency + speed + easy version control

### Why This Approach Works
1. **GitHub Friendly**: Source code visible and searchable
2. **Performance Optimized**: Compiled scripts run instantly  
3. **Professional**: Proper app bundle structure
4. **User-Friendly**: Single-command installation

## 🐛 Troubleshooting

### Service Not Starting?
```bash
# Check if running:
launchctl list | grep batteryalert

# Check logs:
tail -f ~/Library/Logs/BatteryAlert.out
tail -f ~/Library/Logs/BatteryAlert.err
```

### Permission Issues?
```bash
# Fix permissions:
sudo chmod 755 /usr/local/bin/BatteryAlert.app/Contents/MacOS/BatteryAlert
```

### Testing Manually
```bash
# Test the app bundle directly:
/usr/local/bin/BatteryAlert.app/Contents/MacOS/BatteryAlert

# Test the compiled script:
osascript /usr/local/bin/batteryAlert.scpt
```

## 🤝 Contributing

1. **Fork** the repository
2. **Edit** `scripts/batteryAlert.applescript` (the source file)
3. **Test** with `./install.sh`
4. **Submit** a pull request

### Development Workflow
```bash
# Make changes to source
nano scripts/batteryAlert.applescript

# Test changes
./uninstall.sh && ./install.sh

# Test notification
# (plug/unplug charger or modify thresholds temporarily)
```

## 📊 Why Choose This Over Paid Apps?

| Feature | Battery Alert (Free) | Paid Apps ($10-20) |
|---------|---------------------|---------------------|
| 20%/80% Alerts | ✅ | ✅ |
| Custom Sounds | ✅ | ✅ |
| No Performance Impact | ✅ | ❓ |
| Open Source | ✅ | ❌ |
| No Data Collection | ✅ | ❓ |
| Professional Integration | ✅ | ✅ |
| Easy Customization | ✅ | ❌ |
| **Cost** | **FREE** | **$10-20** |

## 📚 Technical Details

- **Language**: AppleScript (compiled for performance)
- **Scheduling**: launchd (macOS native)
- **Permissions**: Notification access only
- **Battery API**: `pmset` (official macOS tool)
- **Resource Usage**: <1MB RAM, negligible CPU
- **Compatibility**: Universal (Intel + Apple Silicon)

## 📈 Version History

### v1.0.0 (Latest)
- ✅ Smart compilation system (transparency + performance)
- ✅ Professional app bundle integration  
- ✅ Enhanced sound troubleshooting
- ✅ Improved system identification
- ✅ Zero-spam notification logic
- ✅ Comprehensive uninstaller

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built with native macOS technologies
- Inspired by the community need for simple, reliable battery monitoring
- Thanks to all contributors and testers

---

**⭐ Found this useful? Please star the repository!**

**🐛 Issues?** [Report bugs here](../../issues) | **💡 Ideas?** [Start a discussion](../../discussions)

**🔋 Happy battery management! ✨**