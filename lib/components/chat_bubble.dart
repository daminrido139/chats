import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final Color color;
  const ChatBubble({super.key, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 250),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: color,
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
        ),
      ),
    );
  }
}
