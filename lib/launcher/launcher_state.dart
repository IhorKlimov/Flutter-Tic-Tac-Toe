import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tic_tac_toe/launcher/launcher.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


class LauncherState extends State<Launcher> {
  final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print("onMessage: $message");
        _showItemDialog(context, message);
      },
      onLaunch: (Map<String, dynamic> message) {
        print("onLaunch: $message");
        Navigator.pushNamed(context, 'singleGame');
      },
      onResume: (Map<String, dynamic> message) {
        print("onResume: $message");
        _showItemDialog(context, message);
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token){
      print(token);
    });

  }
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
  void _showItemDialog(BuildContext context, Map<String, dynamic> message) {
    print(context == null);

    print('show dialog ');

    new Timer(const Duration(milliseconds: 200), (){
      showDialog<bool>(
        context: context,
        builder: (_) => _buildDialog(context),
      );

//      Navigator.of(context).pushNamed('singleGame');
    });
  }

  Widget _buildDialog(BuildContext context) {
    return new AlertDialog(
      content: new Text("Some text"),
      actions: <Widget>[
        new FlatButton(
          child: const Text('CLOSE'),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        new FlatButton(
          child: const Text('SHOW'),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ],
    );
  }
}
