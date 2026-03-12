# Echoly (Flutter Desktop)

Echoly is a minimalist **Flutter desktop teleprompter** designed for live presentations, recordings, and speech delivery.

This repository contains only the Flutter implementation under `flutter_app/`.

## ✨ What it does

- Load scripts from:
  - `.txt`
  - `.docx`
- Show a clean, reading-focused teleprompter layout with:
  - active line emphasis
  - faded context lines
  - progress indicator and line counter
- Support keyboard-driven pacing:
  - `Enter` → advance line
  - `Space` → play/pause
- Offer desktop window controls:
  - always-on-top pin/unpin
  - minimize
- Let you adjust font size during playback.

## 🖥️ Supported platforms

- Windows (Flutter desktop)
- macOS (Flutter desktop)
- Linux (Flutter desktop)

> Note: platform-specific desktop behavior can vary slightly by OS/window manager.

## 📁 Repository layout

```text
.
├── flutter_app/
│   ├── lib/
│   │   ├── controllers/
│   │   ├── models/
│   │   ├── pages/
│   │   ├── services/
│   │   └── widgets/
│   ├── test/
│   └── pubspec.yaml
├── .gitignore
└── README.md
```

## 🚀 Getting started

### 1) Install Flutter

Follow official installation instructions:
https://docs.flutter.dev/get-started/install

Then verify:

```bash
flutter --version
flutter doctor
```

### 2) Install project dependencies

```bash
cd flutter_app
flutter pub get
```

### 3) Run the app

```bash
# Windows
flutter run -d windows

# macOS
flutter run -d macos

# Linux
flutter run -d linux
```

## ✅ Quality checks

From `flutter_app/`:

```bash
flutter analyze
flutter test
```

## 🧠 Architecture overview

The app uses a simple layered structure:

- `models/` → app data structures (`ScriptDocument`, `ScriptLoadResult`)
- `services/` → file loading + docx extraction
- `controllers/` → teleprompter state and behavior
- `pages/` → screen wiring and event orchestration
- `widgets/` → reusable UI blocks

This keeps business logic separate from UI rendering and makes tests easier to add and maintain.

## 📄 Script format notes

### `.txt`
- Best results when each idea/sentence is on its own line.
- Empty lines are ignored in parsing.

### `.docx`
- Text is extracted from document XML and converted to plain lines.
- Rich formatting (bold/italics/layout) is not preserved.
- Malformed/unsupported `.docx` files return a user-facing error.

## ⚠️ Known limitations

- Screen-share/capture invisibility is not fully guaranteed cross-platform in Flutter without additional native integration.
- Very complex `.docx` documents may not extract perfectly due to plain-text parsing.
- Custom global shortcuts are not implemented yet.

## 🛣️ Suggested next improvements

- Auto-scroll mode with speed slider.
- Session persistence (remember last file/line/font size).
- Optional mirror mode for camera-facing teleprompter setups.
- Configurable keyboard shortcuts.

## 📜 License

MIT
