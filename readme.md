# 💊 Medicine Reminder Kiosk

A dedicated e-Paper display medicine reminder system built for Raspberry Pi Zero 2 W with 2.13" Waveshare touch e-Paper display.

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Platform](https://img.shields.io/badge/platform-Raspberry%20Pi-red.svg)
![E-Paper](https://img.shields.io/badge/display-e--Paper-green.svg)

## 📋 Features

- ⏰ **Scheduled Reminders** - Morning (7:45 AM) and Night (10:00 PM) EST
- 🖥️ **E-Paper Optimized** - Black & white display, ultra-low power consumption
- 📊 **Dose Tracking** - Logs every dose with timestamp in browser localStorage
- 🔄 **Always On** - Countdown to next dose visible 24/7
- 📱 **Responsive Alerts** - High contrast inverted display when dose is due
- 📈 **History View** - Review past 100 doses taken
- 🌐 **Web-Based** - Easy updates, no code deployment needed
- 👆 **Touch Interface** - Simple one-button confirmation

## 🎯 Why This Project?

Traditional phone reminders are easy to dismiss and forget. A dedicated, always-visible display:
- Can't be silenced or swiped away
- Sits on your desk/nightstand as a constant reminder
- Provides visual confirmation of medication schedule
- Tracks adherence patterns over time
- Ultra-low power (costs ~$0.03/month to run)

## 🛠️ Hardware Requirements

| Component | Model | Price | Notes |
|-----------|-------|-------|-------|
| **Microcontroller** | Raspberry Pi Zero 2 W | ~$15 | WiFi/Bluetooth built-in |
| **Display** | Waveshare 2.13" Touch e-Paper | ~$32 | 250x122px, 1-bit B&W |
| **Storage** | MicroSD Card (16GB) | ~$10 | Class 10 recommended |
| **Power** | 5V/2.5A USB Power Supply | ~$8 | Official Pi power supply |
| **Case** | Optional enclosure | ~$10 | Protects hardware |

**Total Cost:** ~$50-75 (depending on case/accessories)

### Why These Components?

- **Pi Zero 2 W**: Quad-core CPU handles web browsing smoothly, WiFi for remote updates
- **2.13" e-Paper**: Perfect size for bedside table, readable in any light, extremely low power
- **Touch Screen**: Simple interaction without physical buttons

## 📦 Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/tlogandesigns/medicine-reminder.git
cd medicine-reminder
```

### 2. Hardware Setup

1. Flash Raspberry Pi OS to microSD card
2. Attach Waveshare 2.13" e-Paper HAT to GPIO pins
3. Insert SD card and connect power

See [docs/HARDWARE.md](docs/HARDWARE.md) for detailed assembly instructions.

### 3. Automated Installation

```bash
# SSH into your Raspberry Pi
ssh pi@raspberrypi.local

# Clone and run setup
git clone https://github.com/YOUR_USERNAME/medicine-reminder.git
cd medicine-reminder
chmod +x setup.sh
./setup.sh
```

The setup script will:
- Install Chromium browser and dependencies
- Enable SPI for e-Paper display
- Configure timezone to EST
- Set up kiosk mode auto-start
- Install Waveshare display drivers

See [docs/INSTALLATION.md](docs/INSTALLATION.md) for manual installation steps.

### 4. Configure Your Schedule

Edit `config.json` to match your medication times:

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

See [docs/CONFIGURATION.md](docs/CONFIGURATION.md) for all configuration options.

### 5. Deploy & Reboot

**Option A: Web Hosting (Recommended)**
```bash
# Upload index.html to MakersHost, Netlify, GitHub Pages, etc.
# Update URL in ~/.config/lxsession/LXDE-pi/autostart
sudo reboot
```

**Option B: Local Server**
```bash
# Run local Python server
python3 -m http.server 8000 &
sudo reboot
```

## 🖥️ How It Works

### Normal State
- Displays current time in large text
- Shows countdown to next medication dose
- Indicates which medicine is next (Morning/Night)
- Clean white background with black text

### Alert State (5 minutes before/after dose time)
- Background inverts to black with white text
- Large "TAKE MEDICINE NOW" message
- Big "TOOK IT" button appears
- Display pulses to grab attention

### After Confirmation
- Logs timestamp to browser localStorage
- Shows "LOGGED!" success message
- Returns to countdown for next dose
- Updates dose history

## 📊 Dose History

Tap the "History" button in the bottom-right corner to view:
- Last 10 doses taken
- Medication name
- Scheduled time vs actual time taken
- Full history of last 100 doses stored locally

## 🔋 Power Consumption

- **Idle State**: ~0.5W (e-Paper only refreshes when content changes)
- **Alert State**: ~0.8W
- **Daily Average**: <12Wh
- **Monthly Cost**: ~$0.03 at $0.12/kWh

E-Paper displays only consume power during refresh, making them ideal for always-on applications.

## 🎨 Customization

### Change Medication Schedule
Edit times in `config.json` and refresh the page.

### Adjust Alert Window
```json
"alertWindow": 300  // 5 minutes in seconds
```

### Modify Display
Edit `index.html` CSS - optimized for 250x122px but customizable.

### Add More Medications
Add entries to the `schedule` array - supports unlimited doses per day.

## 📁 Project Structure

```
medicine-reminder/
├── README.md                   # This file
├── LICENSE                     # MIT License
├── .gitignore                  # Git ignore rules
├── index.html                  # Main web application (e-Paper optimized)
├── config.json                 # Medication schedule configuration
├── setup.sh                    # Automated Raspberry Pi setup script
├── docs/
│   ├── INSTALLATION.md         # Detailed installation guide
│   ├── CONFIGURATION.md        # Configuration options reference
│   ├── HARDWARE.md             # Hardware assembly guide
│   └── TROUBLESHOOTING.md      # Common issues and solutions
└── systemd/
    └── medicine-reminder.service  # Optional systemd service
```

## 🚀 Deployment Options

### Web-Based Kiosk (Recommended)
**Pros:**
- ✅ Easy remote updates (just refresh browser)
- ✅ No code deployment needed on Pi
- ✅ Can host on free services (MakersHost, Netlify, GitHub Pages)
- ✅ Full JavaScript features available

**Cons:**
- ⚠️ Requires internet connection
- ⚠️ Slightly higher power consumption (~0.5W vs 0.2W)

**Best for:** Most users, especially if medication schedule changes

### Python Direct Rendering (Advanced)
**Pros:**
- ✅ Ultra-low power consumption
- ✅ Works completely offline
- ✅ Direct control over e-Paper hardware

**Cons:**
- ⚠️ Requires Python code changes for updates
- ⚠️ More complex setup

**Best for:** Users wanting maximum battery life or offline operation

## 🔧 Advanced Features

### Add Physical Buttons
Use GPIO pins for hardware buttons instead of touch:
```python
import RPi.GPIO as GPIO
GPIO.setup(17, GPIO.IN, pull_up_down=GPIO.PUD_UP)
```

### Email/SMS Notifications
Integrate with Twilio or SendGrid for backup notifications if dose is missed.

### Multiple Users
Extend `config.json` to support multiple people with different schedules.

### Voice Confirmation
Add Text-to-Speech: "Time to take your morning medicine"

## 🐛 Troubleshooting

### Display Not Working
```bash
# Verify SPI is enabled
ls /dev/spidev*
# Should show: /dev/spidev0.0  /dev/spidev0.1
```

### Wrong Timezone
```bash
sudo timedatectl set-timezone America/New_York
```

### Kiosk Not Auto-Starting
```bash
# Check autostart file
cat ~/.config/lxsession/LXDE-pi/autostart
```

See [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) for complete troubleshooting guide.

## 📚 Documentation

- [Installation Guide](docs/INSTALLATION.md) - Step-by-step setup instructions
- [Configuration Reference](docs/CONFIGURATION.md) - All config options explained
- [Hardware Assembly](docs/HARDWARE.md) - Physical setup guide
- [Troubleshooting](docs/TROUBLESHOOTING.md) - Common issues and fixes

## 🤝 Contributing

Contributions welcome! Please:
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

Ideas for contributions:
- [ ] Add audio alerts using buzzer/speaker
- [ ] Mobile companion app for remote monitoring
- [ ] SMS/Email notification integration
- [ ] Multiple user profiles
- [ ] Medication refill reminders
- [ ] Export dose history to CSV

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👤 Author

**Logan Eason**  
Director of Innovation & Digital Solutions  
Berkshire Hathaway HomeServices Beazley, REALTORS

- GitHub: [@tlogandesigns](https://github.com/tlogandesigns)
- LinkedIn: [loganeason](https://linkedin.com/in/loganeason)
- Website: [your-website.com](https://your-website.com)

## 🙏 Acknowledgments

- [Waveshare](https://www.waveshare.com/) for excellent e-Paper HAT documentation
- [Raspberry Pi Foundation](https://www.raspberrypi.org/) for affordable hardware
- [Bootstrap](https://getbootstrap.com/) for CSS framework

## ⭐ Support

If this project helped you or someone you care about remember their medication, please consider:
- Starring the repository ⭐
- Sharing with others who might benefit
- Contributing improvements
- Opening issues for bugs or feature requests

---

**Built with ❤️ for reliable medication adherence**

## 🔗 Related Projects

- [PiMoroni Inky Display Projects](https://github.com/pimoroni/inky)
- [MagicMirror](https://github.com/MichMich/MagicMirror) - Similar always-on display concept
- [Home Assistant](https://www.home-assistant.io/) - For home automation integration

## 📊 Project Status

**Current Version:** 1.0.0  
**Status:** Active Development  
**Last Updated:** October 2025

### Roadmap

- [x] Basic medication reminders
- [x] E-Paper display support
- [x] Dose history tracking
- [ ] Audio alerts (v1.1)
- [ ] Mobile app companion (v1.2)
- [ ] Email/SMS notifications (v1.2)
- [ ] Multi-user support (v2.0)