import 'package:flutter/material.dart';
import 'package:flutter_tic_tac_toe/game/game.dart';

class GameState extends State<Game> {
  var field = [['', '', ''], ['', '', ''], ['', '', '']];
  var playerChar = 'X';

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
        body: new Center (
            child: new Stack(
                children: [
                  buildGrid(),
                  buildField()
                ]
            )));
  }

  Widget buildGrid() {
    return new AspectRatio(aspectRatio: 1.0,
        child: new Stack(
          children: [
            new Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  new Container(
                      margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                      color: Colors.grey,
                      height: 5.0
                  ),
                  new Container(
                      margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                      color: Colors.grey,
                      height: 5.0
                  ),
                ]
            ),
            new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  new Container(
                      margin: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                      color: Colors.grey,
                      width: 5.0
                  ),
                  new Container(
                      margin: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                      color: Colors.grey,
                      width: 5.0
                  ),
                ]
            )
          ],
        ));
  }

  Widget buildField() {
    return new AspectRatio(aspectRatio: 1.0,
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              new Expanded(
                  child: new Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceEvenly,
                      children: [
                        buildCell(0, 0),
                        buildCell(0, 1),
                        buildCell(0, 2),
                      ]
                  )),
              new Expanded(
                  child: new Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceEvenly,
                      children: [
                        buildCell(1, 0),
                        buildCell(1, 1),
                        buildCell(1, 2),
                      ]
                  )),
              new Expanded(
                  child: new Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceEvenly,
                      children: [
                        buildCell(2, 0),
                        buildCell(2, 1),
                        buildCell(2, 2),
                      ]
                  ))
            ]
        )
    );
  }

  Widget buildCell(int row, int column) {
    Color color = Theme
        .of(context)
        .primaryColor;
    return new AspectRatio(aspectRatio: 1.0,
        child: new MaterialButton(
            onPressed: () {
              setState(() {
                field[row][column] = playerChar;
                print('clicked on row $row column $column');
              });
            },
            child: new Text(field[row][column], style: new TextStyle(
              fontSize: 82.0,
              fontFamily: 'Chalk',
              color: color,
            )))
    );
  }
}

