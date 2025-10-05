# 🔧 Hardware Assembly Guide

Complete guide for assembling your Medicine Reminder e-Paper display.

---

## 📦 Bill of Materials (BOM)

### Required Components

| Component | Specifications | Quantity | Est. Price | Purchase Link |
|-----------|---------------|----------|------------|---------------|
| Raspberry Pi Zero 2 W | WiFi/BT 4.1, Quad-core | 1 | $15 | [Adafruit](https://www.adafruit.com/product/5291) |
| Waveshare 2.13" e-Paper HAT | 250x122px, Touch, SPI | 1 | $32 | [Amazon](https://www.amazon.com/s?k=waveshare+2.13+epaper) |
| MicroSD Card | 16GB+, Class 10 | 1 | $10 | Any retailer |
| USB Power Supply | 5V/2.5A micro-USB | 1 | $8 | [Official Pi Store](https://www.raspberrypi.com/products/) |
| MicroSD Card Reader | USB adapter | 1 | $5 | Any retailer |

**Total Required:** ~$70

### Optional Components

| Component | Purpose | Price |
|-----------|---------|-------|
| Case with e-Paper cutout | Protection | $10-15 |
| Mini speaker (3W) | Audio alerts | $5 |
| Vibration motor | Tactile alerts | $3 |
| GPIO buttons | Physical controls | $2 |
| 3D printed stand | Desktop mounting | $5 |

---

## 🛠️ Tools Needed

- ❌ **No soldering required!**
- Computer with SD card reader
- Internet connection (for setup)
- Optional: Small screwdriver (for case assembly)

---

## 📐 Hardware Specifications

### Raspberry Pi Zero 2 W

```
Processor:    Broadcom BCM2710A1, quad-core 64-bit SoC
RAM:          512MB LPDDR2
Wireless:     802.11 b/g/n WiFi, Bluetooth 4.1, BLE
GPIO:         40-pin header
Power:        5V via micro-USB
Dimensions:   65mm × 30mm × 5mm
```

### Waveshare 2.13" e-Paper Display V4

```
Display Size:     2.13 inches
Resolution:       250 × 122 pixels
Display Color:    Black, White
Viewing Angle:    >170°
Interface:        SPI
Refresh Time:     ~2 seconds (full refresh)
Power (Active):   ~12mA @ 3.3V
Power (Sleep):    <0.01mA
Touch:            Capacitive touch (optional model)
```

---

## 🔌 Assembly Instructions

### Step 1: Prepare the Raspberry Pi

1. **Verify GPIO Pins**
   - Ensure 40-pin header is intact
   - Check for bent or damaged pins
   - Clean any debris from header

2. **Check e-Paper HAT**
   - Verify all pins are straight
   - Check display for damage
   - Confirm model number (2.13" V4)

### Step 2: Attach e-Paper HAT

**IMPORTANT:** Always power off before connecting hardware!

1. **Align the HAT**
   - Position HAT above GPIO pins
   - Match pin 1 markings on both boards
   - Ensure proper orientation (display facing up)

   ```
   Pin 1 Location:
   ┌─────────────┐
   │ ● Pi Zero   │  ← Pin 1 (square pad)
   │             │
   └─────────────┘
   ```

2. **Press Down Firmly**
   - Apply even pressure across HAT
   - Push until fully seated
   - All 40 pins should be connected
   - No pins should be visible between boards

3. **Visual Check**
   - Verify HAT sits flush on GPIO
   - Check for gaps or misalignment
   - Ensure no bent pins

### Step 3: Insert MicroSD Card

1. Flash Raspberry Pi OS to card (see [INSTALLATION.md](INSTALLATION.md))
2. Insert card into slot on bottom of Pi Zero
3. Push until it clicks into place

### Step 4: Connect Power

1. **Use proper power supply** (5V/2.5A recommended)
2. Connect micro-USB to power port (not data port!)
3. Power port is on the **edge**, not center

```
Pi Zero 2 W Layout:
┌────────────────────────────┐
│  [USB Data] [USB Power]    │
│                            │
│    [GPIO Header]           │
└────────────────────────────┘
             ↑
         Power here!
```

---

## 🔗 GPIO Pin Connections

The e-Paper HAT uses these GPIO pins:

| Pin # | Name | Function | Direction |
|-------|------|----------|-----------|
| 19 | MOSI | SPI Data Out | Output |
| 21 | MISO | SPI Data In | Input |
| 23 | SCLK | SPI Clock | Output |
| 24 | CS | Chip Select | Output |
| 11 | RST | Reset | Output |
| 22 | DC | Data/Command | Output |
| 18 | BUSY | Busy Status | Input |

**Note:** These are already configured on the HAT - no wiring needed!

---

## 📦 Case Assembly (Optional)

### Recommended Cases

1. **Official Raspberry Pi Zero Case**
   - Modify top for e-Paper display
   - Use Dremel or knife to cut opening
   - Dimensions: 250mm × 122mm opening

2. **Custom 3D Printed Case**
   - STL files available: [Thingiverse](https://www.thingiverse.com/)
   - Search: "Raspberry Pi Zero e-Paper case"
   - Print with PLA or PETG

3. **Acrylic Sandwich Case**
   - Stack: Base → Pi → Spacers → e-Paper → Top
   - Secure with M2.5 screws and standoffs
   - Provides excellent visibility and cooling

### DIY Case Modification

If modifying an existing case:

1. **Measure Display Opening**
   ```
   Display active area: 48.55mm × 23.71mm
   Recommended cutout: 50mm × 25mm (adds 1mm margin)
   ```

2. **Mark and Cut**
   - Use masking tape to prevent cracking
   - Mark cutout with pencil
   - Drill corner holes first
   - Cut carefully with hobby knife or rotary tool

3. **Smooth Edges**
   - File rough edges
   - Use fine sandpaper (220 grit)
   - Test fit display before final assembly

---

## 🖥️ Desktop Mounting Options

### Option 1: Simple Stand

**Materials:**
- Small picture frame stand
- Double-sided tape
- Total cost: ~$3

**Steps:**
1. Attach Pi to back of stand with tape
2. Angle display for optimal viewing
3. Place on desk/nightstand

### Option 2: 3D Printed Stand

**Print Settings:**
- Layer height: 0.2mm
- Infill: 20%
- Material: PLA
- Print time: ~2 hours

**Features:**
- Adjustable viewing angle (30°-60°)
- Cable management channel
- Non-slip base

### Option 3: Wall Mount

**Materials:**
- Command strips (removable)
- Or small screws if permanent

**Installation:**
1. Mark desired location
2. Ensure power outlet nearby
3. Attach mounting hardware
4. Hang Pi assembly
5. Route power cable neatly

---

## 🔋 Power Considerations

### Power Requirements

| State | Power Draw | Notes |
|-------|------------|-------|
| Idle (no refresh) | 0.5W | E-paper static display |
| Active (refreshing) | 0.8W | During screen updates |
| Peak (boot) | 1.2W | First 30 seconds |

### Power Supply Selection

**Minimum:** 5V/1A (1000mA)  
**Recommended:** 5V/2.5A (2500mA)  
**Avoid:** Phone chargers <1A (may cause instability)

### Cable Length

- **Under 6 feet:** Any quality cable works
- **Over 6 feet:** Use thicker gauge (20 AWG or better)
- **Maximum:** 10 feet recommended

### Battery Operation (Advanced)

For portable/backup power:

**Option 1: USB Power Bank**
- Capacity: 10,000mAh
- Runtime: ~3 weeks continuous
- Cost: $15-25

**Option 2: UPS Hat**
- Waveshare UPS HAT (C)
- Runtime: 4-8 hours on battery
- Auto-switches during power loss
- Cost: ~$35

---

## 🌡️ Environmental Considerations

### Operating Temperature

| Display Type | Min | Max | Optimal |
|--------------|-----|-----|---------|
| E-Paper | 0°C | 50°C | 20-25°C |
| Raspberry Pi | 0°C | 50°C | 20-30°C |

**Note:** E-paper refresh may be slower at temperature extremes

### Placement Recommendations

**✅ Good Locations:**
- Bedside table
- Desk/workspace
- Kitchen counter
- Bathroom counter (away from direct water)

**❌ Avoid:**
- Direct sunlight (reduces e-paper visibility)
- High humidity areas (>80% RH)
- Near heat sources (radiators, vents)
- Outdoor exposure

### Humidity

- **Safe range:** 20-80% RH
- **Optimal:** 40-60% RH
- **Extreme humidity:** May affect adhesive and cause condensation

---

## 🧪 Testing After Assembly

### Step 1: Visual Inspection

Before powering on:

- [ ] All GPIO pins connected
- [ ] No bent pins
- [ ] SD card fully inserted
- [ ] Power cable secure
- [ ] No loose components
- [ ] Display not cracked

### Step 2: First Power On

1. **Connect power** (LED should light up)
2. **Wait for boot** (~30-60 seconds)
3. **Check for activity light** (flashing = good)
4. **Wait for display refresh** (may take 2-3 minutes first time)

### Step 3: Display Test

Run Waveshare test script:

```bash
cd ~/e-Paper/RaspberryPi_JetsonNano/python/examples
python3 epd_2in13_V4_test.py
```

**Expected behavior:**
- Display clears to white
- Shows test pattern
- Updates several times
- Returns to clear state

### Step 4: Touch Test (if applicable)

```bash
# Install evtest
sudo apt-get install evtest

# Run touch test
sudo evtest

# Select your touch device
# Touch screen - events should appear
```

---

## 🔧 Hardware Troubleshooting

### Problem: No Display Activity

**Possible Causes:**
1. HAT not fully seated on GPIO
2. Wrong display model/driver
3. SPI not enabled

**Solutions:**
```bash
# Check SPI
ls /dev/spidev*
# Should show: /dev/spidev0.0 and /dev/spidev0.1

# Enable SPI if missing
sudo raspi-config
# Interface Options > SPI > Enable
```

### Problem: Display Shows Garbage/Static

**Possible Causes:**
1. Power supply insufficient
2. Loose connection
3. Wrong driver version

**Solutions:**
1. Try official Pi power supply
2. Reseat HAT connection
3. Verify display model (2.13" V4)

### Problem: Display Updates Very Slowly

**Normal behavior:** E-paper takes 2-4 seconds to refresh  
**If slower:** Check ambient temperature (refresh slower when cold)

### Problem: Touch Not Responding

**Check:**
1. Verify you have touch-enabled version
2. Check for protective film still on display
3. Ensure touch driver installed

```bash
# List input devices
ls /dev/input/
# Should show event devices

# Test touch
sudo evtest
```

### Problem: Pi Not Booting

**LED Behavior Guide:**

| LED Pattern | Meaning | Solution |
|-------------|---------|----------|
| Solid red only | No SD card | Check SD card inserted |
| Red + green flash | Normal boot | Wait 60 seconds |
| No lights | No power | Check power supply |
| Red only, no green | SD card issue | Reflash SD card |

---

## 🛡️ Protection & Maintenance

### Screen Protection

1. **Avoid pressing hard** - E-paper is delicate
2. **Clean gently** - Microfiber cloth only
3. **No liquids** - Keep away from water/cleaning solutions
4. **Transport carefully** - Display can crack if bent

### Long-Term Care

**Weekly:**
- Wipe display with dry microfiber cloth
- Check power cable connection

**Monthly:**
- Inspect GPIO connection
- Check for dust buildup
- Verify mounting is secure

**Yearly:**
- Consider SD card backup
- Check power supply health
- Clean case vents (if applicable)

### Screen Burn-In Prevention

E-paper doesn't have traditional burn-in, but:
- **Ghost images:** Can occur from static content
- **Solution:** Full display refresh daily (automatic in code)
- **Prevention:** Display cycles through patterns periodically

---

## 📊 Hardware Specifications Summary

### System Overview

```
┌─────────────────────────────────┐
│  2.13" E-Paper Display          │
│  250×122px Monochrome           │
└─────────────────┬───────────────┘
                  │ (40-pin GPIO)
┌─────────────────┴───────────────┐
│  Raspberry Pi Zero 2 W          │
│  • BCM2710A1 (4 cores @ 1GHz)   │
│  • 512MB RAM                    │
│  • WiFi 802.11n, BT 4.1         │
└─────────────────┬───────────────┘
                  │ (micro-USB)
┌─────────────────┴───────────────┐
│  5V Power Supply                │
│  2.5A recommended               │
└─────────────────────────────────┘
```

### Physical Dimensions

**Assembled (without case):**
- Length: 65mm (Pi Zero width)
- Width: 60mm (HAT extends slightly)
- Height: 15mm (stacked)
- Weight: ~30g

**With Case:**
- Varies by case design
- Typical: 70mm × 65mm × 20mm

---

## 🔗 Additional Resources

### Official Documentation

- [Raspberry Pi Zero 2 W Docs](https://www.raspberrypi.com/products/raspberry-pi-zero-2-w/)
- [Waveshare e-Paper Wiki](https://www.waveshare.com/wiki/2.13inch_e-Paper_HAT)
- [Waveshare GitHub](https://github.com/waveshare/e-Paper)

### Community Resources

- [Raspberry Pi Forums](https://forums.raspberrypi.com/)
- [r/raspberry_pi](https://reddit.com/r/raspberry_pi)
- [Instructables - Pi Projects](https://www.instructables.com/circuits/raspberry-pi/projects/)

### Video Tutorials

Search YouTube for:
- "Raspberry Pi Zero e-Paper setup"
- "Waveshare e-Paper HAT tutorial"
- "Pi Zero GPIO HAT installation"

---

## 🎨 Customization Ideas

### Physical Modifications

**3D Printed Additions:**
- Custom bezels
- Mounting brackets
- Cable management clips
- Button enclosures

**Case Enhancements:**
- Add acrylic window
- LED status indicators
- Physical snooze button (GPIO)
- Speaker grille

### Advanced Hardware Add-ons

**Audio Alerts:**
```
Mini speaker → GPIO 18 (PWM)
Amplifier: PAM8403 (optional)
Cost: ~$5-10
```

**Physical Buttons:**
```
Confirm button → GPIO 17
Snooze button → GPIO 27
Both with pull-up resistors
Cost: ~$2
```

**Status LED:**
```
LED → GPIO 23 + 220Ω resistor
Colors: Green (on), Red (alert), Blue (confirmed)
Cost: ~$1
```

---

## ✅ Assembly Checklist

Print this checklist for assembly:

- [ ] All parts received and verified
- [ ] Raspberry Pi OS flashed to SD card
- [ ] GPIO pins inspected (no damage)
- [ ] e-Paper HAT aligned correctly
- [ ] HAT pressed firmly until seated
- [ ] All 40 pins connected
- [ ] SD card inserted and clicked
- [ ] Power supply connected to correct port
- [ ] First boot successful (LED activity)
- [ ] Display shows test pattern
- [ ] Touch input working (if applicable)
- [ ] Case assembled (if using one)
- [ ] Mounted in desired location
- [ ] Power cable secured and organized
- [ ] Ready for software configuration

---

## 📞 Support

### Hardware Issues

**For defective components:**
- Contact retailer within return window
- Waveshare support: [service@waveshare.com](mailto:service@waveshare.com)
- Raspberry Pi support: [raspberrypi.com/help](https://www.raspberrypi.com/help/)

### Assembly Help

- See [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
- Post photos on project GitHub issues
- Raspberry Pi community forums

---

**Next:** [Software Installation Guide](INSTALLATION.md)

**Hardware assembly complete!** 🎉

Time to install the software and configure your medication reminders.