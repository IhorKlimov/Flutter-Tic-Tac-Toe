import 'package:flutter/material.dart';
import 'package:flutter_tic_tac_toe/main_page/main_page.dart';

void main() => runApp(new TicTacToe());

class TicTacToe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Tic Tac Toe',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MainPage(title: 'Tic Tac Toe'),
    );
  }
}

