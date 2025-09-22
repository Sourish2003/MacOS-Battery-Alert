# 🔊 Sound Troubleshooting Guide

Got notifications but no sound? Here's how to fix it!

## Quick Sound Test

Run this command to test if notification sounds work at all:
```bash
osascript -e 'display notification "Test notification with sound!" with title "Sound Test" sound name "Glass"'
```

**If you hear a sound:** ✅ System is working, continue below
**If no sound:** ❌ Follow the steps below

## Step-by-Step Sound Fix

### 1. Check System Sound Settings
1. **System Settings** → **Sound** → **Sound Effects**
2. Make sure **"Play sound effects through"** is set to your speakers/headphones
3. Test the **Alert volume** slider - move it and you should hear a sample
4. Ensure **"Play user interface sound effects"** is ✅ **ON**

### 2. Check Notification Settings
1. **System Settings** → **Notifications**
2. Find **"Battery Alert"** or **"Script Editor"** in the left list
3. Make sure:
   - ✅ **Allow Notifications** is ON
   - ✅ **Sounds** is ON (if this option exists)
   - Set **Alert Style** to "Alerts" or "Banners"

### 3. Check Focus/Do Not Disturb
1. **Control Center** (top-right corner) → **Focus**
2. Make sure **"Do Not Disturb"** is ✅ **OFF**
3. Or configure Focus to allow notifications from Battery Alert

### 4. Test Specific Alert Sounds

Test the exact sounds Battery Alert uses:

**Test Low Battery Sound (Ping):**
```bash
osascript -e 'display notification "🔋 Low Battery Test" with title "20% Battery Alert" sound name "Ping"'
```

**Test Charging Sound (Hero):**
```bash
osascript -e 'display notification "🔌 Charging Test" with title "80% Charge Alert" sound name "Hero"'
```

### 5. Available Sound Options

If "Hero" or "Ping" don't work, try these alternatives:

```bash
# Try different sounds:
osascript -e 'display notification "Sound test" with title "Test" sound name "Basso"'
osascript -e 'display notification "Sound test" with title "Test" sound name "Glass"'
osascript -e 'display notification "Sound test" with title "Test" sound name "Sosumi"'
osascript -e 'display notification "Sound test" with title "Test" sound name "Tink"'
```

**Available sound names:**
- `"Basso"` - Deep tone
- `"Blow"` - Puff sound  
- `"Bottle"` - Pop sound
- `"Frog"` - Ribbit sound
- `"Funk"` - Funky sound
- `"Glass"` - Gentle chime ⭐ **Recommended**
- `"Hero"` - Triumphant sound (default for 80%)
- `"Morse"` - Beep sound
- `"Ping"` - Simple ping (default for 20%)
- `"Pop"` - Pop sound
- `"Purr"` - Soft sound
- `"Sosumi"` - Classic Mac sound ⭐ **Good alternative**
- `"Submarine"` - Sonar sound
- `"Tink"` - Light metallic sound

### 6. Customize Your Sounds

Want to change the default sounds? Edit the script:

1. **Find the script:**
   ```bash
   sudo nano /usr/local/bin/batteryAlert.scpt
   ```
   
2. **Or edit the source and reinstall:**
   ```bash
   nano scripts/batteryAlert.applescript
   # Change the sound names:
   # sound name "Ping"  -> sound name "Glass"
   # sound name "Hero"  -> sound name "Sosumi"
   
   # Then reinstall
   ./uninstall.sh
   ./install.sh
   ```

## Advanced Troubleshooting

### Check Audio Output Device
1. **System Settings** → **Sound** → **Output**
2. Make sure the correct device is selected
3. Test with built-in speakers if using external audio

### Check Volume Levels
1. Main system volume (top menu bar)
2. Alert volume (System Settings → Sound → Sound Effects)
3. App-specific volume (if applicable)

### Reset Notification Database (Nuclear Option)
If nothing else works:
```bash
# This will reset ALL notification settings
sudo rm /var/folders/*/0/com.apple.notificationcenter/db2/db*
killall NotificationCenter
```
**⚠️ Warning:** This resets ALL app notification permissions!

## Test the Complete Flow

Once you think it's fixed, test the real scenario:

1. **Unplug your charger** (if at >80% battery)
2. **Wait for battery to reach 80%** while plugged in, OR
3. **Modify the script temporarily** to test at your current battery level

## Still No Sound?

If you've tried everything:

1. **Check Console app** for errors:
   - Applications → Utilities → Console
   - Search for "osascript" or "notification"

2. **Test from Script Editor directly:**
   - Open Script Editor
   - Paste: `display notification "Test" with title "Test" sound name "Glass"`
   - Click ▶️ Run

3. **Report the issue:**
   - Let us know your macOS version
   - Share any error messages
   - Mention which troubleshooting steps you tried

---

**Most Common Fix:** Usually it's just the "Play user interface sound effects" setting in System Settings → Sound → Sound Effects! 🔊