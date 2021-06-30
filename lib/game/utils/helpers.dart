import 'dart:ui';

import 'package:flame/components.dart';

TextPaint textPaint({
  double fontSize = 24.0,
  Color color = const Color(4278190080),
  String fontFamily = 'Arial',
  double? lineHeight,
  TextDirection textDirection = TextDirection.ltr,
  TextAlign textAlign = TextAlign.center,
}) {
  return TextPaint(
    config: TextPaintConfig(
      fontSize: fontSize,
      color: color,
      fontFamily: fontFamily,
      lineHeight: lineHeight,
      textDirection: textDirection,
    ).withTextAlign(textAlign),
  );
}
