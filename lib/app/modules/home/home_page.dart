import 'package:flutter/material.dart';
import 'package:tic_tac_toe/app/routes/app_pages.dart';
import 'package:tic_tac_toe/app/widgets/custom_button.dart';
import 'package:tic_tac_toe/game/TicTacToe/tic_tac_toe.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<int> gameSizes = List.generate(7, (index) => index + 3);

  int currentValue = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DropdownButton<int>(
              value: currentValue,
              items: gameSizes
                  .map((size) => DropdownMenuItem<int>(
                        value: size,
                        child: Text("$size x $size"),
                      ))
                  .toList(),
              onChanged: (int? newValue) {
                setState(() {
                  currentValue = newValue!;
                });
              },
            ),
            SizedBox(
              height: 32.0,
            ),
            CustomButton.icon(
              icon: Icon(Icons.person),
              onPressed: () => Navigator.pushNamed(
                context,
                Routes.GAME,
                arguments: TicTacToe(gameSize: currentValue, vsPlayer: true),
              ),
              text: "Player vs. Player",
            ),
            SizedBox(
              height: 32.0,
            ),
            CustomButton.icon(
              icon: Icon(Icons.smart_toy_rounded),
              onPressed: () => Navigator.pushNamed(
                context,
                Routes.GAME,
                arguments: AI(),
              ),
              text: "Player vs. AI",
            ),
          ],
        ),
      ),
    );
  }
}
