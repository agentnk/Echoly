import '../models/script_document.dart';

class TeleprompterController {
  static const String emptyMessage = 'Load a .txt or .docx file to begin.';

  ScriptDocument? _document;
  int _activeIndex = 0;
  bool _isPlaying = false;
  bool _isPinned = true;
  double _fontSize = 52;

  String get fileName => _document?.fileName ?? 'No file loaded';

  List<String> get lines => _document?.lines ?? const [];

  int get totalLines => lines.length;

  int get currentLineNumber => totalLines == 0 ? 0 : _activeIndex + 1;

  bool get isPlaying => _isPlaying;

  bool get isPinned => _isPinned;

  double get fontSize => _fontSize;

  double get progress => totalLines == 0 ? 0 : (_activeIndex + 1) / totalLines;

  String get previousLine => _activeIndex > 0 ? lines[_activeIndex - 1] : '';

  String get activeLine => totalLines == 0 ? emptyMessage : lines[_activeIndex];

  String get nextLine1 => _activeIndex + 1 < totalLines ? lines[_activeIndex + 1] : '';

  String get nextLine2 => _activeIndex + 2 < totalLines ? lines[_activeIndex + 2] : '';

  String get nextLine3 => _activeIndex + 3 < totalLines ? lines[_activeIndex + 3] : '';

  void setDocument(ScriptDocument value) {
    _document = value;
    _activeIndex = 0;
    _isPlaying = false;
  }

  void togglePlayPause() {
    _isPlaying = !_isPlaying;
  }

  void advanceLine() {
    if (!_isPlaying || totalLines == 0) {
      return;
    }

    if (_activeIndex < totalLines - 1) {
      _activeIndex += 1;
    }
  }

  void increaseFont() {
    _fontSize = (_fontSize + 4).clamp(32, 96);
  }

  void decreaseFont() {
    _fontSize = (_fontSize - 4).clamp(32, 96);
  }

  void togglePin() {
    _isPinned = !_isPinned;
  }
}
