import 'package:flutter/material.dart';
import 'package:flutter_tic_tac_toe/game/game_state.dart';

class Game extends StatefulWidget {
  Game({Key key, this.title}) : super(key: key);

  final String title;

  @override
  GameState createState() => GameState();
}
