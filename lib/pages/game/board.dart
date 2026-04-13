import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tetris/utils/helper_functions.dart';
import 'package:tetris/utils/values.dart';
import 'package:tetris/widgets/piece.dart';
import 'package:tetris/widgets/pixel.dart';
import 'package:tetris/widgets/control_button.dart';

class Board extends StatelessWidget {
  final List<int> shadowPosition;
  final List<List<PieceType?>> gameBoard;
  final Piece currentPiece;
  final int score;
  final List<int> clearingRows;
  final bool isDropping;
  final Function(Direction) movePiece;
  const Board({
    super.key,
    required this.shadowPosition,
    required this.gameBoard,
    required this.currentPiece,
    required this.score,
    required this.clearingRows,
    required this.isDropping,
    required this.movePiece,
  });

  @override
  Widget build(BuildContext context) {
    // Get the active theme
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.brightness == Brightness.dark
          ? Colors.black
          : Colors.grey.shade100,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          // Status bar
          statusBarColor: theme.colorScheme.primary,
          statusBarIconBrightness: theme.brightness == Brightness.dark
              ? Brightness.light
              : Brightness.dark,

          // Navigation bar
          systemNavigationBarColor: Colors.black,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        child: SafeArea(
          bottom: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: GridView.builder(
                  itemCount: colLength * rowLength,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: rowLength,
                  ),
                  itemBuilder: (context, index) {
                    final row = HelperFunctions().findRow(index);
                    final col = HelperFunctions().findColumn(index);

                    // Falling piece
                    if (currentPiece.position.contains(index)) {
                      return Pixel(
                        key: ValueKey('falling-$index'),
                        index: index,
                        type: currentPiece.type,
                      );
                    }
                    // Ghost piece (preview)
                    else if (shadowPosition.contains(index)) {
                      return Pixel(
                        key: ValueKey('shadow-$index'),
                        index: index,
                        type: currentPiece.type,
                        isShadow: true,
                      );
                    }
                    // Landed piece
                    else if (gameBoard[row][col] != null) {
                      return Pixel(
                        key: ValueKey('landed-$index-${gameBoard[row][col]}'),
                        index: index,
                        type: gameBoard[row][col]!,
                        isClearing: clearingRows.contains(row),
                        isDropping: isDropping,
                      );
                    }
                    // Empty space
                    else {
                      return Pixel(
                        key: ValueKey('empty-$index'),
                        index: index,
                        type: null,
                      );
                    }
                  },
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 0),
                  child: Center(
                    child: Column(
                      spacing: 5,
                      children: [
                        Text(
                          "Score: $score",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 20,
                          children: [
                            // Move Left
                            ControlButton(
                              icon: Icons.arrow_back,
                              direction: Direction.left,
                              onPressed: () {
                                movePiece(Direction.left);
                              },
                            ),

                            // Rotate counter-clockwise
                            ControlButton(
                              direction: Direction.counterClockwise,
                              icon: Icons.rotate_left,
                              onPressed: () {
                                movePiece(Direction.counterClockwise);
                              },
                            ),

                            // Move Down
                            ControlButton(
                              icon: Icons.arrow_downward,
                              direction: Direction.down,
                              onPressed: () {
                                movePiece(Direction.down);
                              },
                            ),
                            // Rotate clockwise
                            ControlButton(
                              icon: Icons.rotate_right,
                              direction: Direction.clockwise,
                              onPressed: () {
                                movePiece(Direction.clockwise);
                              },
                            ),

                            // Move Right
                            ControlButton(
                              icon: Icons.arrow_forward,
                              direction: Direction.right,
                              onPressed: () {
                                movePiece(Direction.right);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
