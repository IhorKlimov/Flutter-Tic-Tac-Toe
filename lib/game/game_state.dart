import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tic_tac_toe/ai/ai.dart';
import 'package:flutter_tic_tac_toe/constants/constants.dart';
import 'package:flutter_tic_tac_toe/game/game.dart';
import 'package:flutter_tic_tac_toe/victory/victory.dart';
import 'package:flutter_tic_tac_toe/victory/victory_checker.dart';
import 'package:flutter_tic_tac_toe/victory/victory_line.dart';

class GameState extends State<Game> {
  BuildContext _context;
  List<List<String>> field = [
    ['', '', ''],
    ['', '', ''],
    ['', '', '']
  ];
  Color playerColor, aiColor;
  AI ai;
  String playerChar = 'X', aiChar = 'O';
  bool playersTurn = true;
  Victory victory;

  @override
  Widget build(BuildContext context) {
    ai = AI(field, playerChar, aiChar);
    playerColor = Theme.of(context).primaryColor;
    aiColor = Colors.orange;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Builder(builder: (BuildContext context) {
          _context = context;
          return Center(
              child: Stack(
                  children: [buildGrid(), buildField(), buildVictoryLine()]));
        }));
  }

  Widget buildGrid() {
    return AspectRatio(
        aspectRatio: 1.0,
        child: Stack(
          children: [
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              buildHorizontalLine,
              buildHorizontalLine,
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              buildVerticalLine,
              buildVerticalLine,
            ])
          ],
        ));
  }

  Container get buildVerticalLine {
    return Container(
        margin: EdgeInsets.only(top: 16.0, bottom: 16.0),
        color: Colors.grey,
        width: 5.0);
  }

  Container get buildHorizontalLine {
    return Container(
        margin: EdgeInsets.only(left: 16.0, right: 16.0),
        color: Colors.grey,
        height: 5.0);
  }

  Widget buildField() {
    return AspectRatio(
        aspectRatio: 1.0,
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Expanded(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                buildCell(0, 0),
                buildCell(0, 1),
                buildCell(0, 2),
              ])),
          Expanded(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                buildCell(1, 0),
                buildCell(1, 1),
                buildCell(1, 2),
              ])),
          Expanded(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                buildCell(2, 0),
                buildCell(2, 1),
                buildCell(2, 2),
              ]))
        ]));
  }

  Widget buildCell(int row, int column) {
    return AspectRatio(
        aspectRatio: 1.0,
        child: MaterialButton(
            onPressed: () {
              if (!_gameIsDone() && playersTurn) {
                setState(() {
                  _displayPlayersTurn(row, column);

                  if (!_gameIsDone()) {
                    _displayAiTurn();
                  }
                });
              }
            },
            child: Text(field[row][column],
                style: TextStyle(
                  fontSize: 82.0,
                  fontFamily: 'Chalk',
                  color: field[row][column].isNotEmpty &&
                          field[row][column] == playerChar
                      ? playerColor
                      : aiColor,
                ))));
  }

  Widget buildVictoryLine() {
    return AspectRatio(
        aspectRatio: 1.0, child: CustomPaint(painter: VictoryLine(victory)));
  }

  void _displayPlayersTurn(int row, int column) {
    print('clicked on row $row column $column');
    playersTurn = false;
    field[row][column] = playerChar;

    _checkForVictory();
  }

  void _displayAiTurn() {
    Timer(Duration(milliseconds: 600), () {
      setState(() {
        // AI turn
        var aiDecision = ai.getDecision();
        field[aiDecision.row][aiDecision.column] = aiChar;
        playersTurn = true;
        _checkForVictory();
      });
    });
  }

  bool _gameIsDone() {
    return _allCellsAreTaken() || victory != null;
  }

  bool _allCellsAreTaken() {
    return field[0][0].isNotEmpty &&
        field[0][1].isNotEmpty &&
        field[0][2].isNotEmpty &&
        field[1][0].isNotEmpty &&
        field[1][1].isNotEmpty &&
        field[1][2].isNotEmpty &&
        field[2][0].isNotEmpty &&
        field[2][1].isNotEmpty &&
        field[2][2].isNotEmpty;
  }

  void _checkForVictory() {
    victory = VictoryChecker.checkForVictory(field, playerChar);
    if (victory != null) {
      String message;

      if (victory.winner == Constants.PLAYER) {
        message = 'You Win!';
      } else if (victory.winner == Constants.AI) {
        message = 'AI Win!';
      } else if (victory.winner == Constants.DRAFT) {
        message = 'Draft';
      }
      print(message);
      Scaffold.of(_context).showSnackBar(SnackBar(
            content: Text(message),
            duration: Duration(minutes: 1),
            action: SnackBarAction(
                label: 'Retry',
                onPressed: () {
                  setState(() {
                    victory = null;
                    field = [
                      ['', '', ''],
                      ['', '', ''],
                      ['', '', '']
                    ];
                    playersTurn = true;
                  });
                }),
          ));
    }
  }
}
