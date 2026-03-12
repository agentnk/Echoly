# Echoly

Echoly is a **desktop teleprompter** app with a notch / Dynamic-Island-inspired floating overlay.

It is built with Electron and works on **Windows** (also macOS/Linux).

## Features

- Open and parse speech files:
  - `.txt`
  - `.docx` (Word)
- Floating, frameless overlay window for easy reading while presenting.
- Play / pause scrolling teleprompter text.
- Adjustable scroll speed and font size.
- Pin/unpin always-on-top behavior.
- Privacy mode enabled by default: window content protection keeps Echoly hidden from most screen sharing/capture tools (Zoom, Teams, Meet) when supported by the OS.

## Quick start

```bash
npm install
npm start
```

## Build notes for Windows

The app is already Windows-compatible because it uses Electron APIs available on Windows.
If you want an installer/exe, add `electron-builder` later and package for `win`.

## Suggested next improvements

- Add `.doc` support via a conversion pipeline.
- Add mirror mode for camera recording setups.
- Save last-used speed/font preferences.
- Add export/import for script sessions.
