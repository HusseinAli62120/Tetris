import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tetris/pages/game/board.dart';
import 'package:tetris/services/scores_service.dart';
import 'package:tetris/utils/helper_functions.dart';
import 'package:tetris/utils/values.dart';
import 'package:tetris/widgets/game_over_modal.dart';
import 'package:tetris/widgets/pause_menu.dart';
import 'package:tetris/widgets/piece.dart';

class Game extends StatefulWidget {
  final int? timer;
  final String? level;
  const Game({super.key, this.timer, this.level});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  // Game board (15 rows x 10 columns)
  List<List<PieceType?>> gameBoard = List.generate(
    colLength,
    (i) => List.generate(rowLength, (j) => null),
  );

  // Current piece
  Piece _currentPiece = Piece(
    type: PieceType.values[Random().nextInt(PieceType.values.length)],
  );

  int _score = 0;
  bool _gameOver = false;
  bool _isPaused = false;
  // bool _isClearing = false;
  bool _isDropping = false;
  List<int> _clearingRows = [];
  Duration _timeSpent = Duration.zero;

  final ScoresService _scoresService = ScoresService();
  int _highScore = 0;

  // Start game
  void _startGame() {
    _currentPiece.initializePiece();

    // We reinitialize the values here since we use this function to restart the game
    setState(() {
      _gameOver = false;
      _score = 0;
      _timeSpent = Duration.zero;
      _isPaused = false;
      gameBoard = List.generate(
        colLength,
        (i) => List.generate(rowLength, (j) => null),
      );
    });

    final Duration frameRate = Duration(milliseconds: widget.timer!);
    // Call the game loop function
    _gameLoop(frameRate);
  }

  // This function is executed every frame rate
  void _gameLoop(Duration frameRate) {
    Timer.periodic(frameRate, (timer) {
      // Cancel the timer when exiting
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_isPaused) {
        return;
      }

      setState(() {
        _timeSpent += frameRate;

        // Check if game is over
        if (_gameOver) {
          final bool newHighScore = _score > _highScore;

          if (newHighScore) {
            _scoresService.write(widget.level, _score);
          }
          timer.cancel();

          showGameOverModal(
            context: context,
            score: _score,
            timeSpent: _timeSpent,
            newHighScore: newHighScore,
            startGame: _startGame,
          );
          return;
        }

        // Check if any lines need clearing (lookahead)
        List<int> fullRows = [];
        for (int row = colLength - 1; row >= 0; row--) {
          bool rowIsFull = true;
          for (int col = 0; col < rowLength; col++) {
            if (gameBoard[row][col] == null) {
              rowIsFull = false;
              break;
            }
          }
          if (rowIsFull) fullRows.add(row);
        }

        if (fullRows.isNotEmpty) {
          _handleLineClear(fullRows);
          return;
        }

        // Check if the piece has landed
        _checkLanding();

        // Move the piece down
        _currentPiece.movePiece(Direction.down);
      });
    });
  }

  void _handleLineClear(List<int> fullRows) async {
    setState(() {
      // _isClearing = true;
      _clearingRows = fullRows;
    });

    // Duration for the clearing animation
    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;

    setState(() {
      _clearLines();
      _clearingRows = [];
      // _isClearing = false;
      _isDropping = true;
    });

    // Duration for the dropping animation
    await Future.delayed(const Duration(milliseconds: 300));

    if (!mounted) return;

    setState(() {
      _isDropping = false;
    });
  }

  // Used to check if the piece is has reached the bottom or another piece
  bool _checkColision(Direction direction) {
    // If rotating, we need to check the potential new positions (clockwise)
    if (direction == Direction.clockwise ||
        direction == Direction.counterClockwise) {
      if (_currentPiece.type == PieceType.O) return false;

      int pivotIndex = _currentPiece.position[1];
      int pivotRow = HelperFunctions().findRow(pivotIndex);
      int pivotCol = HelperFunctions().findColumn(pivotIndex);

      for (int i = 0; i < _currentPiece.position.length; i++) {
        int r = HelperFunctions().findRow(_currentPiece.position[i]);
        int c = HelperFunctions().findColumn(_currentPiece.position[i]);

        int relativeRow = r - pivotRow;
        int relativeCol = c - pivotCol;

        int newRow;
        int newCol;
        if (direction == Direction.clockwise) {
          // Simulate rotation: (r, c) -> (c, -r)
          newRow = pivotRow + relativeCol;
          newCol = pivotCol - relativeRow;
        } else {
          // Simulate rotation: (r, c) -> (-c, r)
          newRow = pivotRow - relativeCol;
          newCol = pivotCol + relativeRow;
        }

        // Check if out of bounds
        if (newCol < 0 || newCol >= rowLength || newRow >= colLength) {
          return true;
        }

        // Check if already occupied
        if (newRow >= 0 && gameBoard[newRow][newCol] != null) {
          return true;
        }
      }
      return false;
    }

    // For other directions, check each position after the move
    for (int i = 0; i < _currentPiece.position.length; i++) {
      int row = HelperFunctions().findRow(_currentPiece.position[i]);
      int col = HelperFunctions().findColumn(_currentPiece.position[i]);

      // adjust the column based on the direction
      if (direction == Direction.left) {
        col -= 1;
      } else if (direction == Direction.right) {
        col += 1;
      } else if (direction == Direction.down) {
        row += 1;
      }

      // A collision occurs if the piece is out of bounds (left, right: first two conditions) or at the bottom (third condition)
      if (col < 0 || col >= rowLength || row >= colLength) {
        return true;
      }

      // Check if the current position is already occupied by another piece in the game board
      if (row >= 0 && col >= 0 && gameBoard[row][col] != null) {
        return true;
      }
    }
    return false;
  }

  void _checkLanding() {
    if (_checkColision(Direction.down)) {
      // Check if each position of the current piece has landed
      for (int i = 0; i < _currentPiece.position.length; i++) {
        // Get the row and column of the current position
        int row = HelperFunctions().findRow(_currentPiece.position[i]);
        int col = HelperFunctions().findColumn(_currentPiece.position[i]);

        if (row >= 0 && col >= 0) {
          gameBoard[row][col] = _currentPiece.type;
        }
      }

      // Add 10 points to the score
      setState(() {
        _score += 10;
      });

      // Once the piece has landed, create a new piece
      _createNewPiece();
    }
  }

  void _createNewPiece() {
    PieceType randomPiece =
        PieceType.values[Random().nextInt(PieceType.values.length)];
    _currentPiece = Piece(type: randomPiece);
    _currentPiece.initializePiece();

    // Check if the game is over
    if (_isGameOver()) {
      setState(() {
        _gameOver = true;
      });
    }
  }

  void _movePiece(Direction direction) {
    // Move only if there is no collision
    if (!_checkColision(direction)) {
      // Update the piece position
      setState(() {
        _currentPiece.movePiece(direction);
      });
    }
  }

  void _clearLines() {
    // Loop through each row, start from the bottom
    for (int row = colLength - 1; row >= 0; row--) {
      bool rowIsFull = true;
      // Check if the row is full (check each column is the row)
      for (int col = 0; col < rowLength; col++) {
        // If we find an empty cell, the row is not full
        if (gameBoard[row][col] == null) {
          rowIsFull = false;
          break;
        }
      }

      // Clear the row if full
      if (rowIsFull) {
        // Clear the row
        for (int col = 0; col < rowLength; col++) {
          gameBoard[row][col] = null;
        }

        // Move all rows above the cleared row down by one
        for (int i = row - 1; i >= 0; i--) {
          for (int col = 0; col < rowLength; col++) {
            gameBoard[i + 1][col] = gameBoard[i][col];
          }
        }

        // Clear the top row
        gameBoard[0] = List.generate(rowLength, (index) => null);

        // Since we cleared a row, we need to check the same row again (The row that was moved down may have formed a full row)
        row++;

        // Add to score
        _score += 100;
      }
    }
  }

  // Check game over
  bool _isGameOver() {
    // Check if the indexes (3,4,5,6) are full
    // There are the indexes where the piece is spawned
    for (int col = 3; col <= 6; col++) {
      if (gameBoard[0][col] != null) {
        return true;
      }
    }
    return false;
  }

  void _handlePause() {
    setState(() {
      _isPaused = true;
    });
  }

  // Calculate the shadow position where the piece will land
  List<int> _calculateShadowPosition() {
    List<int> shadowPosition = List.from(_currentPiece.position);

    while (true) {
      bool collision = false;
      for (int pos in shadowPosition) {
        int row = HelperFunctions().findRow(pos) + 1;
        int col = HelperFunctions().findColumn(pos);

        if (row >= colLength) {
          collision = true;
          break;
        }

        if (row >= 0 && gameBoard[row][col] != null) {
          collision = true;
          break;
        }
      }

      if (collision) break;

      for (int i = 0; i < shadowPosition.length; i++) {
        shadowPosition[i] += rowLength;
      }
    }

    return shadowPosition;
  }

  @override
  void initState() {
    super.initState();
    _startGame();

    void fetchHighScore() async {
      _highScore = await _scoresService.read(widget.level);
    }

    fetchHighScore();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate shadow once per build
    final shadowPosition = _calculateShadowPosition();

    return PauseMenu(
      score: _score,
      timeSpent: HelperFunctions()
          .convertSecondsToMinutes(_timeSpent.inMilliseconds)
          .toString(),
      onPause: () {
        _handlePause();
      },
      onResume: () {
        setState(() {
          _isPaused = false;
        });
      },
      isPaused: _isPaused,
      child: Board(
        currentPiece: _currentPiece,
        gameBoard: gameBoard,
        shadowPosition: shadowPosition,
        score: _score,
        clearingRows: _clearingRows,
        isDropping: _isDropping,
        movePiece: _movePiece,
      ),
    );
  }
}
