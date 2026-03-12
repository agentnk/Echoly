import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import '../controllers/teleprompter_controller.dart';
import '../services/script_loader.dart';
import '../widgets/control_bar.dart';
import '../widgets/reader_panel.dart';
import '../widgets/status_footer.dart';
import '../widgets/top_bar.dart';

class TeleprompterPage extends StatefulWidget {
  const TeleprompterPage({super.key});

  @override
  State<TeleprompterPage> createState() => _TeleprompterPageState();
}

class _TeleprompterPageState extends State<TeleprompterPage> {
  final _controller = TeleprompterController();
  final _loader = ScriptLoader();

  Future<void> _openFile() async {
    final result = await _loader.pickAndLoad();
    if (!mounted) {
      return;
    }

    if (result.isCancelled) {
      return;
    }

    if (result.isFailure) {
      final error = result.errorMessage ?? 'Unknown error while opening file.';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    setState(() {
      _controller.setDocument(result.document!);
    });
  }

  void _togglePlayPause() {
    setState(_controller.togglePlayPause);
  }

  void _advanceLine() {
    setState(_controller.advanceLine);
  }

  Future<void> _togglePin() async {
    setState(_controller.togglePin);
    await windowManager.setAlwaysOnTop(_controller.isPinned);
  }

  void _increaseFont() {
    setState(_controller.increaseFont);
  }

  void _decreaseFont() {
    setState(_controller.decreaseFont);
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      onKeyEvent: (_, event) {
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
                const TopBar(),
                ControlBar(
                  fileName: _controller.fileName,
                  fontSizePt: (_controller.fontSize / 2).round(),
                  isPlaying: _controller.isPlaying,
                  isPinned: _controller.isPinned,
                  onOpen: _openFile,
                  onTogglePlayPause: _togglePlayPause,
                  onDecreaseFont: _decreaseFont,
                  onIncreaseFont: _increaseFont,
                  onTogglePin: _togglePin,
                  onMinimize: windowManager.minimize,
                ),
                LinearProgressIndicator(
                  value: _controller.progress,
                  minHeight: 3,
                  backgroundColor: const Color(0xFFE0E0DD),
                  color: const Color(0xFF1F1F1E),
                ),
                Expanded(
                  child: ReaderPanel(
                    fontSize: _controller.fontSize,
                    previous: _controller.previousLine,
                    active: _controller.activeLine,
                    next1: _controller.nextLine1,
                    next2: _controller.nextLine2,
                    next3: _controller.nextLine3,
                  ),
                ),
                StatusFooter(
                  isPlaying: _controller.isPlaying,
                  currentLine: _controller.currentLineNumber,
                  totalLines: _controller.totalLines,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
