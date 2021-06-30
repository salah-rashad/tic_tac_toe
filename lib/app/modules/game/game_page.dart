import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe/game/TicTacToe/tic_tac_toe.dart';

class GamePage extends StatelessWidget {
  final TicTacToe? game;

  const GamePage({Key? key, this.game}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(
        game: game ?? TicTacToe(gameSize: 3, vsPlayer: true),
      ),
    );
  }
}
