import 'package:flutter/material.dart';
import 'package:tetris/utils/values.dart';

class ControlButton extends StatelessWidget {
  final IconData icon;
  final Direction direction;
  final VoidCallback onPressed;
  const ControlButton({
    super.key,
    required this.icon,
    required this.direction,
    required this.onPressed,
  });

  String _getDirectionName() {
    switch (direction) {
      case Direction.left:
        return "Left";
      case Direction.right:
        return "Right";
      case Direction.down:
        return "Down";
      case Direction.clockwise:
        return "Rotate";
      case Direction.counterClockwise:
        return "Rotate";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 5,
      children: [
        IconButton(onPressed: onPressed, iconSize: 28, icon: Icon(icon)),
        Text(
          _getDirectionName(),
          style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
        ),
      ],
    );
  }
}
