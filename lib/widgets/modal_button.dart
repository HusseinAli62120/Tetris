import 'package:flutter/material.dart';

// Modal Action buttons
class ModalButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;
  const ModalButton({
    super.key,
    required this.text,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(color),
        splashFactory: InkRipple.splashFactory,
        overlayColor: WidgetStatePropertyAll(color.withValues(alpha: 0.1)),
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
