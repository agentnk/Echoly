# Echoly

Echoly is a minimalist desktop teleprompter for presentations and speeches.

Built with Electron and designed to run on **Windows** and **macOS** (also works on Linux).

## Features

- Minimal reading-first teleprompter UI inspired by the provided clean mockup.
- Manual pacing mode: press **Enter** to advance one line at a time.
- Play/pause state, progress bar, and line counter.
- Open `.txt` and `.docx` script files.
- Adjustable font size.
- Always-on-top toggle.
- Content protection enabled (`setContentProtection(true)`) to keep the window hidden from many screen-capture/sharing workflows where the OS supports it.

## Quick start

```bash
npm install
npm start
```

## Controls

- **Open**: choose a `.txt` or `.docx` file.
- **Play/Pause**: toggle reading mode.
- **Enter**: advance to next line (while playing).
- **A- / A+**: decrease/increase font size.
- **Pin**: toggle always-on-top.
- **_**: minimize.

## Platform notes

- **Windows**: supported.
- **macOS**: supported, including hidden-inset title bar style.
- **Screen-sharing invisibility** depends on OS/window manager and the capture API used by Zoom/Teams/Meet/OBS.

## Development checks

```bash
npm run check
```
