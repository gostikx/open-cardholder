import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final Widget child;
  final void Function()? onPressed;

  const Button({super.key, required this.child, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 0,
        left: 16.0,
        right: 16.0,
        bottom: 16.0,
      ),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFADB9FF),
            foregroundColor: const Color(0xFF1E3A8A),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
          ),
          onPressed: onPressed,
          child: child,
        ),
      ),
    );
  }
}
