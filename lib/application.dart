import 'package:flutter/material.dart';
import 'package:flutter_tic_tac_toe/common/constants.dart';
import 'package:flutter_tic_tac_toe/game/game.dart';
import 'package:flutter_tic_tac_toe/launcher/launcher.dart';
import 'package:flutter_tic_tac_toe/user_list/user_list.dart';

void main() => runApp(TicTacToe());

class TicTacToe extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Tic Tac Toe',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Launcher(title: 'Tic Tac Toe'),
        routes: <String, WidgetBuilder>{
          SINGLE_GAME: (BuildContext context) => Game(title: 'Tic Tac Toe'),
          USER_LIST: (BuildContext context) => UserList(title: 'All users')
        },
      );
}
