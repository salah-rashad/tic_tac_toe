import 'package:flutter/material.dart';
import 'package:tic_tac_toe/app/modules/game/game_page.dart';
import 'package:tic_tac_toe/app/modules/home/home_page.dart';
import 'package:tic_tac_toe/game/TicTacToe/tic_tac_toe.dart';

part './app_routes.dart';

abstract class AppPages {
  static const INITIAL = Routes.HOME;

  static Route generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case Routes.HOME:
        return MaterialPageRoute(builder: (context) => HomePage());

      case Routes.GAME:
        {
          final game = settings.arguments as TicTacToe;
          return MaterialPageRoute(builder: (context) => GamePage(game: game));
        }
      default:
        return MaterialPageRoute(builder: (ctx) => Error404Page());
    }
  }
}

class Error404Page extends StatelessWidget {
  const Error404Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Error: Page Not Found"),
      ),
    );
  }
}
