import 'package:flutter/material.dart';

class LeadingWidget extends StatelessWidget {
  const LeadingWidget({
    super.key,
    required this.title,
    this.containerSize = 80.0,
    this.fontSize = 28.0,
  });

  final String title;
  final double containerSize;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    // Common circular container properties
    // const double containerSize = 30.0;
    const Color backgroundColor = Colors.blue;
    // const double fontSize = 18.0;

    String initials = '';
    if (title.isNotEmpty) {
      final words = title.split(' ');
      for (final word in words) {
        if (word.isNotEmpty) {
          initials += word[0].toUpperCase();
        }
      }
    }

    return Container(
      height: containerSize,
      width: containerSize,
      decoration: const BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials.isNotEmpty ? initials : '?',
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
