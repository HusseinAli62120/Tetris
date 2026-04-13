import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tetris/utils/values.dart';

class Pixel extends StatelessWidget {
  final int index;
  final PieceType? type;
  final bool isShadow;
  final bool isClearing;
  final bool isDropping;
  const Pixel({
    super.key,
    required this.index,
    this.type,
    this.isShadow = false,
    this.isClearing = false,
    this.isDropping = false,
  });

  Color _getColor(BuildContext context) {
    final Brightness theme = Theme.of(context).brightness;
    // Empty space
    if (type == null) {
      return theme == Brightness.dark ? Colors.grey.shade900 : Colors.white;
    }
    switch (type!) {
      case PieceType.L:
        return Colors.green.shade600;
      case PieceType.J:
        return Colors.blue.shade600;
      case PieceType.I:
        return Colors.red.shade600;
      case PieceType.O:
        return Colors.yellow.shade600;
      case PieceType.S:
        return Colors.pink.shade600;
      case PieceType.T:
        return Colors.purple.shade600;
      case PieceType.Z:
        return Colors.orange.shade600;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Brightness theme = Theme.of(context).brightness;
    final bool isFilled = type != null;

    // Base color for empty space
    final Color backgroundColor = theme == Brightness.dark
        ? Colors.grey.shade900
        : Colors.white;

    // The actual block content
    Widget blockContent = Container(
      margin: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: isShadow ? backgroundColor : _getColor(context),
        border: isShadow
            ? Border.all(color: _getColor(context), width: 1)
            : null,
        borderRadius: BorderRadius.circular(5),
      ),
    );

    // If it's just an empty background pixel, return it simple and fast
    if (type == null && !isShadow) {
      return blockContent;
    }

    // Wrap the animated content in a background pixel so it doesn't show the board background behind it
    Widget animatedContent;

    if (isClearing) {
      animatedContent = blockContent
          .animate(onComplete: (controller) => controller.repeat())
          .tint(color: Colors.white, duration: 200.ms)
          .then()
          .tint(color: _getColor(context), duration: 200.ms)
          .scale(
            begin: const Offset(1, 1),
            end: const Offset(0.8, 0.8),
            duration: 400.ms,
            curve: Curves.easeInOut,
          );
      //
    } else if (isDropping && isFilled) {
      animatedContent = blockContent
          .animate()
          .slideY(
            begin: -0.5,
            end: 0,
            duration: 300.ms,
            curve: Curves.bounceOut,
          )
          .fadeIn(duration: 100.ms);
    } else if (isShadow || key.toString().contains('falling')) {
      // Don't animate falling piece or shadows to prevent flashing on every move
      animatedContent = blockContent;
    } else {
      // Default animation for new landed blocks
      animatedContent = blockContent
          .animate()
          .fadeIn(duration: 200.ms)
          .scale(
            begin: const Offset(0.8, 0.8),
            end: const Offset(1, 1),
            duration: 200.ms,
          );
    }

    return Stack(
      children: [
        // Constant background
        Container(
          margin: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            color: backgroundColor,
            border: theme == Brightness.dark
                ? Border.all(color: Colors.grey.shade800, width: 0.5)
                : null,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        // Animated block on top
        animatedContent,
      ],
    );
  }
}
