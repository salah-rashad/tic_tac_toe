import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Widget icon;
  final void Function()? onPressed;
  final String text;
  final Color? textColor;
  final Color? backgroundColor;

  const CustomButton.icon({
    Key? key,
    required this.icon,
    required this.onPressed,
    required this.text,
    this.textColor,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: this.icon,
      label: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 22.0,
        ),
      ),
      style: ElevatedButton.styleFrom(
        primary: backgroundColor,
        onPrimary: textColor,
        minimumSize: Size(50.0, 75.0),
      ),
    );
  }
}
