import 'package:flutter/material.dart';
import 'package:flutter_tic_tac_toe/game/game.dart';
import 'package:flutter_tic_tac_toe/launcher/launcher.dart';

void main() => runApp(new TicTacToe());

class TicTacToe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Tic Tac Toe',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new Launcher(title: 'Tic Tac Toe'),
      routes: <String, WidgetBuilder> {
        'singleGame': (BuildContext context) => new Game(title: 'Tic Tac Toe'),
        'multiplayerGame': (BuildContext context) => new Game(title: 'Tic Tac Toe')
      },
    );
  }
}

