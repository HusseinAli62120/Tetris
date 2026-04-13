import 'package:flutter/material.dart';
import 'package:tetris/widgets/modal_button.dart';

class PauseMenu extends StatefulWidget {
  final Widget child;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final bool isPaused;
  final int score;
  final String timeSpent;
  const PauseMenu({
    super.key,
    required this.child,
    required this.onPause,
    required this.onResume,
    required this.isPaused,
    required this.score,
    required this.timeSpent,
  });

  @override
  State<PauseMenu> createState() => _PauseMenuState();
}

class _PauseMenuState extends State<PauseMenu> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop:
          false, // Prevents moving back to the previous screen when clicking the back button and the game is active
      onPopInvokedWithResult: (didPop, result) {
        if (didPop || widget.isPaused) return;

        // Stop the timer
        widget.onPause();

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            // This is to prevent the dialog from being closed by the back button
            return PopScope(
              canPop: false,
              child: AlertDialog(
                title: Text("Pause"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 8,
                  children: [
                    _pauseMenuItem("Score", widget.score.toString(), context),
                    _pauseMenuItem("Time Spent", widget.timeSpent, context),
                  ],
                ),
                actions: [
                  ModalButton(
                    text: "Exit",
                    color: Theme.of(context).colorScheme.error,
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        "/",
                        (route) => false,
                      );
                    },
                  ),
                  ModalButton(
                    text: "Resume",
                    color: Theme.of(context).colorScheme.onPrimary,
                    onPressed: () {
                      Navigator.pop(context);
                      widget.onResume();
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
      child: widget.child,
    );
  }
}

Widget _pauseMenuItem(String title, String value, BuildContext context) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 6),
    width: double.infinity,
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Theme.of(context).colorScheme.secondary),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 4,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            color: Theme.of(context).colorScheme.onSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.onSecondary,
          ),
        ),
      ],
    ),
  );
}
