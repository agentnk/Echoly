# Echoly (Flutter)

Echoly is now maintained as a **Flutter desktop teleprompter** app.

This repository keeps only the Flutter implementation.

## Project structure

- `flutter_app/` — Flutter desktop app source

## Features

- Minimalist teleprompter UI
- Manual pacing (`Enter` to advance line)
- Play/Pause toggle
- Font size controls
- Progress bar + line counter
- Open `.txt` and `.docx` files
- Always-on-top toggle and minimize window support

## Run

1. Install Flutter SDK: https://docs.flutter.dev/get-started/install
2. Run:

```bash
cd flutter_app
flutter pub get
flutter run -d windows
# or
flutter run -d macos
```

## Notes

- Screen-capture protection for Flutter desktop may require platform-specific native code.
