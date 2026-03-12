import 'package:flutter/material.dart';

class ControlBar extends StatelessWidget {
  const ControlBar({
    super.key,
    required this.fileName,
    required this.fontSizePt,
    required this.isPlaying,
    required this.isPinned,
    required this.onOpen,
    required this.onTogglePlayPause,
    required this.onDecreaseFont,
    required this.onIncreaseFont,
    required this.onTogglePin,
    required this.onMinimize,
  });

  final String fileName;
  final int fontSizePt;
  final bool isPlaying;
  final bool isPinned;
  final VoidCallback onOpen;
  final VoidCallback onTogglePlayPause;
  final VoidCallback onDecreaseFont;
  final VoidCallback onIncreaseFont;
  final VoidCallback onTogglePin;
  final VoidCallback onMinimize;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 84,
      padding: const EdgeInsets.symmetric(horizontal: 28),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFDADAD7))),
      ),
      child: Row(
        children: [
          _ControlButton(label: 'OPEN', onTap: onOpen),
          const SizedBox(width: 12),
          _ControlButton(label: isPlaying ? '❚❚' : '▶', onTap: onTogglePlayPause),
          const SizedBox(width: 12),
          _ControlButton(label: 'A-', onTap: onDecreaseFont),
          const SizedBox(width: 8),
          Text(
            '${fontSizePt}pt',
            style: const TextStyle(color: Color(0xFF888882), fontSize: 22),
          ),
          const SizedBox(width: 8),
          _ControlButton(label: 'A+', onTap: onIncreaseFont),
          const SizedBox(width: 12),
          _ControlButton(label: isPinned ? 'PIN' : 'UNPIN', onTap: onTogglePin),
          const SizedBox(width: 12),
          _ControlButton(label: '_', onTap: onMinimize),
          const Spacer(),
          Flexible(
            child: Text(
              fileName,
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
