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
          gridCell: Point(x, y),
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

  void checkWin(Box box) {
    message = (xTurn ? "X" : "O") + " Turn";

    gameFreezed = true;

    if (!horizontal(box) &&
        !vertical(box) &&
        !diagonal1(box) &&
        !diagonal2(box)) checkTie(box);
  }

  bool isWin(int counter, Box box, {Function? onWinCallback}) {
    if (counter == gameSize) {
      gameFreezed = true;
      message = (box.isX ? "X" : "O") + " WINS";
      messageText =
          textPaint(fontSize: MESSAGE_FONT_SIZE, color: Colors.greenAccent);

      onWinCallback!();
      addRestartButton();
      gameFreezed = true;
      return true;
    } else {
      gameFreezed = false;
      return false;
    }
  }

  bool horizontal(Box box, {bool win = false}) {
    int counter = 0;

    if (win) increaseWinTimes(box.state);

    for (int x = 0; x < gameSize; x++) {
      var b = grid[x][box.gridCell.y];

      if (win) {
        addgGreen(b);
      } else {
        if (b.state == box.state)
          counter++;
        else
          break;
      }
    }

    return isWin(counter, box, onWinCallback: () => horizontal(box, win: true));
  }

  bool vertical(Box box, {bool win = false}) {
    int counter = 0;

    if (win) increaseWinTimes(box.state);

    for (int y = 0; y < gameSize; y++) {
      var b = grid[box.gridCell.x][y];

      if (win) {
        addgGreen(b);
      } else {
        if (b.state == box.state)
          counter++;
        else
          break;
      }
    }

    return isWin(counter, box, onWinCallback: () => vertical(box, win: true));
  }

  bool diagonal1(Box box, {bool win = false}) {
    int counter = 0;

    if (win) increaseWinTimes(box.state);

    for (int x = 0, y = 0; x < gameSize; x++, y++) {
      var b = grid[x][y];

      if (win) {
        addgGreen(b);
      } else {
        if (b.state == box.state)
          counter++;
        else
          break;
      }
    }

    return isWin(counter, box, onWinCallback: () => diagonal1(box, win: true));
  }

  bool diagonal2(Box box, {bool win = false}) {
    int counter = 0;

    if (win) increaseWinTimes(box.state);

    for (int x = 0, y = gameSize - 1; x < gameSize; x++, y--) {
      var b = grid[x][y];

      if (win) {
        addgGreen(b);
      } else {
        if (b.state == box.state)
          counter++;
        else
          break;
      }
    }

    return isWin(counter, box, onWinCallback: () => diagonal2(box, win: true));
  }

  void checkTie(Box box) {
    int c = 0;

    for (int x = 0; x < gameSize; x++) {
      for (int y = 0; y < gameSize; y++) {
        if (grid[x][y].state != BoxState.EMPTY) c++;
      }
    }

    if (c == gameSize * gameSize) {
      message = "TIE";
      messageText =
          textPaint(fontSize: MESSAGE_FONT_SIZE, color: Colors.orange);

      addRestartButton();
      gameFreezed = true;
    }
  }

  void addgGreen(Box b) {
    b.fillPaint?.color = Colors.greenAccent;
  }

  void addRestartButton() {
    add(
      TextButtonComponent(
        "PLAY AGAIN!",
        onPressed: () => reset(),
        position: Vector2(width / 2, height - 150.0),
        anchor: Anchor.center,
        textColor: Colors.white,
      ),
    );
  }

  void reset() {
    removeAll(components);
    grid = [];
    onLoad();
    gameFreezed = false;
    messageText = textPaint(fontSize: MESSAGE_FONT_SIZE, color: Colors.black);
  }

  void increaseWinTimes(BoxState state) {
    if (state == BoxState.X) xWinTimes++;
    if (state == BoxState.O) oWinTimes++;
  }
}

class AI extends TicTacToe {
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
