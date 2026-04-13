import 'package:flutter/material.dart';
import 'package:tetris/utils/helper_functions.dart';
import 'package:tetris/widgets/modal_button.dart';

Future<dynamic> showGameOverModal({
  required BuildContext context,
  required int score,
  required Duration timeSpent,
  required bool newHighScore,
  required VoidCallback startGame,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => PopScope(
      // This is to prevent the dialog from being closed by the back button
      canPop: false,
      child: AlertDialog(
        title: Text("Game Over"),
        content: Text(
          "Your score is $score you lasted for ${HelperFunctions().convertSecondsToMinutes(timeSpent.inMilliseconds)} ${newHighScore ? "\nNew High Score CONGRATULATIONS!!!" : ""}",
          style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
        ),
        actions: [
          ModalButton(
            text: "Exit",
            color: Theme.of(context).colorScheme.error,
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
            },
          ),
          ModalButton(
            text: "Play Again",
            color: Theme.of(context).colorScheme.onPrimary,
            onPressed: () {
              Navigator.pop(context);
              startGame();
            },
          ),
        ],
      ),
    ),
  );
}
