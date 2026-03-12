import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
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
