import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe/game/TicTacToe/tic_tac_toe.dart';

enum BoxState { EMPTY, X, O }

class Box extends SpriteComponent with Tapable, HasGameRef<TicTacToe> {
  final Vector2 size, position;
  final Point<int> location;
  final int gameSize;
  final bool isAIGame;

  Paint? fillPaint;
  Paint? strokePaint;

  BoxState state = BoxState.EMPTY;

  bool get isX => state == BoxState.X;
  bool get isO => state == BoxState.O;

  Box(
      {required this.size,
      required this.position,
      required this.location,
      required this.gameSize,
      this.isAIGame = false})
      : super(size: size, position: position) {
    //
    fillPaint = new Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    //
    strokePaint = new Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = gameSize < 6 ? 7.0 : 3.0;
  }

  Future<void> makeX() async {
    state = BoxState.X;
    sprite = await Sprite.load("x.png");

    // print("X");
  }

  Future<void> makeO() async {
    state = BoxState.O;
    sprite = await Sprite.load("o.png");

    // print("O");
  }

  Future<void> makeEmpty() async {
    state = BoxState.EMPTY;
    sprite = null;

    // print("O");
  }

  @override
  Future<void>? onLoad() async {
    sprite = null;

    return super.onLoad();
  }

  @override
  void render(Canvas c) {
    c.drawRRect(
        RRect.fromRectAndRadius(
            this.toRect(), Radius.circular(gameSize < 6 ? 16.0 : 8.0)),
        fillPaint!);
    c.drawRect(this.toRect(), strokePaint!);

    if (gameRef.gameFreezed && fillPaint?.color == Colors.white) {
      fillPaint?.color = Colors.white24;
      sprite?.paint.color = sprite!.paint.color.withOpacity(0.24);
    }
    super.render(c);
  }

  @override
  bool onTapDown(TapDownInfo info) {
    if (gameRef.gameFreezed || gameRef.gameFinished) return false;
    if (state == BoxState.EMPTY) {
      gameRef.makeMove(this);
    }

    return super.onTapDown(info);
  }
}
