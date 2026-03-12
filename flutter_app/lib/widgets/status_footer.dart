import 'package:flutter/material.dart';

class StatusFooter extends StatelessWidget {
  const StatusFooter({
    super.key,
    required this.isPlaying,
    required this.currentLine,
    required this.totalLines,
  });

  final bool isPlaying;
  final int currentLine;
  final int totalLines;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 62,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Row(
          children: [
            Text(
              isPlaying ? '● PLAYING' : '● PAUSED',
              style: TextStyle(
                color: isPlaying ? const Color(0xFF84C98E) : const Color(0xFFB3B3AD),
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
