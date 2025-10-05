# 📦 Installation Guide

Complete step-by-step instructions for setting up the Medicine Reminder system.

## 🎯 Prerequisites

### Hardware
- Raspberry Pi Zero 2 W (with WiFi enabled)
- Waveshare 2.13" Touch e-Paper Display
- MicroSD card (16GB minimum, Class 10 recommended)
- 5V/2.5A USB power supply
- MicroSD card reader
- Computer for initial setup

### Software
- Raspberry Pi OS (latest version)
- Internet connection

---

## 🚀 Step 1: Prepare Raspberry Pi OS

### Download and Flash OS

1. **Download Raspberry Pi Imager**
   - Visit: https://www.raspberrypi.com/software/
   - Install for your operating system

2. **Flash SD Card**
   - Insert microSD card into your computer
   - Open Raspberry Pi Imager
   - Choose: **Raspberry Pi OS (32-bit)** or **Raspberry Pi OS Lite**
   - Select your SD card
   - Click "Write"

3. **Enable SSH & WiFi (Headless Setup)**
   
   After flashing, create these files in the boot partition:
   
   **ssh** (empty file, no extension)
   ```bash
   touch /Volumes/boot/ssh
   ```
   
   **wpa_supplicant.conf**
   ```conf
   country=US
   ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
   update_config=1

   network={
       ssid="YOUR_WIFI_NAME"
       psk="YOUR_WIFI_PASSWORD"
       key_mgmt=WPA-PSK
   }
   ```

4. **Boot Raspberry Pi**
   - Insert SD card into Pi
   - Connect power
   - Wait 2-3 minutes for first boot

---

## 🔧 Step 2: Initial Configuration

### Connect via SSH

```bash
# Find your Pi's IP address (check your router, or use)
ping raspberrypi.local

# SSH into your Pi (default password: raspberry)
ssh pi@raspberrypi.local
```

### Update System

```bash
# Update package lists
sudo apt-get update

# Upgrade all packages
sudo apt-get upgrade -y

# Reboot
sudo reboot
```

### Change Default Password

```bash
passwd
# Enter new password when prompted
```

---

## 📥 Step 3: Install Medicine Reminder

### Option A: Automated Installation (Recommended)

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/medicine-reminder.git
cd medicine-reminder

# Make setup script executable
chmod +x setup.sh

# Run setup
./setup.sh
```

The script will:
- Install all dependencies
- Enable SPI for e-Paper display
- Configure timezone
- Set up kiosk mode
- Create systemd service

### Option B: Manual Installation

```bash
# Install system packages
sudo apt-get install -y chromium-browser unclutter python3-pip python3-pil python3-numpy git

# Install Python libraries
sudo pip3 install RPi.GPIO spidev

# Enable SPI
sudo raspi-config
# Navigate to: Interface Options > SPI > Enable > Finish

# Clone Waveshare e-Paper library
cd ~
git clone https://github.com/waveshare/e-Paper

# Clone medicine reminder
git clone https://github.com/YOUR_USERNAME/medicine-reminder.git
cd medicine-reminder
```

---

## 🖥️ Step 4: Hardware Assembly

### Connect e-Paper Display

1. **Power off Raspberry Pi**
   ```bash
   sudo shutdown -h now
   ```

2. **Attach HAT**
   - Align 40-pin GPIO header
   - Press firmly until seated
   - Ensure all pins are connected

3. **Power back on**
   ```bash
   # Connect power supply
   ```

### Verify SPI Connection

```bash
# Check if SPI is enabled
ls /dev/spidev*
# Should show: /dev/spidev0.0  /dev/spidev0.1

# Test e-Paper display (optional)
cd ~/e-Paper/RaspberryPi_JetsonNano/python/examples
python3 epd_2in13_V4_test.py
```

---

## 🌐 Step 5: Deploy Web Application

### Option A: Deploy to MakersHost (or any hosting)

1. **Upload `index.html` to your hosting provider**
2. **Get your public URL**
3. **Update kiosk configuration**

```bash
nano ~/.config/lxsession/LXDE-pi/autostart
```

Update the URL:
```
@chromium-browser --kiosk --window-size=250,122 --incognito https://your-url.makershost.io
```

### Option B: Local Python Server

```bash
# From medicine-reminder directory
python3 -m http.server 8000

# Update autostart to use localhost
@chromium-browser --kiosk --window-size=250,122 --incognito http://localhost:8000
```

---

## ⚙️ Step 6: Configure Medication Schedule

Edit `config.json`:

```bash
cd ~/medicine-reminder
nano config.json
```

Modify schedule:
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

---

## 🎨 Step 7: Configure Auto-Start Kiosk

### Create Autostart File

```bash
mkdir -p ~/.config/lxsession/LXDE-pi
nano ~/.config/lxsession/LXDE-pi/autostart
```

Add these lines:
```
@xset s off
@xset -dpms
@xset s noblank
@chromium-browser --kiosk --window-size=250,122 --window-position=0,0 --incognito YOUR_URL
@unclutter -idle 0
```

### Disable Screen Blanking

```bash
sudo nano /etc/lightdm/lightdm.conf
```

Add under `[Seat:*]`:
```
xserver-command=X -s 0 -dpms
```

---

## 🔄 Step 8: Final Steps

### Set Timezone

```bash
sudo timedatectl set-timezone America/New_York
```

### Test Before Reboot

```bash
# Test kiosk mode manually
chromium-browser --kiosk --window-size=250,122 YOUR_URL
```

### Reboot and Verify

```bash
sudo reboot
```

After reboot:
- Display should show current time
- Countdown to next dose should be visible
- Touch "History" button to verify touch is working

---

## ✅ Verification Checklist

- [ ] Raspberry Pi boots automatically
- [ ] e-Paper display shows content
- [ ] Touch input responds
- [ ] Clock shows correct time (EST)
- [ ] Countdown updates every second
- [ ] Alert triggers at scheduled times
- [ ] "I TOOK IT" button logs doses
- [ ] History shows past doses

---

## 🐛 Troubleshooting

### Display Shows Nothing
```bash
# Check SPI
lsmod | grep spi
# Should show spi_bcm2835

# Enable SPI
sudo raspi-config
# Interface Options > SPI > Enable
```

### Wrong Time Zone
```bash
sudo timedatectl set-timezone America/New_York
```

### Kiosk Doesn't Start
```bash
# Check autostart file
cat ~/.config/lxsession/LXDE-pi/autostart

# Check for errors
sudo systemctl status lightdm
```

### Touch Not Responding
```bash
# Check for input devices
ls /dev/input/
# Should show event devices

# Test touch
evtest
# Select your touch device and test
```

---

## 📞 Need Help?

- Check [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
- Open an issue on GitHub
- Contact: your-email@example.com

---

**Next:** See [CONFIGURATION.md](CONFIGURATION.md) for customization options