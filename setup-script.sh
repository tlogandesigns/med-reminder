#!/bin/bash

# Medicine Reminder - Automated Setup Script
# For Raspberry Pi Zero 2 W with Waveshare 2.13" e-Paper Display

set -e

echo "=========================================="
echo "Medicine Reminder - Setup Script"
echo "=========================================="
echo ""

# Check if running on Raspberry Pi
if [ ! -f /proc/device-tree/model ]; then
    echo "⚠️  Warning: This doesn't appear to be a Raspberry Pi"
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

echo "📦 Updating system packages..."
sudo apt-get update
sudo apt-get upgrade -y

echo ""
echo "🔧 Installing dependencies..."
sudo apt-get install -y \
    chromium-browser \
    unclutter \
    python3-pip \
    python3-pil \
    python3-numpy \
    git

echo ""
echo "📡 Installing Python libraries..."
sudo pip3 install RPi.GPIO spidev

echo ""
echo "🖥️  Enabling SPI interface..."
sudo raspi-config nonint do_spi 0

echo ""
echo "⏰ Setting timezone to America/New_York..."
sudo timedatectl set-timezone America/New_York

echo ""
echo "📥 Installing Waveshare e-Paper libraries..."
cd ~
if [ -d "e-Paper" ]; then
    echo "   e-Paper library already exists, skipping..."
else
    git clone https://github.com/waveshare/e-Paper
    echo "   ✓ Waveshare libraries installed"
fi

echo ""
echo "🚫 Disabling screen blanking..."
sudo bash -c 'cat >> /etc/lightdm/lightdm.conf << EOF

[Seat:*]
xserver-command=X -s 0 -dpms
EOF'

echo ""
echo "🌐 Configuring kiosk mode..."

# Get the hosting URL from user
read -p "Enter your web app URL (e.g., https://yourproject.makershost.io): " KIOSK_URL

if [ -z "$KIOSK_URL" ]; then
    echo "⚠️  No URL provided. You'll need to configure this manually."
    KIOSK_URL="http://localhost:8000"
fi

# Create autostart directory
mkdir -p ~/.config/lxsession/LXDE-pi

# Create autostart file
cat > ~/.config/lxsession/LXDE-pi/autostart << EOF
@xset s off
@xset -dpms
@xset s noblank
@chromium-browser --kiosk --window-size=250,122 --window-position=0,0 --incognito $KIOSK_URL
@unclutter -idle 0
EOF

echo "   ✓ Kiosk mode configured for: $KIOSK_URL"

echo ""
echo "📝 Creating systemd service (optional Python version)..."
sudo bash -c "cat > /etc/systemd/system/medicine-reminder.service << EOF
[Unit]
Description=Medicine Reminder
After=network.target

[Service]
Type=simple
User=$USER
WorkingDirectory=$(pwd)
ExecStart=/usr/bin/python3 $(pwd)/src/medicine_reminder.py
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF"

echo "   ✓ Systemd service created (disabled by default)"
echo "   To enable: sudo systemctl enable medicine-reminder"

echo ""
echo "=========================================="
echo "✅ Setup Complete!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. Upload index.html to your hosting provider"
echo "2. Update the KIOSK_URL in ~/.config/lxsession/LXDE-pi/autostart"
echo "3. Reboot: sudo reboot"
echo ""
echo "Or test now by running:"
echo "   chromium-browser --kiosk $KIOSK_URL"
echo ""
echo "📚 For more help, see docs/INSTALLATION.md"
echo ""