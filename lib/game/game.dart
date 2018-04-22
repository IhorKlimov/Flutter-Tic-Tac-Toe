import 'package:flutter/material.dart';
import 'package:flutter_tic_tac_toe/game/game_state.dart';

class Game extends StatefulWidget {
  Game({Key key, this.title, this.type, this.me, this.gameId, this.withId})
      : super(key: key);

  final String title, type, me, gameId, withId;

  @override
  GameState createState() => GameState(type: type, me: me, gameId: gameId, withId: withId);
}
