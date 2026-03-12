import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:window_manager/window_manager.dart';
import 'package:xml/xml.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    await windowManager.ensureInitialized();
    const options = WindowOptions(
      size: Size(1400, 860),
      minimumSize: Size(980, 620),
      center: true,
      title: 'Echoly (Flutter)',
      backgroundColor: Color(0xFFD9D9D9),
      titleBarStyle: TitleBarStyle.hidden,
    );

    await windowManager.waitUntilReadyToShow(options, () async {
      await windowManager.setAlwaysOnTop(true);
      await windowManager.show();
      await windowManager.focus();
    });
  }

  runApp(const EcholyApp());
}

class EcholyApp extends StatelessWidget {
  const EcholyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Echoly',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFD9D9D9),
      ),
      home: const TeleprompterPage(),
    );
  }
}

class TeleprompterPage extends StatefulWidget {
  const TeleprompterPage({super.key});

  @override
  State<TeleprompterPage> createState() => _TeleprompterPageState();
}

class _TeleprompterPageState extends State<TeleprompterPage> {
  static const String _emptyMessage = 'Load a .txt or .docx file to begin.';

  List<String> _lines = const [];
  int _activeIndex = 0;
  bool _isPlaying = false;
  bool _isPinned = true;
  double _fontSize = 52;
  String _fileName = 'No file loaded';

  Future<void> _openFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: const ['txt', 'docx'],
    );

    if (result == null || result.files.isEmpty) {
      return;
    }

    final file = result.files.single;
    final filePath = file.path;
    if (filePath == null) {
      return;
    }

    final extension = p.extension(filePath).toLowerCase();
    String content = '';

    if (extension == '.txt') {
      content = await File(filePath).readAsString();
    } else if (extension == '.docx') {
      content = await _extractDocxText(await File(filePath).readAsBytes());
    }

    final parsedLines = content
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();

    setState(() {
      _lines = parsedLines.isEmpty ? const ['The selected file is empty.'] : parsedLines;
      _activeIndex = 0;
      _fileName = p.basename(filePath);
      _isPlaying = false;
    });
  }

  Future<String> _extractDocxText(Uint8List bytes) async {
    final archive = ZipDecoder().decodeBytes(bytes, verify: true);
    final file = archive.files.firstWhere(
      (item) => item.name == 'word/document.xml',
      orElse: () => ArchiveFile('empty', 0, []),
    );

    if (file.isFile != true || file.size == 0) {
      return '';
    }

    final xmlString = String.fromCharCodes(file.content as List<int>);
    final document = XmlDocument.parse(xmlString);
    final paragraphNodes = document.findAllElements('w:p');
    final buffer = StringBuffer();

    for (final paragraph in paragraphNodes) {
      final textNodes = paragraph.findAllElements('w:t');
      final line = textNodes.map((node) => node.innerText).join('');
      if (line.trim().isNotEmpty) {
        buffer.writeln(line.trim());
      }
    }

    return buffer.toString();
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _advanceLine() {
    if (!_isPlaying || _lines.isEmpty) {
      return;
    }

    if (_activeIndex < _lines.length - 1) {
      setState(() {
        _activeIndex += 1;
      });
    }
  }

  void _togglePin() async {
    _isPinned = !_isPinned;
    await windowManager.setAlwaysOnTop(_isPinned);
    setState(() {});
  }

  void _decreaseFont() {
    setState(() {
      _fontSize = (_fontSize - 4).clamp(32, 96);
    });
  }

  void _increaseFont() {
    setState(() {
      _fontSize = (_fontSize + 4).clamp(32, 96);
    });
  }

  @override
  Widget build(BuildContext context) {
    final progress = _lines.isEmpty ? 0.0 : (_activeIndex + 1) / _lines.length;

    return Focus(
      autofocus: true,
      onKeyEvent: (node, event) {
        if (event is! KeyDownEvent) {
          return KeyEventResult.ignored;
        }

        if (event.logicalKey == LogicalKeyboardKey.enter) {
          _advanceLine();
          return KeyEventResult.handled;
        }

        if (event.logicalKey == LogicalKeyboardKey.space) {
          _togglePlayPause();
          return KeyEventResult.handled;
        }

        return KeyEventResult.ignored;
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: const Color(0xFFF4F4F2),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFCCCCC8)),
            ),
            child: Column(
              children: [
                _buildTopBar(),
                _buildControlBar(),
                LinearProgressIndicator(
                  value: progress,
                  minHeight: 3,
                  backgroundColor: const Color(0xFFE0E0DD),
                  color: const Color(0xFF1F1F1E),
                ),
                Expanded(child: _buildReader()),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: 78,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFDADAD7))),
      ),
      child: Row(
        children: [
          Row(
            children: const [
              _MacDot(color: Color(0xFFFF5F57)),
              SizedBox(width: 8),
              _MacDot(color: Color(0xFFFFBD2E)),
              SizedBox(width: 8),
              _MacDot(color: Color(0xFF28C840)),
            ],
          ),
          const Expanded(
            child: Center(
              child: Text(
                'ECHOLY',
                style: TextStyle(
                  letterSpacing: 6,
                  color: Color(0xFF999993),
                  fontSize: 30,
                ),
              ),
            ),
          ),
          const SizedBox(width: 84),
        ],
      ),
    );
  }

  Widget _buildControlBar() {
    return Container(
      height: 84,
      padding: const EdgeInsets.symmetric(horizontal: 28),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFDADAD7))),
      ),
      child: Row(
        children: [
          _ControlButton(label: 'OPEN', onTap: _openFile),
          const SizedBox(width: 12),
          _ControlButton(label: _isPlaying ? '❚❚' : '▶', onTap: _togglePlayPause),
          const SizedBox(width: 12),
          _ControlButton(label: 'A-', onTap: _decreaseFont),
          const SizedBox(width: 8),
          Text('${(_fontSize / 2).round()}pt', style: const TextStyle(color: Color(0xFF888882), fontSize: 22)),
          const SizedBox(width: 8),
          _ControlButton(label: 'A+', onTap: _increaseFont),
          const SizedBox(width: 12),
          _ControlButton(label: _isPinned ? 'PIN' : 'UNPIN', onTap: _togglePin),
          const SizedBox(width: 12),
          _ControlButton(label: '_', onTap: () => windowManager.minimize()),
          const Spacer(),
          Flexible(
            child: Text(
              _fileName,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFFC0C0BB),
                fontSize: 24,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReader() {
    final previous = _activeIndex > 0 ? _lines[_activeIndex - 1] : '';
    final active = _lines.isEmpty ? _emptyMessage : _lines[_activeIndex];
    final next1 = _activeIndex + 1 < _lines.length ? _lines[_activeIndex + 1] : '';
    final next2 = _activeIndex + 2 < _lines.length ? _lines[_activeIndex + 2] : '';
    final next3 = _activeIndex + 3 < _lines.length ? _lines[_activeIndex + 3] : '';

    return Container(
      padding: const EdgeInsets.fromLTRB(74, 50, 74, 24),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFDADAD7))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _LineText(previous, _fontSize, const Color(0xFFC4C4C0)),
          const SizedBox(height: 18),
          _LineText(active, _fontSize, const Color(0xFF1E1E1D), isActive: true),
          const SizedBox(height: 18),
          _LineText(next1, _fontSize, const Color(0xFFC9C9C4)),
          const SizedBox(height: 14),
          _LineText(next2, _fontSize, const Color(0xFFD7D7D3)),
          const SizedBox(height: 14),
          _LineText(next3, _fontSize, const Color(0xFFE4E4E1)),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    final totalLines = _lines.length;
    final currentLine = totalLines == 0 ? 0 : _activeIndex + 1;

    return SizedBox(
      height: 62,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Row(
          children: [
            Text(
              _isPlaying ? '● PLAYING' : '● PAUSED',
              style: TextStyle(
                color: _isPlaying ? const Color(0xFF84C98E) : const Color(0xFFB3B3AD),
                letterSpacing: 2,
                fontSize: 18,
              ),
            ),
            const Spacer(),
            Text(
              'LINE $currentLine / $totalLines',
              style: const TextStyle(color: Color(0xFFB3B3AD), letterSpacing: 2, fontSize: 18),
            ),
            const SizedBox(width: 36),
            const Text(
              'PRESS ↩ TO ADVANCE',
              style: TextStyle(color: Color(0xFFB3B3AD), letterSpacing: 2, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

class _MacDot extends StatelessWidget {
  const _MacDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _ControlButton extends StatelessWidget {
  const _ControlButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFF81817A),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      ),
      child: Text(label, style: const TextStyle(fontSize: 20, letterSpacing: 1)),
    );
  }
}

class _LineText extends StatelessWidget {
  const _LineText(this.text, this.fontSize, this.color, {this.isActive = false});

  final String text;
  final double fontSize;
  final Color color;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontFamily: 'Georgia',
        fontSize: fontSize,
        fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
        height: 1.2,
        color: color,
      ),
    );
  }
}
