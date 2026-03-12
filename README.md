# Echoly

Echoly is a **minimalist desktop teleprompter** app for presentations and speeches.

Built with Electron and works on **Windows**, **macOS**, and **Linux**.

## ✨ Features

- **Screen sharing invisible** - Window is hidden from Zoom, Teams, Meet, OBS recordings
- **Always on top** - Floats above all applications
- **Manual control** - Press Return/Enter to advance at your own pace
- **Visual hierarchy** - Active line highlighted, context lines faded
- **File support** - Open `.txt` and `.docx` (Word) files
- **Elegant typography** - DM Serif Display for comfortable reading
- **Adjustable font size** - Scale text to your preference
- **Progress tracking** - Visual progress bar and line counter
- **Cross-platform** - Windows 10/11, macOS 13+, Linux

## 🎯 Perfect For

- **Live presentations** - Read your script while screen sharing (invisible to audience)
- **Video recordings** - Professional teleprompter for YouTube, courses, demos
- **Public speaking** - Confidence at conferences, webinars, pitches
- **Podcasts** - Stay on track with talking points

## 🚀 Quick Start

### Installation

1. **Install Node.js** (if you don't have it): https://nodejs.org

2. **Clone this repository**:
   ```bash
   git clone https://github.com/yourusername/echoly.git
   cd echoly
   ```

3. **Install dependencies**:
   ```bash
   npm install
   ```

4. **Run the app**:
   ```bash
   npm start
   ```

### First Use

1. **Load a script** - Click the folder icon (top left) → select `sample-speech.txt`
2. **Click Play** - The ▶︎ button activates reading mode
3. **Press Return/Enter** - Advance through your script at your own pace
4. **Adjust font size** - Use the A− and A+ buttons
5. **Start presenting** - The window stays on top and is invisible during screen sharing!

## 🎨 Design Philosophy

Echoly uses a **minimalist white interface** with:

- **DM Serif Display** for speech text (elegant, readable)
- **DM Mono** for UI controls (clean, technical)
- **Three-tier opacity system** for visual focus
- **Blinking cursor** on active line
- **Smooth animations** for professional feel

## ⌨️ Keyboard Shortcuts

- **Return/Enter** - Advance to next section (when playing)
- **Space** - Toggle play/pause (coming soon)
- **Window controls** - Traffic light buttons (top left) minimize/maximize/close

## 📦 Building for Distribution

### Windows (.exe)

```bash
npm run build-win
```

Creates a portable `.exe` and Windows installer in the `dist/` folder.

### macOS (.app)

```bash
npm run build-mac
```

Creates a `.dmg` installer and `.app` bundle in the `dist/` folder.

**Note:** Building for macOS requires a Mac. Building for Windows works on any platform.

## 🖥️ System Requirements

### Windows
- Windows 10 (version 2004+) or Windows 11
- For screen sharing invisibility: Windows 10 May 2020 Update or later

### macOS
- macOS 13 Ventura or later
- For screen sharing invisibility: macOS 13+

### Linux
- Most modern distributions work
- Screen sharing invisibility may vary by window manager

## 🔧 Configuration

### Window Size

Edit `src/main.js`, lines 9-10:

```javascript
width: 780,   // Default width
height: 520,  // Default height
```

### Default Font Size

Edit `src/renderer.js`, line 6:

```javascript
this.fontSize = 26;  // Change to your preference
```

### Number of Context Lines

Edit `src/renderer.js`, line 142 (the loop showing ahead lines).

## 🔐 Privacy & Security

- **No telemetry** - Zero data collection
- **Local processing** - Files never leave your computer
- **No internet required** - Works completely offline (except Google Fonts CDN)
- **Open source** - Inspect the code yourself
- **Screen capture protection** - Uses OS-level `setContentProtection()` API

## 📁 Project Structure

```
echoly/
├── src/
│   ├── main.js          # Electron main process (window management)
│   ├── preload.js       # Secure IPC bridge
│   ├── renderer.js      # UI logic and teleprompter engine
│   ├── index.html       # App interface
│   └── styles.css       # Visual design
├── package.json         # Dependencies and build config
├── sample-speech.txt    # Example script for testing
└── README.md           # This file
```

## 🛠️ Development

### Run in development mode

```bash
npm start
```

### Enable DevTools

Uncomment line 25 in `src/main.js`:

```javascript
mainWindow.webContents.openDevTools();
```

### Check code syntax

```bash
npm run check
```

## 🐛 Troubleshooting

### "npm: command not found"
→ Install Node.js from https://nodejs.org

### Return key doesn't scroll
→ Click the Play button (▶︎) first
→ Make sure the app window has focus

### Window shows in screen recording
→ Requires Windows 10 (May 2020+) or macOS 13+
→ Check `setContentProtection(true)` in `src/main.js`

### Can't open .docx files
→ Most .docx files work via the `mammoth` library
→ If it fails, save as `.txt` in Word first

### Fonts look different
→ The app loads fonts from Google Fonts CDN
→ If offline, it falls back to system serif/mono fonts
→ The app works perfectly either way

## 🎓 Tips for Presenters

1. **Load scripts early** - Don't fumble with files during your talk
2. **Practice pacing** - Get comfortable with Return key rhythm
3. **Position strategically** - Top of screen works great
4. **Test screen sharing** - Verify invisibility before going live
5. **Adjust for distance** - Bigger font if presenting from far away
6. **Use with notes** - Combine with slides for maximum confidence

## 📝 File Format Tips

### Best practices for .txt files
- One sentence or thought per line
- Keep paragraphs separated by blank lines
- Avoid very long single lines (they're harder to read)

### Working with .docx files
- The app extracts plain text from Word documents
- Formatting (bold, italics) is stripped
- Save as `.txt` for best compatibility

## 🚧 Roadmap

Potential future enhancements:

- [ ] Auto-scroll mode with adjustable speed
- [ ] Voice-activated scrolling
- [ ] Mirror mode for camera recording setups
- [ ] Save scroll position between sessions
- [ ] Multiple color themes
- [ ] Cloud sync for scripts
- [ ] Keyboard shortcut customization
- [ ] Script session export/import

## 🤝 Contributing

Contributions welcome! Feel free to:

- Report bugs
- Suggest features
- Submit pull requests
- Improve documentation

## 📄 License

MIT License - Feel free to use, modify, and distribute!

## 🙏 Credits

- Built with [Electron](https://www.electronjs.org/)
- Typography: [DM Serif Display](https://fonts.google.com/specimen/DM+Serif+Display) & [DM Mono](https://fonts.google.com/specimen/DM+Mono) by Google Fonts
- .docx parsing: [mammoth.js](https://github.com/mwilliamson/mammoth.js/)

---

**Made with ❤️ for speakers and presenters who want confidence during their talks.**

Happy presenting! 🎤
