# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Medicine Reminder Kiosk - A dedicated e-Paper display medicine reminder system for Raspberry Pi Zero 2 W with Waveshare 2.13" touch e-Paper display (250x122px, black & white only). The system runs a web-based kiosk in Chromium that displays medication reminders at scheduled times.

## Architecture

### Deployment Model
- **Web-based kiosk** (recommended): Single HTML file hosted externally, loaded in Chromium kiosk mode
- **Local server**: Python HTTP server hosting index.html locally
- **Direct rendering** (advanced): Python scripts controlling e-Paper HAT directly via SPI

### Core Components
1. **med-reminder-kiosk.html** - Single-page web application with embedded JavaScript
   - No build process or dependencies
   - Uses Bootstrap 5 CDN for CSS
   - localStorage for dose history persistence
   - Optimized for e-Paper: monospace fonts, black/white only, minimal refreshes

2. **config-json.json** - Medication schedule configuration
   - Schedule array with medication times (24-hour format)
   - Timezone settings (IANA format)
   - Alert window duration in seconds (default: 300)
   - Display settings (width, height, rotation)
   - Currently loaded directly into HTML - config loading not yet implemented

3. **setup-script.sh** - Automated Raspberry Pi setup
   - Installs Chromium, Python dependencies, Waveshare drivers
   - Enables SPI interface for e-Paper HAT
   - Configures kiosk mode autostart
   - Sets timezone to EST

### Key Technical Details

**E-Paper Display Constraints:**
- Resolution: 250x122px (very small, optimize text size)
- 1-bit color depth: black and white only, no grayscale
- Slow refresh rate (~2 seconds per full refresh)
- Minimize DOM changes to reduce flicker

**State Management:**
- Two visual states: normal (white bg, black text) and alert (inverted colors)
- Alert triggers 5 minutes before/after scheduled dose time (configurable via alertWindow)
- Browser localStorage stores last 100 doses with timestamps
- No backend, no database, fully client-side

**Time Handling:**
- All times in config.json use 24-hour format (0-23)
- JavaScript uses toLocaleString() with timezone parameter for EST conversion
- Schedule runs on client browser clock (ensure Pi system time is correct)

## Common Commands

### Development
```bash
# Test locally in browser
python3 -m http.server 8000
# Then open http://localhost:8000/med-reminder-kiosk.html

# Validate config JSON
python3 -m json.tool config-json.json

# Test on actual hardware (via SSH)
chromium-browser --kiosk --window-size=250,122 http://localhost:8000/med-reminder-kiosk.html
```

### Raspberry Pi Deployment
```bash
# Initial setup (from fresh Pi)
chmod +x setup-script.sh
./setup-script.sh

# Configure autostart
nano ~/.config/lxsession/LXDE-pi/autostart
# Add: @chromium-browser --kiosk --window-size=250,122 --incognito YOUR_URL

# Test kiosk manually
chromium-browser --kiosk --window-size=250,122 --incognito YOUR_URL

# Restart X server to reload kiosk
sudo systemctl restart lightdm

# Check SPI is enabled (required for e-Paper)
ls /dev/spidev*
# Should show: /dev/spidev0.0  /dev/spidev0.1

# Set timezone
sudo timedatectl set-timezone America/New_York

# Reboot
sudo reboot
```

### Debugging
```bash
# Check autostart configuration
cat ~/.config/lxsession/LXDE-pi/autostart

# View system logs
journalctl -xe

# Test e-Paper display (if using Waveshare library)
cd ~/e-Paper/RaspberryPi_JetsonNano/python/examples
python3 epd_2in13_V4_test.py

# Verify timezone
timedatectl
```

## Configuration Notes

### Modifying Medication Schedule
Edit `config-json.json`:
- `hour`: 24-hour format (7 = 7 AM, 22 = 10 PM)
- `minute`: 0-59
- `enabled`: true/false to temporarily disable doses
- `alertWindow`: seconds before/after scheduled time to show alert (default: 300 = 5 minutes)

**Note:** Config loading from JSON is not yet implemented in the HTML file. Current schedule is hardcoded in the `<script>` section:
```javascript
const schedule = [
    { name: "Morning Medicine", hour: 7, minute: 45 },
    { name: "Night Medicine", hour: 22, minute: 0 }
];
```

To change schedule, either:
1. Edit the JavaScript directly in med-reminder-kiosk.html
2. Implement config.json loading via fetch() API

### Display Optimization
- Font: 'Courier New', monospace (better readability on e-Paper)
- Disable font smoothing: `-webkit-font-smoothing: none`
- Fixed dimensions: 250x122px container
- High contrast required (pure #000000 and #ffffff)

### Time-Critical Functions
- `getNextDose()`: Calculates next upcoming medication from schedule
- `shouldShowAlert()`: Determines if current time is within alert window
- `updateCountdown()`: Runs every second to update display and check for alerts
- All times converted to EST using `toLocaleString('en-US', { timeZone: 'America/New_York' })`

## File Structure Notes

- All documentation in `/docs/` directory (installation, configuration, hardware, troubleshooting)
- Text files have descriptive suffixes: `*-docs.md`, `*-script.sh`, `*-json.json`, `*-file.txt`
- README.md is named `readme.md` (lowercase)
- No package.json or build system - pure HTML/CSS/JS

## Hardware Context

Understanding the hardware helps explain the code constraints:
- Raspberry Pi Zero 2 W: Limited power, runs full Raspberry Pi OS with Chromium
- Waveshare 2.13" HAT: Connects via 40-pin GPIO, requires SPI enabled
- Touch screen uses standard input events (works in browser automatically)
- Power consumption critical: e-Paper only draws power during refresh
- Designed to run 24/7 as always-on kiosk device

## Deployment Workflow

1. Edit med-reminder-kiosk.html locally
2. Test in desktop browser (may need to mock localStorage)
3. Upload to hosting (MakersHost, Netlify, GitHub Pages) OR copy to Pi
4. Pi's autostart loads URL in Chromium kiosk mode on boot
5. No code deployment needed - just refresh browser to update (if using web hosting)
