import '../models/script_document.dart';

class TeleprompterController {
  static const String emptyMessage = 'Load a .txt or .docx file to begin.';

  ScriptDocument? document;
  int activeIndex = 0;
  bool isPlaying = false;
  bool isPinned = true;
  double fontSize = 52;

  String get fileName => document?.fileName ?? 'No file loaded';

  List<String> get lines => document?.lines ?? const [];

  int get totalLines => lines.length;

  int get currentLineNumber => totalLines == 0 ? 0 : activeIndex + 1;

  double get progress => totalLines == 0 ? 0 : (activeIndex + 1) / totalLines;

  String get previousLine => activeIndex > 0 ? lines[activeIndex - 1] : '';

  String get activeLine => totalLines == 0 ? emptyMessage : lines[activeIndex];

  String get nextLine1 => activeIndex + 1 < totalLines ? lines[activeIndex + 1] : '';

  String get nextLine2 => activeIndex + 2 < totalLines ? lines[activeIndex + 2] : '';

  String get nextLine3 => activeIndex + 3 < totalLines ? lines[activeIndex + 3] : '';

  void setDocument(ScriptDocument value) {
    document = value;
    activeIndex = 0;
    isPlaying = false;
  }

  void togglePlayPause() {
    isPlaying = !isPlaying;
  }

  void advanceLine() {
    if (!isPlaying || totalLines == 0) {
      return;
    }

    if (activeIndex < totalLines - 1) {
      activeIndex += 1;
    }
  }

  void increaseFont() {
    fontSize = (fontSize + 4).clamp(32, 96);
  }

  void decreaseFont() {
    fontSize = (fontSize - 4).clamp(32, 96);
  }

  void togglePin() {
    isPinned = !isPinned;
  }
}
