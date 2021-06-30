import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe/app/routes/app_pages.dart';

Future<void> main() async {
  runApp(MyApp());

  await Flame.device.fullScreen();
  await Flame.device.setPortraitUpOnly();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Tic Tac Toe",
      initialRoute: AppPages.INITIAL,
      onGenerateRoute: (settings) => AppPages.generateRoutes(settings),
    );
  }
}
