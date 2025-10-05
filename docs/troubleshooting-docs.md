# 🔍 Troubleshooting Guide

Common issues and solutions for the Medicine Reminder system.

---

## 🚨 Quick Diagnostics

### System Health Check Script

Run this script to diagnose common issues:

```bash
#!/bin/bash
echo "=== Medicine Reminder Diagnostic ==="
echo ""
echo "1. Checking Raspberry Pi..."
cat /proc/device-tree/model
echo ""

echo "2. Checking SPI Interface..."
ls /dev/spidev* 2>/dev/null || echo "❌ SPI not enabled"
echo ""

echo "3. Checking Python..."
python3 --version
echo ""

echo "4. Checking GPIO access..."
groups | grep -q gpio && echo "✓ GPIO access enabled" || echo "❌ No GPIO access"
echo ""

echo "5. Checking display driver..."
ls ~/e-Paper 2>/dev/null && echo "✓ Waveshare library present" || echo "❌ Missing display library"
echo ""

echo "6. Checking autostart..."
ls ~/.config/lxsession/LXDE-pi/autostart 2>/dev/null && echo "✓ Autostart configured" || echo "❌ Autostart not configured"
echo ""

echo "7. Checking timezone..."
timedatectl | grep "Time zone"
echo ""

echo "Diagnostic complete!"
```

Save as `diagnostics.sh`, make executable with `chmod +x diagnostics.sh`, and run with `./diagnostics.sh`

---

## 🖥️ Display Issues

### Problem: Display Shows Nothing (Blank White)

**Symptom:** Display is completely white, no content visible

**Possible Causes:**
1. SPI not enabled
2. Wrong display driver
3. Power supply insufficient
4. HAT not properly seated

**Solutions:**

**Check SPI:**
```bash
# Verify SPI is enabled
ls /dev/spidev*
# Should show: /dev/spidev0.0  /dev/spidev0.1

# If missing, enable SPI
sudo raspi-config
# Navigate: Interface Options → SPI → Yes
sudo reboot
```

**Verify Display Driver:**
```bash
# Check Waveshare library exists
ls ~/e-Paper/RaspberryPi_JetsonNano/python/examples/

# Run test script
cd ~/e-Paper/RaspberryPi_JetsonNano/python/examples/
python3 epd_2in13_V4_test.py
```

**Check Power Supply:**
```bash
# Check for under-voltage warnings
vcgencmd get_throttled
# 0x0 = good
# 0x50000 or 0x50005 = under-voltage detected

# Solution: Use official 5V/2.5A power supply
```

**Reseat HAT:**
1. Power off Pi completely
2. Remove e-Paper HAT
3. Inspect GPIO pins for damage
4. Reattach HAT firmly
5. Power on and test

---

### Problem: Display Shows Garbled/Corrupted Image

**Symptom:** Random patterns, partial images, or static

**Possible Causes:**
1. Incorrect display model selected
2. SPI communication errors
3. Software timing issues

**Solutions:**

**Verify Display Model:**
```bash
# Check your exact display version
# Look on back of display for model number
# Should be: 2.13inch e-Paper HAT V4

# Update driver if needed
cd ~/e-Paper
git pull origin master
```

**Test Display Directly:**
```bash
cd ~/e-Paper/RaspberryPi_JetsonNano/python/examples/
python3 epd_2in13_V4_test.py

# If this works, issue is in web app, not hardware
```

**Clear Display Cache:**
```bash
# Full display refresh
cd ~/e-Paper/RaspberryPi_JetsonNano/python/examples/
python3 epd_2in13_V4_clear.py
```

---

### Problem: Display Updates Very Slowly

**Symptom:** Screen takes 10+ seconds to refresh

**Normal Behavior:** E-paper displays take 2-4 seconds for full refresh

**Possible Causes:**
1. Low temperature (e-paper slows in cold)
2. Full refresh mode being used unnecessarily
3. Power supply issues

**Solutions:**

**Check Temperature:**
```bash
# Check CPU temperature
vcgencmd measure_temp
# Should be 40-60°C normally
# E-paper refresh slows below 10°C
```

**Optimize Refresh Strategy:**
- Partial refreshes: Faster but can ghost
- Full refreshes: Slower but cleaner
- Default: Full refresh every 10 partial refreshes

**Improve Power:**
- Use official Raspberry Pi power supply
- Avoid long/thin USB cables
- Check for voltage drops

---

### Problem: Display Has "Ghost Images"

**Symptom:** Faint remnants of previous content visible

**Normal Behavior:** E-paper can retain slight ghosting between partial refreshes

**Solutions:**

**Scheduled Full Refresh:**
Add to your web app JavaScript:
```javascript
// Force full display refresh every hour
setInterval(() => {
    location.reload(true);
}, 3600000); // 1 hour in milliseconds
```

**Manual Clear:**
```bash
cd ~/e-Paper/RaspberryPi_JetsonNano/python/examples/
python3 epd_2in13_V4_clear.py
```

**Automatic Clearing:** Already implemented in default code (runs on boot)

---

## ⏰ Time & Schedule Issues

### Problem: Wrong Time Displayed

**Symptom:** Clock shows incorrect time

**Possible Causes:**
1. Wrong timezone configured
2. System time not synced
3. Browser caching old time

**Solutions:**

**Set Correct Timezone:**
```bash
# Check current timezone
timedatectl

# Set to Eastern (EST/EDT)
sudo timedatectl set-timezone America/New_York

# Other US timezones:
# sudo timedatectl set-timezone America/Chicago     # Central
# sudo timedatectl set-timezone America/Denver      # Mountain
# sudo timedatectl set-timezone America/Los_Angeles # Pacific

# Verify change
date
```

**Force Time Sync:**
```bash
# Install NTP if missing
sudo apt-get install ntp

# Force immediate sync
sudo systemctl stop ntp
sudo ntpd -gq
sudo systemctl start ntp

# Verify time is correct
date
```

**Clear Browser Cache:**
```bash
# Restart Chromium in kiosk mode
sudo systemctl restart lightdm
```

---

### Problem: Alerts Trigger at Wrong Time

**Symptom:** Reminder shows at 9:45 AM instead of 7:45 AM

**Possible Causes:**
1. Timezone mismatch between config and system
2. 12-hour vs 24-hour time confusion
3. Config not loaded properly

**Solutions:**

**Verify Config Times:**
```bash
cat ~/medicine-reminder/config.json
# Times should be in 24-hour format
# 7:45 AM = hour: 7, minute: 45
# 7:45 PM = hour: 19, minute: 45
```

**Check Timezone Match:**
```bash
# System timezone
timedatectl | grep "Time zone"

# Should match config.json:
cat config.json | grep timezone
```

**Force Config Reload:**
```bash
# Clear browser cache and reload
# Hard refresh: Ctrl + Shift + R in Chromium
# Or restart:
sudo systemctl restart lightdm
```

---

### Problem: Countdown Shows Negative Numbers

**Symptom:** "Next dose in: -5h -23m"

**Cause:** Schedule passed but not detected, or timezone issue

**Solutions:**

**Check Alert Window:**
In `config.json`:
```json
"alertWindow": 300  // 5 minutes = 300 seconds
```

If dose time passed outside alert window, countdown resets to next dose.

**Verify JavaScript Console:**
```bash
# Access from another computer on same network
# Open: http://PI_IP_ADDRESS:8000
# Press F12, check Console for errors
```

---

## 🌐 Network & Connectivity Issues

### Problem: Kiosk Won't Load Web App

**Symptom:** Chromium shows "Unable to connect" or blank screen

**Possible Causes:**
1. No internet connection
2. Wrong URL in autostart
3. Hosting service down
4. Local firewall blocking

**Solutions:**

**Test Internet Connection:**
```bash
# Ping test
ping -c 4 google.com

# If fails, check WiFi
sudo iwconfig

# Reconnect WiFi
sudo raspi-config
# System Options → Wireless LAN
```

**Verify Autostart URL:**
```bash
cat ~/.config/lxsession/LXDE-pi/autostart
# Check URL is correct

# Test URL manually
chromium-browser YOUR_URL
```

**Use Local Server (Offline):**
```bash
cd ~/medicine-reminder
python3 -m http.server 8000 &

# Update autostart to use localhost
nano ~/.config/lxsession/LXDE-pi/autostart
# Change URL to: http://localhost:8000
```

---

### Problem: WiFi Disconnects Frequently

**Symptom:** Network drops out, requiring reboots

**Solutions:**

**Disable Power Management:**
```bash
sudo nano /etc/rc.local

# Add before "exit 0":
/sbin/iwconfig wlan0 power off

# Save and reboot
sudo reboot
```

**Check WiFi Signal:**
```bash
iwconfig wlan0 | grep Signal
# Should be above -70 dBm for stable connection
```

**Use Ethernet (if available):**
- Requires USB Ethernet adapter
- More stable than WiFi
- Slightly higher power consumption

---

## 🔘 Touch Input Issues

### Problem: Touch Not Responding

**Symptom:** Can't tap "I TOOK IT" button or History

**Possible Causes:**
1. Protective film still on display
2. Touch driver not installed
3. Wrong display model (non-touch version)

**Solutions:**

**Check for Protective Film:**
- Look for clear plastic film on screen
- Peel off carefully from corner

**Verify Touch Model:**
```bash
# List input devices
ls /dev/input/
# Should show event0, event1, etc.

# Test touch
sudo apt-get install evtest
sudo evtest

# Select your touch device (usually event0)
# Touch screen - events should appear
```

**Install Touch Driver (if missing):**
```bash
cd ~/e-Paper/RaspberryPi_JetsonNano/python/examples/
# Follow touch-specific setup instructions
```

**Calibrate Touch:**
```bash
sudo apt-get install xinput-calibrator
DISPLAY=:0 xinput_calibrator
```

---

### Problem: Touch Offset/Inaccurate

**Symptom:** Touching one spot activates different area

**Solution:**

**Recalibrate Touch:**
```bash
sudo apt-get install xinput-calibrator
DISPLAY=:0 xinput_calibrator

# Follow on-screen instructions
# Touch the crosshairs
# Save calibration data to config
```

---

## 🚀 Boot & Autostart Issues

### Problem: Kiosk Doesn't Start on Boot

**Symptom:** Pi boots but Chromium never opens

**Possible Causes:**
1. Autostart file not configured
2. Wrong file path
3. X server not starting
4. Permissions issue

**Solutions:**

**Check Autostart Exists:**
```bash
ls -la ~/.config/lxsession/LXDE-pi/autostart
# Should exist and be readable
```

**Verify Autostart Content:**
```bash
cat ~/.config/lxsession/LXDE-pi/autostart

# Should contain:
# @xset s off
# @xset -dpms
# @xset s noblank
# @chromium-browser --kiosk ... YOUR_URL
# @unclutter -idle 0
```

**Fix Permissions:**
```bash
chmod +x ~/.config/lxsession/LXDE-pi/autostart
```

**Test Manually:**
```bash
# Stop X server
sudo systemctl stop lightdm

# Start X manually
startx

# If Chromium opens, autostart is working
# Issue is with X server config
```

**Check X Server:**
```bash
sudo systemctl status lightdm
# Should show "active (running)"

# If not:
sudo systemctl enable lightdm
sudo systemctl start lightdm
```

---

### Problem: Black Screen on Boot

**Symptom:** Display never turns on after power on

**LED Diagnostics:**

| LED Behavior | Meaning | Action |
|--------------|---------|--------|
| No LEDs | No power | Check power supply |
| Solid red only | No SD card or SD card issue | Check/reflash SD card |
| Red + flashing green | Normal boot | Wait 60-90 seconds |
| Solid red + green | Boot complete | Display should initialize |

**Solutions:**

**Reflash SD Card:**
1. Download fresh Raspberry Pi OS
2. Use Raspberry Pi Imager
3. Flash to SD card
4. Rerun setup script

**Check HDMI (if using monitor):**
```bash
# Force HDMI output
sudo nano /boot/config.txt

# Add:
hdmi_force_hotplug=1
hdmi_drive=2

# Save and reboot
```

---

## 💾 Data & History Issues

### Problem: Dose History Not Saving

**Symptom:** History button shows "No dose history yet" after logging doses

**Cause:** localStorage not persisting or being cleared

**Solutions:**

**Check Browser Settings:**
```bash
# Chromium may clear data in incognito mode
# Check autostart:
cat ~/.config/lxsession/LXDE-pi/autostart

# Remove --incognito flag if present
nano ~/.config/lxsession/LXDE-pi/autostart
# Change to:
@chromium-browser --kiosk --window-size=250,122 YOUR_URL
```

**Test localStorage:**
Open browser console (F12) and run:
```javascript
localStorage.setItem('test', 'working');
console.log(localStorage.getItem('test'));
// Should output: "working"
```

**Export History (Backup):**
```javascript
// In browser console:
console.log(JSON.stringify(localStorage.getItem('medHistory')));
// Copy output to save elsewhere
```

---

### Problem: Wrong Dose Names in History

**Symptom:** History shows "Morning Medicine" but you took "Night Medicine"

**Cause:** Logged before schedule updated

**Solution:**

Clear history and start fresh:
```javascript
// Browser console:
localStorage.removeItem('medHistory');
location.reload();
```

---

## 🔋 Power & Performance Issues

### Problem: Pi Keeps Rebooting

**Symptom:** System restarts randomly, especially during display refresh

**Cause:** Insufficient power supply

**Solutions:**

**Check for Under-Voltage:**
```bash
vcgencmd get_throttled
# 0x0 = Good
# 0x50000 or 0x50005 = Under-voltage detected
```

**Upgrade Power Supply:**
- Use official Raspberry Pi 5V/2.5A supply
- Avoid phone chargers (often only 1A)
- Use short, thick USB cables (< 6 feet, 20 AWG)

**Disable Unnecessary Services:**
```bash
# Disable Bluetooth if not needed
sudo systemctl disable bluetooth
sudo systemctl stop bluetooth

# Disable WiFi if using Ethernet
sudo rfkill block wifi
```

---

### Problem: System Running Hot

**Symptom:** CPU temperature >70°C, system slow

**Check Temperature:**
```bash
vcgencmd measure_temp
# Normal: 40-60°C
# Warning: 60-70°C
# Critical: >70°C (throttling starts at 80°C)
```

**Solutions:**

**Add Cooling:**
- Passive heatsink ($2-5)
- Small cooling fan ($5-10)
- Improve airflow around case

**Reduce Load:**
```bash
# Close unnecessary processes
htop
# Press F9 to kill heavy processes
```

**Optimize Chromium:**
```bash
# Add to autostart:
@chromium-browser --kiosk --disable-gpu --disable-software-rasterizer YOUR_URL
```

---

## 🐛 Software & Code Issues

### Problem: JavaScript Errors in Console

**Symptom:** Functionality broken, errors in browser console

**Accessing Console:**
```bash
# From another computer on same network:
# 1. Find Pi IP: hostname -I
# 2. Open: http://PI_IP:8000
# 3. Press F12 to open Developer Tools
# 4. Check Console tab for errors
```

**Common Errors:**

**"Cannot read property of undefined":**
- Config file not loading properly
- Check config.json syntax

**"Failed to fetch":**
- Network connectivity issue
- Check internet connection

**"localStorage is not defined":**
- Browser blocking localStorage
- Remove --incognito flag from kiosk mode

---

### Problem: Config Changes Not Taking Effect

**Symptom:** Modified config.json but schedule unchanged

**Solutions:**

**Force Cache Clear:**
```bash
# Hard refresh Chromium
# Ctrl + Shift + R

# Or restart lightdm
sudo systemctl restart lightdm
```

**Validate JSON:**
```bash
# Check for syntax errors
python3 -m json.tool config.json

# Should output formatted JSON if valid
# If error, fix syntax issues
```

**Check File Location:**
```bash
# Ensure editing correct file
cat ~/medicine-reminder/config.json

# Verify this is the file web app uses
```

---

## 📞 Getting More Help

### Information to Include When Asking for Help

When opening a GitHub issue or asking for help, include:

1. **Hardware:**
   - Raspberry Pi model
   - Display model and version
   - Power supply specs

2. **Software:**
   ```bash
   # Run and include output:
   uname -a
   cat /etc/os-release
   python3 --version
   ```

3. **Error Messages:**
   - Exact error text
   - Screenshots if possible
   - Browser console output

4. **What You've Tried:**
   - List troubleshooting steps already attempted
   - Results of each attempt

### Useful Diagnostic Commands

```bash
# System info
cat /proc/cpuinfo | grep Model
cat /proc/meminfo | grep MemTotal

# Disk space
df -h

# Running processes
ps aux | grep chromium

# System logs
journalctl -xe | tail -50

# Network status
ifconfig
ping -c 4 8.8.8.8
```

### Community Resources

- **GitHub Issues:** [Create an issue](https://github.com/tlogandesigns/medicine-reminder/issues)
- **Raspberry Pi Forums:** [raspberrypi.org/forums](https://forums.raspberrypi.org/)
- **Reddit:** [r/raspberry_pi](https://reddit.com/r/raspberry_pi)
- **Discord:** [Raspberry Pi Discord](https://discord.gg/raspberrypi)

### Professional Support

For critical medication reminder systems, consider:
- Hiring a local tech to assist with setup
- Using a pre-configured commercial system
- Adding redundant phone/email reminders

---

## ✅ Prevention Checklist

Avoid future issues by:

- [ ] Using official power supply
- [ ] Keeping system updated: `sudo apt update && sudo apt upgrade`
- [ ] Regular backups of config.json
- [ ] Monitoring temperature during summer
- [ ] Checking logs weekly for errors
- [ ] Testing after any config changes

---

**Still having issues?** Open a [GitHub issue](https://github.com/tlogandesigns/medicine-reminder/issues) with details.

---

## 🔄 Factory Reset Procedure

If all else fails, start fresh:

### Complete System Reset

```bash
# 1. Backup your data
cp ~/medicine-reminder/config.json ~/config-backup.json
# Copy dose history if needed (from browser localStorage)

# 2. Remove all installation files
rm -rf ~/medicine-reminder
rm -rf ~/e-Paper
rm -rf ~/.config/lxsession/LXDE-pi/autostart

# 3. Clean package cache
sudo apt-get clean
sudo apt-get autoclean
sudo apt-get autoremove

# 4. Reflash SD card (recommended)
# Use Raspberry Pi Imager on another computer
# Flash fresh Raspberry Pi OS

# 5. Start installation from scratch
# Follow INSTALLATION.md again
```

### Partial Reset (Keep System, Reset App)

```bash
# Remove only medicine reminder
rm -rf ~/medicine-reminder

# Remove autostart
rm ~/.config/lxsession/LXDE-pi/autostart

# Reboot
sudo reboot

# Reinstall medicine reminder
git clone https://github.com/tlogandesigns/medicine-reminder.git
cd medicine-reminder
./setup.sh
```

---

## 🛠️ Advanced Troubleshooting

### Enable Verbose Logging

Add logging to catch intermittent issues:

```bash
# Create log directory
mkdir -p ~/medicine-reminder/logs

# Add to autostart (before chromium line)
nano ~/.config/lxsession/LXDE-pi/autostart

# Add:
@bash -c 'chromium-browser --kiosk --enable-logging --v=1 --log-file=~/medicine-reminder/logs/chromium.log YOUR_URL'
```

**View Logs:**
```bash
tail -f ~/medicine-reminder/logs/chromium.log
```

### Monitor System Resources

```bash
# Install monitoring tools
sudo apt-get install htop iotop

# Watch CPU/memory in real-time
htop

# Watch disk I/O
sudo iotop
```

### Network Debugging

```bash
# Test DNS resolution
nslookup your-hosting-url.com

# Test HTTP connection
curl -I https://your-hosting-url.com

# Watch network traffic
sudo tcpdump -i wlan0 port 80 or port 443

# Check for packet loss
ping -c 100 your-hosting-url.com | grep loss
```

### GPIO Debugging

```bash
# Show all GPIO states
gpio readall

# Test specific GPIO pins (example for pin 17)
gpio mode 17 out
gpio write 17 1  # Set high
gpio write 17 0  # Set low
```

### SPI Communication Test

```bash
# Install SPI tools
sudo apt-get install spi-tools

# Test SPI loopback
spi-test -D /dev/spidev0.0

# Check SPI speed
spi-config -d /dev/spidev0.0 -q
```

---

## 📊 Performance Optimization

### Speed Up Boot Time

```bash
# Disable unnecessary services
sudo systemctl disable avahi-daemon
sudo systemctl disable triggerhappy
sudo systemctl disable bluetooth

# Reduce boot delay
sudo nano /boot/cmdline.txt
# Add: boot_delay=0
```

### Optimize Chromium

```bash
# Add flags to autostart for better performance
@chromium-browser --kiosk \
  --disable-gpu \
  --disable-software-rasterizer \
  --disable-dev-shm-usage \
  --disable-features=TranslateUI \
  --noerrdialogs \
  --disable-infobars \
  --disable-session-crashed-bubble \
  YOUR_URL
```

### Reduce Memory Usage

```bash
# Increase swap if needed
sudo dphys-swapfile swapoff
sudo nano /etc/dphys-swapfile
# Change: CONF_SWAPSIZE=512
sudo dphys-swapfile setup
sudo dphys-swapfile swapon

# Clear cache regularly
sudo sync
echo 3 | sudo tee /proc/sys/vm/drop_caches
```

---

## 🔐 Security Issues

### Problem: Remote Access Not Working

**Enable SSH:**
```bash
sudo raspi-config
# Interface Options → SSH → Enable
```

**Change Default Password:**
```bash
passwd
# Enter new password
```

**Set Static IP (Optional):**
```bash
sudo nano /etc/dhcpcd.conf

# Add at end:
interface wlan0
static ip_address=192.168.1.100/24
static routers=192.168.1.1
static domain_name_servers=192.168.1.1 8.8.8.8
```

### Problem: Unauthorized Access Concerns

**Disable SSH After Setup:**
```bash
sudo systemctl disable ssh
sudo systemctl stop ssh
```

**Enable Firewall:**
```bash
sudo apt-get install ufw
sudo ufw enable
sudo ufw allow from 192.168.1.0/24 to any port 22
```

**Disable VNC/Remote Desktop:**
```bash
sudo raspi-config
# Interface Options → VNC → Disable
```

---

## 🔊 Audio Alert Troubleshooting (Advanced)

If you've added a speaker for audio alerts:

### Problem: No Sound Output

**Check Audio Devices:**
```bash
aplay -l
# Should list available audio devices
```

**Test Audio:**
```bash
speaker-test -t wav -c 2
# Should hear white noise

# Test with WAV file
aplay /usr/share/sounds/alsa/Front_Center.wav
```

**Set Audio Output:**
```bash
# Force 3.5mm jack
amixer cset numid=3 1

# Force HDMI
amixer cset numid=3 2

# Auto
amixer cset numid=3 0
```

**Adjust Volume:**
```bash
alsamixer
# Use arrow keys to adjust
# M to mute/unmute
```

---

## 🔋 Battery/UPS Issues (Advanced)

If using battery backup:

### Problem: UPS Not Charging

**Check UPS Status:**
```bash
# Install i2c-tools
sudo apt-get install i2c-tools

# Scan for I2C devices
sudo i2cdetect -y 1

# Should show UPS at address (typically 0x36)
```

**Monitor Battery:**
```bash
# Read battery voltage (varies by UPS HAT)
sudo i2cget -y 1 0x36 0x02 w
```

### Problem: Pi Shuts Down Unexpectedly with Battery

**Increase Shutdown Threshold:**
```bash
# Edit UPS configuration (if available)
sudo nano /etc/ups-config.conf

# Lower voltage threshold
# Example: min_voltage=3.0
```

---

## 📱 Companion Features Troubleshooting

### Problem: Can't Access from Phone

**Check Network:**
```bash
# Find Pi's IP address
hostname -I

# Ensure phone on same network
# Open: http://PI_IP_ADDRESS:8000
```

**Enable Port Forwarding (for remote access):**
```bash
# Not recommended for security reasons
# Use VPN instead (like Tailscale)
```

### Problem: Mobile View Doesn't Work

**Add Responsive Meta Tag:**

In `index.html` `<head>`:
```html
<meta name="viewport" content="width=device-width, initial-scale=1.0">
```

**Test Mobile View:**
- Open in mobile browser
- Use Chrome DevTools device emulation
- Should scale appropriately

---

## 🧪 Testing Procedures

### Automated Testing Script

Create `test.sh`:

```bash
#!/bin/bash

echo "=== Medicine Reminder Test Suite ==="
echo ""

# Test 1: Hardware
echo "Test 1: Hardware Check"
ls /dev/spidev* > /dev/null 2>&1 && echo "✓ SPI enabled" || echo "✗ SPI disabled"

# Test 2: Display
echo ""
echo "Test 2: Display Test"
cd ~/e-Paper/RaspberryPi_JetsonNano/python/examples/
python3 epd_2in13_V4_test.py > /dev/null 2>&1 && echo "✓ Display working" || echo "✗ Display error"

# Test 3: Network
echo ""
echo "Test 3: Network Test"
ping -c 1 google.com > /dev/null 2>&1 && echo "✓ Internet connected" || echo "✗ No internet"

# Test 4: Time
echo ""
echo "Test 4: Time Sync"
timedatectl status | grep -q "synchronized: yes" && echo "✓ Time synced" || echo "✗ Time not synced"

# Test 5: Config
echo ""
echo "Test 5: Config Valid"
python3 -m json.tool ~/medicine-reminder/config.json > /dev/null 2>&1 && echo "✓ Config valid" || echo "✗ Config invalid"

# Test 6: Web Server
echo ""
echo "Test 6: Web Access"
curl -s http://localhost:8000 > /dev/null && echo "✓ Web server responding" || echo "✗ Web server down"

echo ""
echo "=== Test Complete ==="
```

Run with: `bash test.sh`

---

## 📋 Maintenance Schedule

### Daily
- Visual check that display is updating
- Verify time is correct

### Weekly
- Check dose history accuracy
- Clean display with microfiber cloth
- Verify power cable secure

### Monthly
- Run test suite: `bash test.sh`
- Update system: `sudo apt update && sudo apt upgrade`
- Check logs for errors: `journalctl -xe | grep error`
- Backup config: `cp config.json config-backup-$(date +%Y%m%d).json`

### Quarterly
- Verify SD card health: `sudo badblocks -v /dev/mmcblk0`
- Test hardware: Run full display test
- Review and optimize schedule if needed

### Yearly
- Consider SD card replacement (wear over time)
- Inspect GPIO pins for corrosion
- Update Raspberry Pi OS: Fresh install recommended
- Review power supply health

---

## 🎓 Understanding Error Messages

### Common Log Messages

**"Under-voltage detected"**
```
Meaning: Power supply insufficient
Action: Upgrade to 2.5A official supply
```

**"I2C timeout"**
```
Meaning: Communication error with display
Action: Check connections, try lower SPI speed
```

**"Failed to load resource: net::ERR_CONNECTION_REFUSED"**
```
Meaning: Web server not running
Action: Start local server or check hosting URL
```

**"localStorage is null"**
```
Meaning: Browser blocking storage
Action: Remove --incognito from kiosk mode
```

**"Cannot read property 'hour' of undefined"**
```
Meaning: Config file not parsed correctly
Action: Validate JSON syntax in config.json
```

---

## 🏆 Success Checklist

Your system is working correctly if:

- [ ] Display shows current time accurately
- [ ] Countdown updates every second
- [ ] Alerts trigger within 5 minutes of scheduled time
- [ ] Display inverts (black background) during alerts
- [ ] "I TOOK IT" button logs doses
- [ ] History shows past 10 doses correctly
- [ ] System boots automatically after power loss
- [ ] No warning icons in system tray
- [ ] Touch input responsive
- [ ] No ghost images on display

---

## 💡 Pro Tips

### Tip 1: Remote Monitoring
```bash
# Install and configure Telegram bot for notifications
# Get alerts when doses are taken or missed
```

### Tip 2: Backup Automation
```bash
# Add to crontab for daily backups
crontab -e
# Add: 0 2 * * * cp ~/medicine-reminder/config.json ~/backups/config-$(date +\%Y\%m\%d).json
```

### Tip 3: Multi-User Setup
```bash
# Create multiple config files
config-john.json
config-mary.json

# Switch between them as needed
```

### Tip 4: Development Mode
```bash
# For testing, use local server with auto-reload
python3 -m http.server 8000 &
# Edit files, just refresh browser to see changes
```

### Tip 5: Temperature Monitoring
```bash
# Add temperature display to web app
# Shows CPU temp, helpful for troubleshooting
```

---

## 📚 Additional Resources

### Video Tutorials
- Search: "Raspberry Pi e-Paper troubleshooting"
- Waveshare official YouTube channel
- Raspberry Pi Foundation tutorials

### Documentation
- [Raspberry Pi Documentation](https://www.raspberrypi.com/documentation/)
- [Waveshare Wiki](https://www.waveshare.com/wiki/)
- [Bootstrap Docs](https://getbootstrap.com/docs/)

### Community Forums
- [Raspberry Pi Forums](https://forums.raspberrypi.com/)
- [r/raspberry_pi](https://reddit.com/r/raspberry_pi)
- [Stack Overflow - Raspberry Pi Tag](https://stackoverflow.com/questions/tagged/raspberry-pi)

---

## 🆘 Emergency Procedures

### Critical Issue: Medication Reminder Failed

**Backup Plan:** Until system is fixed:

1. **Set phone alarms** immediately
2. **Use physical pill organizer** with days/times
3. **Ask family member** for reminders
4. **Contact doctor** if missed doses are concerning

**System is a tool, not replacement for medical advice!**

### Data Recovery

If system fails and you need dose history:

```bash
# Access localStorage from SD card
# Mount SD card on another computer
# Navigate to: /home/pi/.config/chromium/Default/Local Storage/
# Use SQLite browser to read database
```

---

**Remember:** This is a helpful tool, but always consult healthcare providers about medication schedules and concerns. The system should complement, not replace, medical guidance.

---

**Need immediate help?** Create a [GitHub Issue](https://github.com/tlogandesigns/medicine-reminder/issues) with:
- Exact error message
- Output of `./diagnostics.sh`
- Photos of setup (if hardware issue)
- What you've already tried

Response time: Usually within 24 hours

---

[← Back to Main README](../README.md) | [Installation Guide →](INSTALLATION.md)