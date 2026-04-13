import 'package:tetris/utils/helper_functions.dart';
import 'package:tetris/utils/values.dart';

class Piece {
  PieceType type;

  Piece({required this.type});

  List<int> position = [];

  // Set the initial position of the piece
  void initializePiece() {
    switch (type) {
      case PieceType.L:
        // Subtract 10 from each value
        position = [-26, -16, -6, -5];
        break;
      case PieceType.J:
        position = [-25, -15, -5, -6];
        break;
      case PieceType.I:
        position = [-4, -5, -6, -7];
        break;
      case PieceType.O:
        position = [-15, -16, -5, -6];
        break;
      case PieceType.S:
        position = [-15, -14, -6, -5];
        break;
      case PieceType.T:
        position = [-26, -16, -6, -15];
        break;
      case PieceType.Z:
        position = [-17, -16, -6, -5];
        break;
    }
  }

  // Current rotation state
  int rotationState = 0;

  void movePiece(Direction direction) {
    switch (direction) {
      case Direction.down:
        // Move down by adding a row length to each position
        for (int i = 0; i < position.length; i++) {
          position[i] += rowLength;
        }
        break;
      case Direction.left:
        // Move left by subtracting 1 from each position
        for (int i = 0; i < position.length; i++) {
          position[i] -= 1;
        }
        break;
      case Direction.right:
        // Move right by adding 1 to each position
        for (int i = 0; i < position.length; i++) {
          position[i] += 1;
        }
        break;
      case Direction.clockwise:
        rotatePiece(clockwise: true);
        break;
      case Direction.counterClockwise:
        rotatePiece(clockwise: false);
        break;
    }
  }

  void rotatePiece({required bool clockwise}) {
    // 0. O piece doesn't rotate
    if (type == PieceType.O) return;

    // 1. Calculate new positions
    List<int> newPosition = [];

    // Use the second block as the pivot for rotation
    int pivotIndex = position[1];
    int pivotRow = HelperFunctions().findRow(pivotIndex);
    int pivotCol = HelperFunctions().findColumn(pivotIndex);

    for (int i = 0; i < position.length; i++) {
      int row = HelperFunctions().findRow(position[i]);
      int col = HelperFunctions().findColumn(position[i]);

      // Calculate relative coordinates to pivot
      int relativeRow = row - pivotRow;
      int relativeCol = col - pivotCol;

      int newRelativeRow;
      int newRelativeCol;
      if (clockwise) {
        // Clockwise rotation: (r, c) -> (c, -r)
        newRelativeRow = relativeCol;
        newRelativeCol = -relativeRow;
      } else {
        // Counter-clockwise rotation: (r, c) -> (-c, r)
        newRelativeRow = -relativeCol;
        newRelativeCol = relativeRow;
      }

      // Convert back to absolute coordinates
      int newRow = pivotRow + newRelativeRow;
      int newCol = pivotCol + newRelativeCol;

      newPosition.add(newRow * rowLength + newCol);
    }

    // Update position
    position = newPosition;

    // Update rotation state (each piece has 4 rotations)
    rotationState = clockwise
        ? (rotationState + 1) % 4
        : (rotationState - 1 + 4) % 4;
  }
}
