import 'package:flame/components.dart';
import 'package:flame/gestures.dart';
import 'package:flutter/material.dart';

class TextButtonComponent extends TextComponent<TextPaint> with Tapable {
  Function? onPressed;
  Color backgroundColor;

  get config => this.textRenderer.config;

  Paint background = Paint();

  TextButtonComponent(
    String text, {
    required this.onPressed,
    Color textColor = Colors.white,
    this.backgroundColor = Colors.black,
    String fontFamily = 'Arial',
    double fontSize = 24.0,
    TextDirection textDirection = TextDirection.ltr,
    double? lineHeight,
    Vector2? position,
    Vector2? size,
    int? priority,
    Anchor anchor = Anchor.topLeft,
  }) : super(
          text,
          position: position,
          size: size,
          priority: priority,
          textRenderer: TextPaint(
            config: TextPaintConfig(
              fontSize: fontSize,
              color: textColor,
              fontFamily: fontFamily,
              lineHeight: lineHeight,
              textDirection: textDirection,
            ),
          ),
        ) {
    this.anchor = anchor;
  }

  @override
  Future<void>? onLoad() {
    background.color = backgroundColor;
    return super.onLoad();
  }

  @override
  void render(Canvas c) {
    Rect rect = Rect.fromCenter(
      center: this.center.toOffset(),
      width: this.width + 16.0,
      height: this.height + 16.0,
    );

    c.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(8.0)), background);
    super.render(c);
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  @override
  bool onTapUp(TapUpInfo info) {
    onPressed!();

    // this.textRenderer =
    //     TextPaint(config: config.withColor(config.color.withOpacity(1.0)));

    background.color = backgroundColor.withOpacity(1.0);
    return super.onTapUp(info);
  }

  @override
  bool onTapDown(TapDownInfo info) {
    // this.textRenderer =
    //     TextPaint(config: config.withColor(config.color.withOpacity(0.5)));

    background.color = backgroundColor.withOpacity(0.7);
    return super.onTapDown(info);
  }

  @override
  bool onTapCancel() {
    // this.textRenderer =
    //     TextPaint(config: config.withColor(config.color.withOpacity(1.0)));

    background.color = backgroundColor.withOpacity(1.0);
    return super.onTapCancel();
  }
}
