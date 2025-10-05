# ⚙️ Configuration Guide

Complete reference for all configuration options in the Medicine Reminder system.

## 📄 Configuration File: `config.json`

The `config.json` file controls all aspects of your medication schedule and system behavior.

---

## 🕐 Medication Schedule

### Basic Schedule Configuration

```json
{
  "schedule": [
    {
      "name": "Morning Medicine",
      "hour": 7,
      "minute": 45,
      "enabled": true
    },
    {
      "name": "Night Medicine",
      "hour": 22,
      "minute": 0,
      "enabled": true
    }
  ]
}
```

### Schedule Parameters

| Parameter | Type | Required | Description | Example |
|-----------|------|----------|-------------|---------|
| `name` | string | Yes | Display name for medication | "Morning Vitamins" |
| `hour` | integer | Yes | Hour in 24-hour format (0-23) | 14 (for 2 PM) |
| `minute` | integer | Yes | Minute (0-59) | 30 |
| `enabled` | boolean | No | Enable/disable this dose | true |

### Multiple Medications Example

```json
{
  "schedule": [
    {
      "name": "Morning Blood Pressure",
      "hour": 7,
      "minute": 0,
      "enabled": true
    },
    {
      "name": "Morning Vitamins",
      "hour": 7,
      "minute": 30,
      "enabled": true
    },
    {
      "name": "Afternoon Supplement",
      "hour": 14,
      "minute": 0,
      "enabled": true
    },
    {
      "name": "Evening Medication",
      "hour": 18,
      "minute": 30,
      "enabled": true
    },
    {
      "name": "Bedtime Dose",
      "hour": 22,
      "minute": 0,
      "enabled": true
    }
  ]
}
```

### Temporarily Disable a Dose

```json
{
  "name": "Weekend Only Supplement",
  "hour": 10,
  "minute": 0,
  "enabled": false
}
```

---

## ⚙️ System Settings

### Full Configuration Structure

```json
{
  "schedule": [...],
  "settings": {
    "timezone": "America/New_York",
    "alertWindow": 300,
    "display": {
      "width": 250,
      "height": 122,
      "rotation": 0
    },
    "history": {
      "maxEntries": 100,
      "storageType": "localStorage"
    }
  },
  "notifications": {
    "visual": true,
    "audio": false,
    "vibration": false
  },
  "ui": {
    "theme": "blackwhite",
    "font": "monospace",
    "language": "en"
  }
}
```

---

## 🌍 Timezone Configuration

### Available Timezones

The system uses standard IANA timezone identifiers.

**Common US Timezones:**
```json
"timezone": "America/New_York"        // EST/EDT
"timezone": "America/Chicago"         // CST/CDT
"timezone": "America/Denver"          // MST/MDT
"timezone": "America/Los_Angeles"     // PST/PDT
"timezone": "America/Phoenix"         // MST (no DST)
"timezone": "America/Anchorage"       // AKST/AKDT
"timezone": "Pacific/Honolulu"        // HST
```

**International Examples:**
```json
"timezone": "Europe/London"           // GMT/BST
"timezone": "Europe/Paris"            // CET/CEST
"timezone": "Asia/Tokyo"              // JST
"timezone": "Australia/Sydney"        // AEST/AEDT
```

Find your timezone: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones

---

## ⏰ Alert Window

Controls how long before/after scheduled time the alert displays.

```json
"alertWindow": 300  // 5 minutes in seconds
```

| Value (seconds) | Duration | Use Case |
|----------------|----------|----------|
| `60` | 1 minute | Very strict timing |
| `300` | 5 minutes | Default, balanced |
| `600` | 10 minutes | More flexible |
| `900` | 15 minutes | Maximum flexibility |

**Example:**
- Dose scheduled: 7:45 AM
- Alert window: 300 seconds (5 minutes)
- Alert shows: 7:40 AM - 7:50 AM

---

## 🖥️ Display Settings

### E-Paper Display Configuration

```json
"display": {
  "width": 250,
  "height": 122,
  "rotation": 0
}
```

| Parameter | Options | Description |
|-----------|---------|-------------|
| `width` | integer | Display width in pixels |
| `height` | integer | Display height in pixels |
| `rotation` | 0, 90, 180, 270 | Screen rotation in degrees |

**Supported Display Sizes:**
- **2.13" e-Paper**: 250 x 122 (default)
- **2.9" e-Paper**: 296 x 128
- **4.2" e-Paper**: 400 x 300
- **7.5" e-Paper**: 800 x 480

**Rotation Examples:**
```json
"rotation": 0    // Normal (landscape)
"rotation": 90   // Portrait (clockwise)
"rotation": 180  // Upside down
"rotation": 270  // Portrait (counter-clockwise)
```

---

## 📊 History Settings

### Dose History Configuration

```json
"history": {
  "maxEntries": 100,
  "storageType": "localStorage"
}
```

| Parameter | Type | Options | Description |
|-----------|------|---------|-------------|
| `maxEntries` | integer | 1-1000 | Number of doses to store |
| `storageType` | string | "localStorage" | Where to store history |

**Storage Considerations:**
- **localStorage**: Browser-based, survives reboots
- **maxEntries**: Higher values use more storage
- **Recommendation**: 100 entries = ~3 months of 2x daily doses

---

## 🔔 Notification Settings

```json
"notifications": {
  "visual": true,
  "audio": false,
  "vibration": false
}
```

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `visual` | boolean | true | Invert display colors on alert |
| `audio` | boolean | false | Play sound (requires speaker) |
| `vibration` | boolean | false | Vibrate (requires motor) |

**Note:** Audio and vibration require additional hardware not included in base setup.

---

## 🎨 UI Settings

### User Interface Configuration

```json
"ui": {
  "theme": "blackwhite",
  "font": "monospace",
  "language": "en"
}
```

### Theme Options

| Theme | Description | Best For |
|-------|-------------|----------|
| `blackwhite` | High contrast B&W | E-Paper displays (default) |
| `grayscale` | Shades of gray | 4-bit e-Paper |
| `color` | Full color | LCD displays |

### Font Options

| Font | Description | Readability |
|------|-------------|-------------|
| `monospace` | Fixed-width (Courier) | Best on e-Paper ⭐ |
| `sans-serif` | Clean modern font | Good on LCD |
| `serif` | Traditional font | Medium readability |

### Language Codes

```json
"language": "en"    // English (default)
"language": "es"    // Spanish
"language": "fr"    // French
"language": "de"    // German
```

**Note:** Multi-language support requires translation files (coming in v2.0)

---

## 🔧 Advanced Configuration

### Custom Alert Messages

Edit `index.html` to customize alert text:

```javascript
document.getElementById('alertMessage').textContent = 'YOUR CUSTOM MESSAGE';
```

### Change Time Format

Default: 12-hour (AM/PM)

To use 24-hour format, edit `index.html`:

```javascript
const timeString = now.toLocaleTimeString('en-US', { 
    hour12: false,  // Change from true to false
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit'
});
```

### Adjust Countdown Format

Edit countdown display in `index.html`:

```javascript
// Current format: "12h 34m 56s"
// Change to: "12:34:56"
const countdownText = `${hours}:${String(minutes).padStart(2, '0')}:${String(seconds).padStart(2, '0')}`;
```

---

## 📋 Configuration Examples

### Example 1: Senior Care (Multiple Daily Doses)

```json
{
  "schedule": [
    {"name": "Breakfast Meds", "hour": 8, "minute": 0, "enabled": true},
    {"name": "Mid-Morning", "hour": 10, "minute": 30, "enabled": true},
    {"name": "Lunch Meds", "hour": 12, "minute": 0, "enabled": true},
    {"name": "Afternoon", "hour": 15, "minute": 0, "enabled": true},
    {"name": "Dinner Meds", "hour": 18, "minute": 0, "enabled": true},
    {"name": "Bedtime", "hour": 21, "minute": 0, "enabled": true}
  ],
  "settings": {
    "timezone": "America/New_York",
    "alertWindow": 600
  }
}
```

### Example 2: Simple Twice Daily

```json
{
  "schedule": [
    {"name": "Morning", "hour": 8, "minute": 0, "enabled": true},
    {"name": "Evening", "hour": 20, "minute": 0, "enabled": true}
  ],
  "settings": {
    "timezone": "America/Chicago",
    "alertWindow": 300
  }
}
```

### Example 3: Work Schedule (Avoids Work Hours)

```json
{
  "schedule": [
    {"name": "Before Work", "hour": 6, "minute": 30, "enabled": true},
    {"name": "After Work", "hour": 18, "minute": 30, "enabled": true},
    {"name": "Bedtime", "hour": 22, "minute": 0, "enabled": true}
  ],
  "settings": {
    "timezone": "America/Los_Angeles",
    "alertWindow": 900
  }
}
```

---

## 🔄 Applying Configuration Changes

### Web-Based Deployment

1. Edit `config.json`
2. Upload to your hosting provider
3. Refresh the browser on your Pi:
   ```bash
   # SSH into Pi
   ssh pi@raspberrypi.local
   
   # Restart Chromium
   sudo systemctl restart lightdm
   ```

### Local Deployment

1. Edit `config.json` on the Pi
2. Refresh browser (Ctrl+F5 or reboot)

### Verify Changes

```bash
# Check if config is valid JSON
python3 -m json.tool config.json

# Should output formatted JSON if valid
```

---

## ✅ Configuration Checklist

Before deploying, verify:

- [ ] All times use 24-hour format (0-23)
- [ ] Timezone matches your location
- [ ] Alert window is reasonable (300-900 seconds)
- [ ] Medication names are clear and readable
- [ ] At least one dose is enabled
- [ ] JSON syntax is valid (no trailing commas)
- [ ] Display dimensions match your hardware

---

## 🐛 Common Configuration Errors

### Error: Doses Not Triggering

**Cause:** Wrong timezone  
**Fix:** Verify timezone setting matches your location

```json
"timezone": "America/New_York"  // Check this matches your actual timezone
```

### Error: Alert Shows at Wrong Time

**Cause:** Hour format confusion  
**Fix:** Use 24-hour format (0-23, not 1-12)

```json
// ❌ Wrong
"hour": 8  // Could be 8 AM or 8 PM

// ✅ Correct - Be explicit
"hour": 8   // 8:00 AM
"hour": 20  // 8:00 PM
```

### Error: Config Not Loading

**Cause:** Invalid JSON syntax  
**Fix:** Validate JSON

```bash
# Use online validator: https://jsonlint.com/
# Or Python:
python3 -m json.tool config.json
```

Common JSON mistakes:
- Trailing commas
- Missing quotes
- Unclosed brackets

---

## 📞 Need Help?

- See [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
- Open a GitHub issue
- Check example configs in `/examples/` directory

---

**Next:** [Hardware Assembly Guide](HARDWARE.md)