import 'package:flutter/material.dart';

class ReaderPanel extends StatelessWidget {
  const ReaderPanel({
    super.key,
    required this.fontSize,
    required this.previous,
    required this.active,
    required this.next1,
    required this.next2,
    required this.next3,
  });

  final double fontSize;
  final String previous;
  final String active;
  final String next1;
  final String next2;
  final String next3;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(74, 50, 74, 24),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFDADAD7))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _LineText(previous, fontSize, const Color(0xFFC4C4C0)),
          const SizedBox(height: 18),
          _LineText(active, fontSize, const Color(0xFF1E1E1D), isActive: true),
          const SizedBox(height: 18),
          _LineText(next1, fontSize, const Color(0xFFC9C9C4)),
          const SizedBox(height: 14),
          _LineText(next2, fontSize, const Color(0xFFD7D7D3)),
          const SizedBox(height: 14),
          _LineText(next3, fontSize, const Color(0xFFE4E4E1)),
        ],
      ),
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
