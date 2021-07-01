import 'dart:async';

import 'package:tic_tac_toe/game/TicTacToe/tic_tac_toe.dart';

class AIGame extends TicTacToe {
  Timer? timer;

  AIGame({required int gameSize}) : super(gameSize: gameSize, vsPlayer: false);

  @override
  Future<void> onLoad() async {
    xTurn = true;
    return super.onLoad();
  }
}
