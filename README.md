# Brain Workshop (Modernized Version)

This is a modernized version of **Brain Workshop**, the Dual N-Back mental exercise game. This fork includes significant fixes and improvements to run correctly on modern Linux systems with newer libraries.

## 🚀 Key Improvements & Fixes

### 1. Audio System Overhaul
*   **Fixed Cut-off Audio**: Replaced the obsolete `ManagedSoundPlayer` with a custom `play_sound_managed` system and a garbage collection routine (`cleanup_players`). This ensures audio clips play fully without being prematurely destroyed.
*   **Independent Channel Configuration**: Added support for configuring Left and Right audio channels independently in the settings menu.
*   **3D Audio Positioning**: Verified and fixed spatial audio (Left/Right/Center) for dual audio modes.

### 2. Graphics & Rendering
*   **Modern OpenGL Compatibility**: Replaced deprecated `GL_POLYGON` usage with `GL_TRIANGLES` to prevent crashes on modern graphics drivers.
*   **Responsive Design**: The game window is now fully responsive. The game board (`Field`), visual elements (`Visual`), and menus automatically resize and reposition when the window size changes.

### 3. User Interface (UI)
*   **Menu Fixes**: Resolved a critical bug where menus (C, S, I) were inaccessible. Refactored the `Menu` class event handling to correctly register and unregister events with `window.push_handlers`.
*   **Improved Aesthetics**: Aligned menu options and values into columns for better readability.
*   **Code Cleanup**: Fixed indentation errors and updated syntax (e.g., `repr()` instead of backticks) to reduce warnings and improve compatibility.

### 4. Linux Packaging
*   **Easy Installation**: Added a `Makefile` for standard installation (`sudo make install`).
*   **Desktop Integration**: Included a `.desktop` file so the game appears in your system application menu.
*   **Debian Packaging**: Added `build_deb.sh` to generate `.deb` packages for Ubuntu/Debian/Mint.

## 🛠️ Installation

### Prerequisites
*   Python 2.7
*   Pyglet 1.4.10 (Recommended)

### Option 1: Direct Install
```bash
sudo make install
```
To uninstall:
```bash
sudo make uninstall
```

### Option 2: Build .deb Package
```bash
./build_deb.sh
sudo dpkg -i brainworkshop_4.8.4_all.deb
```

## 🎮 How to Play
Run the game from your application menu or terminal:
```bash
brainworkshop
```

## 📂 Project Structure
*   `brainworkshop.pyw`: Main game source code.
*   `res/`: Resources (images, sounds).
*   `data/`: User data storage.
*   `Makefile`: Installation script.
*   `build_deb.sh`: Debian package builder.

---
*Original Brain Workshop by Paul Hoskinson.*
