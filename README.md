# Brain Workshop (Modernized Linux Edition)

![Brain Workshop Logo](res/misc/brain/brain.png)

> **A robust, open-source implementation of the Dual N-Back mental exercise, modernized for contemporary Linux systems.**

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Python Version](https://img.shields.io/badge/python-2.7-yellow.svg)](https://www.python.org/download/releases/2.7/)
[![Platform](https://img.shields.io/badge/platform-linux-green.svg)]()

## 🧠 What is Brain Workshop?

Brain Workshop is a free, open-source implementation of the **Dual N-Back** task, a mental exercise that has been shown in research studies to potentially improve **working memory (short-term memory)** and **fluid intelligence**.

In the Dual N-Back task, you are presented with a sequence of visual and auditory stimuli. Your goal is to indicate when the current stimulus matches the one from *N* steps earlier in the sequence.

## 🚀 The Modernization Project

The original Brain Workshop (v4.8.4) was built years ago and relies on older libraries that often break on modern Linux distributions (Arch, Ubuntu 20.04+, Fedora). This repository contains a **heavily patched and modernized version** that restores full functionality and adds new features.

### Key Improvements in This Version

#### 🔊 Audio Engine Overhaul
*   **No More Cut-offs**: Replaced the obsolete `ManagedSoundPlayer` with a robust, custom audio management system. Sounds now play to completion without being garbage-collected prematurely.
*   **3D Spatial Audio**: Fixed and verified spatial audio positioning. You can now clearly distinguish Left, Right, and Center audio channels.
*   **Independent Channels**: Added a new configuration menu to independently set the audio channel (Left/Right/Center) for both primary and secondary sound sets.

#### 🖥️ Graphics & Rendering
*   **Modern OpenGL Fixes**: Replaced deprecated `GL_POLYGON` calls with `GL_TRIANGLES`, fixing crashes and rendering artifacts on modern GPU drivers.
*   **Responsive Design**: The entire game interface (grid, squares, menus) is now **fully responsive**. Resize the window or maximize it, and the game adapts perfectly to your screen resolution.

#### 🎮 User Interface & Input
*   **Menu System Fixes**: Resolved critical bugs that made configuration menus (Keys C, S, I) inaccessible.
*   **Event Handling**: Refactored the event loop to correctly register/unregister handlers, preventing input conflicts.
*   **Visual Polish**: Improved menu alignment and text rendering for better readability.

---

## 📦 Installation

### Prerequisites
*   **Python 2.7**: This legacy application requires Python 2.
*   **Pyglet 1.4.10**: The specific version required for stability.
*   **AVBin**: Required for audio decoding (optional but recommended).

### Method 1: Quick Install (Debian/Ubuntu/Mint)
We provide a build script to generate a native `.deb` package.

```bash
# 1. Build the package
./build_deb.sh

# 2. Install the generated file
sudo dpkg -i brainworkshop_4.8.4_all.deb

# 3. Fix dependencies if needed
sudo apt-get install -f
```

### Method 2: Manual Installation (Arch/Fedora/Other)
You can install the game directly to `/opt/brainworkshop`.

```bash
# 1. Install Python 2 and pip
# (Command varies by distro, e.g., 'pacman -S python2 python2-pip' on Arch)

# 2. Install dependencies
pip2 install pyglet==1.4.10

# 3. Install the game
sudo make install
```

To uninstall later:
```bash
sudo make uninstall
```

---

## 🎮 Controls & Hotkeys

| Key | Action |
| :--- | :--- |
| **A** | Match **Position** (Visual) |
| **L** | Match **Sound** (Audio) |
| **Space** | Start Game / Skip Title |
| **Esc** | Pause / Exit to Menu |
| **M** | Toggle Manual Mode |
| **C** | Configuration Menu (Game Modes) |
| **S** | Sound Settings Menu |
| **I** | Image/Theme Settings Menu |
| **G** | View Progress Graph |

*Note: Keys can be remapped in `config.ini` or the settings menu.*

---

## ⚙️ Advanced Configuration

The game creates a configuration file at `~/.brainworkshop/data/config.ini`. You can edit this file to tweak advanced settings that aren't available in the in-game menus.

**Example `config.ini` tweaks:**
```ini
[DEFAULT]
# Enable full screen mode
WINDOW_FULLSCREEN = True

# Change background color (True = Black, False = White)
BLACK_BACKGROUND = True

# Adjust game speed (seconds per trial)
TIME_PER_TRIAL = 3.0
```

---

## 🛠️ Development & Contributing

If you want to contribute or modify the code:

1.  **Clone the repository**:
    ```bash
    git clone https://github.com/yourusername/brainworkshop.git
    ```
2.  **Set up a virtual environment**:
    ```bash
    virtualenv -p /usr/bin/python2 venv
    source venv/bin/activate
    pip install pyglet==1.4.10
    ```
3.  **Run the game**:
    ```bash
    python2 brainworkshop.pyw
    ```

### Project Structure
*   `brainworkshop.pyw`: The main entry point and game logic.
*   `res/`: Contains all assets (images, sounds, music).
*   `data/`: Stores user statistics and configuration.
*   `pyglet_old_vendor/`: Patched library files (if applicable).

---

## 📜 License

Brain Workshop is free software licensed under the **GNU General Public License (GPL)**.
Original concept by **Paul Hoskinson**.
Modernized fixes by **[Your Name/Handle]**.

---

*Disclaimer: This software is for educational and entertainment purposes. It is not a medical device.*
