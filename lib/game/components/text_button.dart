import 'package:flame/components.dart';
import 'package:flame/gestures.dart';
import 'package:flutter/material.dart';

class TextButtonComponent extends TextComponent<TextPaint> with Tapable {
  Function? onPressed;

  get config => this.textRenderer.config;

  TextButtonComponent(
    String text, {
    required this.onPressed,
    Color? textColor,
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
              color: textColor ?? Colors.white,
              fontFamily: fontFamily,
              lineHeight: lineHeight,
              textDirection: textDirection,
            ),
          ),
        ) {
    this.anchor = anchor;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  @override
  bool onTapUp(TapUpInfo info) {
    onPressed!();

    this.textRenderer =
        TextPaint(config: config.withColor(config.color.withOpacity(1.0)));

    return super.onTapUp(info);
  }

  @override
  bool onTapDown(TapDownInfo info) {
    this.textRenderer =
        TextPaint(config: config.withColor(config.color.withOpacity(0.5)));
    return super.onTapDown(info);
  }

  @override
  bool onTapCancel() {
    this.textRenderer =
        TextPaint(config: config.withColor(config.color.withOpacity(1.0)));
    return super.onTapCancel();
  }
}
