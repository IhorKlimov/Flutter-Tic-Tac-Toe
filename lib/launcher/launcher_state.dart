import 'package:flutter/material.dart';
import 'package:flutter_tic_tac_toe/launcher/launcher.dart';

class LauncherState extends State<Launcher> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
        body: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              new MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('singleGame');
                  },
                  padding: const EdgeInsets.all(8.0),
                  child: new Text('Single Mode',
                      style: new TextStyle(fontSize: 32.0))),
              new Container(
                  margin: const EdgeInsets.only(top: 16.0),
                  child: new MaterialButton(
                    padding: const EdgeInsets.all(8.0),
                      onPressed: () {},
                      child: new Text('Multiplayer',
                          style: new TextStyle(fontSize: 34.0)))),
            ],
          ),
        ));
  }
}
