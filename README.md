# Echoly

This repository now contains a **Flutter desktop version** of Echoly on branch `flutter-version`.

## Flutter app location

- `flutter_app/`

## What is implemented

- Minimalist teleprompter UI inspired by your mockup
- Manual pacing mode (press **Enter** to advance line)
- Play/Pause toggle
- Font size controls
- Progress bar + line counter
- File open support for `.txt` and `.docx`
- Always-on-top toggle and minimize window support for desktop

## Run (Flutter)

1. Install Flutter SDK: https://docs.flutter.dev/get-started/install
2. From repo root:

```bash
cd flutter_app
flutter pub get
flutter run -d windows
# or
flutter run -d macos
```

## Notes

- The existing Electron implementation is still present in `src/`.
- This branch focuses on migrating to Flutter for Windows/macOS desktop UI.
- Screen-capture protection in Flutter may require platform-channel native code depending on OS.
