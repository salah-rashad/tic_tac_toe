import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart' hide Timer;
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe/game/components/box.dart';
import 'package:tic_tac_toe/game/components/text_button.dart';
import 'package:tic_tac_toe/game/utils/helpers.dart';

class TicTacToe extends BaseGame with HasTapableComponents {
  final int gameSize;
  final bool vsPlayer;

  double get width => canvasSize.x;
  double get height => canvasSize.y;

  TicTacToe({required this.gameSize, required this.vsPlayer});

  List<List<Box>> grid = [];

  bool xTurn = new Random().nextBool();
  bool gameFreezed = false;
  bool gameFinished = false;

  String message = "";

  int xWinTimes = 0, oWinTimes = 0;

  static const MESSAGE_FONT_SIZE = 32.0;

  TextPaint messageText =
      textPaint(fontSize: MESSAGE_FONT_SIZE, color: Colors.black);

  TextPaint counterText = textPaint(fontSize: 24.0, color: Colors.black);

  @override
  Future<void> onLoad() {
    debugMode = false;
    message = (xTurn ? "X" : "O") + " Turn";
    _drawGrid();
    return super.onLoad();
  }

  @override
  void render(Canvas c) {
    c.drawRect(
      Rect.fromLTWH(0.0, 0.0, width, height),
      Paint()..color = Colors.blue,
    );

    messageText.render(
      c,
      message,
      Vector2(width / 2, height - 64.0),
      anchor: Anchor.center,
    );

    counterText.render(
      c,
      "$xWinTimes  ❌",
      Vector2(width / 3, 64.0),
      anchor: Anchor.topRight,
    );

    counterText.render(
      c,
      "⭕  $oWinTimes",
      Vector2((width / 3) * 2, 64.0),
      anchor: Anchor.topLeft,
    );

    counterText.render(
      c,
      xWinTimes > oWinTimes
          ? "👑           "
          : xWinTimes == oWinTimes
              ? " 👑 "
              : "           👑",
      Vector2(width / 2, 64.0),
      anchor: Anchor.topCenter,
    );

    super.render(c);
  }

  void _drawGrid() {
    double boxSize = width / gameSize;
    double gridSize = gameSize * boxSize;

    final double CENTER_START = (height - gridSize) / 2;

    grid = List.generate(
      gameSize,
      (x) => List.generate(
        gameSize,
        (y) => Box(
          size: Vector2(boxSize, boxSize),
          position: Vector2(
              x * boxSize, max(CENTER_START, CENTER_START + boxSize * y)),
          location: Point(x, y),
          gameSize: gameSize,
          isAIGame: !vsPlayer,
        ),
        growable: false,
      ),
      growable: false,
    );

    for (int x = 0; x < gameSize; x++) {
      for (int y = 0; y < gameSize; y++) {
        add(grid[x][y]);
      }
    }
  }

  /// Makes move and check for a winner by calling [winnerChecker]
  Future<void> makeMove(Box box, {BoxState? state}) async {
    if (state == null)
      xTurn == true ? await box.makeX() : await box.makeO();
    else
      state == BoxState.X ? await box.makeX() : await box.makeO();

    xTurn = !xTurn;
    winnerChecker(box);
  }

  /// Checks for a Winner or a Tie
  void winnerChecker(Box box) {
    // Changes
    message = (xTurn ? "X" : "O") + " Turn";

    horizontal(box);

    if (!horizontal(box) &&
        !vertical(box) &&
        !diagonal1(box) &&
        !diagonal2(box)) checkTie(box);
  }

  /// Checks if a specific boxes are equal on not,
  /// if they are equal finish the game and call [winner]
  bool isEquals(List<Box> boxes) {
    // Checking boxes equality, if all boxes are equal return true, otherwise return false
    bool isEqualsX = boxes.every((b) => b.state == BoxState.X);
    bool isEqualsO = boxes.every((b) => b.state == BoxState.O);

    // if found equality then it's a win
    if (isEqualsX || isEqualsO) {
      gameFreezed = true;

      winner(boxes);
      return true;
    } else {
      gameFreezed = false;
      return false;
    }
  }

  /// Makes winner processes
  void winner(List<Box> boxes) {
    final winner = boxes[0].state;

    // Change winner boxes background to green
    for (Box b in boxes) {
      b.fillPaint?.color = Colors.greenAccent;
    }

    // Increases winner's win counter +1
    increaseWinTimes(winner);

    // Informs who just won (e.g.: "X WINS" or "O WINS")
    message = (winner == BoxState.X ? "X" : "O") + " WINS 🎉";

    // Changes the message text color to Green
    messageText =
        textPaint(fontSize: MESSAGE_FONT_SIZE, color: Colors.greenAccent);

    finishGame();
  }

  /// Checks row's boxes equality where [box] located.
  bool horizontal(Box box) {
    List<Box> boxes = [];

    for (int x = 0; x < gameSize; x++) {
      var b = grid[x][box.location.y];
      boxes.add(b);
    }

    return isEquals(boxes);
  }

  /// Checks column's boxes equality where [box] located.
  bool vertical(Box box) {
    List<Box> boxes = [];

    for (int y = 0; y < gameSize; y++) {
      var b = grid[box.location.x][y];
      boxes.add(b);
    }

    return isEquals(boxes);
  }

  /// Checks diagonal (as backslash "\")'s boxes equality where [box] located.
  bool diagonal1(Box box) {
    List<Box> boxes = [];

    for (int x = 0, y = 0; x < gameSize; x++, y++) {
      var b = grid[x][y];
      boxes.add(b);
    }

    return isEquals(boxes);
  }

  /// Checks diagonal (as forward slash "/")'s boxes equality where [box] located.
  bool diagonal2(Box box) {
    List<Box> boxes = [];

    for (int x = 0, y = gameSize - 1; x < gameSize; x++, y--) {
      var b = grid[x][y];
      boxes.add(b);
    }

    return isEquals(boxes);
  }

  /// Checks if there's no moves left and no winner,
  /// then make a TIE and finish the game.
  void checkTie(Box box) {
    int filledBoxesCounter = 0;

    for (int x = 0; x < gameSize; x++) {
      for (int y = 0; y < gameSize; y++) {
        if (grid[x][y].state != BoxState.EMPTY) filledBoxesCounter++;
      }
    }

    if (filledBoxesCounter == gameSize * gameSize) {
      message = "TIE";
      messageText =
          textPaint(fontSize: MESSAGE_FONT_SIZE, color: Colors.orange);

      finishGame();
    }
  }

  /// This function is called to finish the game and shows the restart button.
  void finishGame() {
    gameFinished = true;
    add(
      TextButtonComponent(
        "PLAY AGAIN!",
        onPressed: () => reset(),
        position: Vector2(width / 2, height - 150.0),
        anchor: Anchor.center,
        textColor: Colors.white,
        backgroundColor: Colors.amber,
      ),
    );
  }

  /// Clears all boxes and reload the game.
  void reset() {
    removeAll(components);
    grid = [];
    onLoad();
    gameFreezed = false;
    gameFinished = false;
    messageText = textPaint(fontSize: MESSAGE_FONT_SIZE, color: Colors.black);
  }

  /// Increases win times counter for a winner.
  void increaseWinTimes(BoxState state) {
    if (state == BoxState.X) xWinTimes++;
    if (state == BoxState.O) oWinTimes++;
  }
}

/* class AI extends TicTacToe {
  Timer? timer;

  AI() : super(gameSize: 3, vsPlayer: false);

  @override
  Future<void> onLoad() async {
    xTurn = true;

    // await grid[0][0].makeX();
    // await grid[0][2].makeO();
    // await grid[2][0].makeX();
    // await grid[2][2].makeO();

    // Point<int> bestMove = await findBestMove(grid);

    // print("The Optimal Move is :\n");
    // print("[${bestMove.x}, ${bestMove.y}]");
    return super.onLoad();
  }

  void justDoIt() {
    if (!xTurn && !gameFreezed) {
      gameFreezed = true;
      timer = Timer.periodic(Duration(seconds: 1), (timer) async {
        Point<int> bestMove = await findBestMove(grid);

        print("The Optimal Move is :\n");
        print("[${bestMove.x}, ${bestMove.y}]");

        await grid[bestMove.x][bestMove.y].makeO();
        gameFreezed = false;
      });
    }
  }

  // This function returns true if there are moves
  // remaining on the board. It returns false if
  // there are no moves left to play.
  bool isMovesLeft(List<List<Box>> grid) {
    for (int i = 0; i < 3; i++)
      for (int j = 0; j < 3; j++)
        if (grid[i][j].state == BoxState.EMPTY) return true;
    return false;
  }

  // This is the evaluation function as discussed
  // in the previous article ( http://goo.gl/sJgv68 )
  int evaluate(List<List<Box>> grid) {
    // Checking for Rows for X or O victory.
    for (int row = 0; row < 3; row++) {
      if (grid[row][0] == grid[row][1] && grid[row][1] == grid[row][2]) {
        if (grid[row][0].state == BoxState.X)
          return 10;
        else if (grid[row][0].state == BoxState.O) return -10;
      }
    }

    // Checking for Columns for X or O victory.
    for (int col = 0; col < 3; col++) {
      if (grid[0][col] == grid[1][col] && grid[1][col] == grid[2][col]) {
        if (grid[0][col].state == BoxState.X)
          return 10;
        else if (grid[0][col].state == BoxState.O) return -10;
      }
    }

    // Checking for Diagonals for X or O victory.
    if (grid[0][0] == grid[1][1] && grid[1][1] == grid[2][2]) {
      if (grid[0][0].state == BoxState.X)
        return 10;
      else if (grid[0][0].state == BoxState.O) return -10;
    }

    if (grid[0][2] == grid[1][1] && grid[1][1] == grid[2][0]) {
      if (grid[0][2].state == BoxState.X)
        return 10;
      else if (grid[0][2].state == BoxState.O) return -10;
    }

    // Else if none of them have won then return 0
    return 0;
  }

  // This is the minimax function. It considers all
// the possible ways the game can go and returns
// the value of the board
  Future<int> minimax(List<List<Box>> grid, int depth, bool isMax) async {
    int score = evaluate(grid);

    // If Maximizer has won the game return his/her
    // evaluated score
    if (score == 10) return score;

    // If Minimizer has won the game return his/her
    // evaluated score
    if (score == -10) return score;

    // If there are no more moves and no winner then
    // it is a tie
    if (isMovesLeft(grid) == false) return 0;

    // If this maximizer's move
    if (isMax) {
      int best = -1000;

      // Traverse all cells
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          // Check if cell is empty
          if (grid[i][j].state == BoxState.EMPTY) {
            // Make the move
            await grid[i][j].makeX();

            // Call minimax recursively and choose
            // the maximum value
            best = max(best, await minimax(grid, depth + 1, !isMax));

            // Undo the move
            await grid[i][j].makeEmpty();
          }
        }
      }
      return best;
    }

    // If this minimizer's move
    else {
      int best = 1000;

      // Traverse all cells
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          // Check if cell is empty
          if (grid[i][j].state == BoxState.EMPTY) {
            // Make the move
            await grid[i][j].makeO();

            // Call minimax recursively and choose
            // the minimum value
            best = min(best, await minimax(grid, depth + 1, !isMax));

            // Undo the move
            await grid[i][j].makeEmpty();
          }
        }
      }
      return best;
    }
  }

  // This will return the best possible move for the player
  Future<Point<int>> findBestMove(List<List<Box>> grid) async {
    int bestVal = -1000;
    Point<int> bestMove;

    bestMove = Point(-1, -1);

    // Traverse all cells, evaluate minimax function for
    // all empty cells. And return the cell with optimal
    // value.
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        // Check if cell is empty
        if (grid[i][j].state == BoxState.EMPTY) {
          // Make the move
          grid[i][j].state = BoxState.X;

          // compute evaluation function for this
          // move.
          int moveVal = await minimax(grid, 0, false);

          // Undo the move
          await grid[i][j].makeEmpty();

          // If the value of the current move is
          // more than the best value, then update
          // best/
          if (moveVal > bestVal) {
            bestMove = Point(i, j);
            bestVal = moveVal;
          }
        }
      }
    }

    print("The value of the best Move is : %d\n\n$bestVal");

    return bestMove;
  }
}
 */
