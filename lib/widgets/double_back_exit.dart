import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DoubleBackToExit extends StatefulWidget {
  final Widget child;
  final String message;
  final Duration duration;

  const DoubleBackToExit({
    super.key,
    this.message = 'Tap again to exit',
    this.duration = const Duration(seconds: 2),
    required this.child,
  });

  @override
  State<DoubleBackToExit> createState() => _DoubleBackToExitState();
}

class _DoubleBackToExitState extends State<DoubleBackToExit> {
  DateTime? _lastPressed;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Prevents moving back to the previous screen
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        final now = DateTime.now();
        // Check if the back button has not been pressed or is expired
        final isFirstPressOrExpired =
            _lastPressed == null ||
            now.difference(_lastPressed!) > widget.duration;

        // If the back button has not been pressed or is expired, show a snackbar and set it to now
        if (isFirstPressOrExpired) {
          _lastPressed = now;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(widget.message),
              behavior: SnackBarBehavior.floating,
              duration: widget.duration,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
            ),
          );
        } else {
          // Reset the last pressed time to null
          setState(() {
            _lastPressed = null;
          });
          // Second tap within the duration: Close the app
          SystemNavigator.pop();
        }
      },
      child: widget.child,
    );
  }
}
