import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tic_tac_toe/constants/constants.dart';
import 'package:flutter_tic_tac_toe/launcher/launcher.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class LauncherState extends State<Launcher> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print("onMessage: $message");
//        _showItemDialog(context, message);
      },
      onLaunch: (Map<String, dynamic> message) {
        print("onLaunch: $message");
//        Navigator.pushNamed(context, 'singleGame');
      },
      onResume: (Map<String, dynamic> message) {
        print("onResume: $message");
//        _showItemDialog(context, message);
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _updateFcmToken();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(SINGLE_GAME);
                },
                padding: EdgeInsets.all(8.0),
                child: Text('Single Mode', style: TextStyle(fontSize: 32.0))),
            Container(
                margin: EdgeInsets.only(top: 16.0),
                child: MaterialButton(
                    padding: EdgeInsets.all(8.0),
                    onPressed: () {
                      openUserList();
                    },
                    child:
                        Text(MULTIPLAYER, style: TextStyle(fontSize: 34.0)))),
          ],
        ),
      ));

  void _showItemDialog(BuildContext context, Map<String, dynamic> message) {
    print(context == null);

    print('show dialog ');

    Timer(Duration(milliseconds: 200), () {
      showDialog<bool>(
        context: context,
        builder: (_) => _buildDialog(context),
      );

//      Navigator.of(context).pushNamed('singleGame');
    });
  }

  Widget _buildDialog(BuildContext context) => AlertDialog(
        content: Text("Some text"),
        actions: <Widget>[
          FlatButton(
            child: Text('CLOSE'),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
          FlatButton(
            child: Text('SHOW'),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
        ],
      );

  Future<FirebaseUser> _signInWithGoogle() async {
    var user = await _auth.currentUser();
    if (user == null) {
      GoogleSignInAccount googleUser = _googleSignIn.currentUser;
      if (googleUser == null) {
        googleUser = await _googleSignIn.signInSilently();
        if (googleUser == null) {
          googleUser = await _googleSignIn.signIn();
        }
      }

      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      user = await _auth.signInWithGoogle(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      print("signed in as " + user.displayName);
    }

    return user;
  }

  void openUserList() async {
    FirebaseUser user = await _signInWithGoogle();
    await _saveUserToFirebase(user);
    Navigator.of(context).pushNamed('userList');
  }

  Future<void> _saveUserToFirebase(FirebaseUser user) async {
    print('saving user to firebase');
    var token = await _firebaseMessaging.getToken();
    var update = {
      NAME: user.displayName,
      PHOTO_URL: user.photoUrl,
      PUSH_ID: token
    };
    return FirebaseDatabase.instance
        .reference()
        .child(USERS)
        .child(user.uid)
        .update(update);
  }

  // Not sure how FCM token gets updated yet
  // just to make sure correct one is always set
  void _updateFcmToken() async {
    var currentUser = await _auth.currentUser();
    if (currentUser != null) {
      var token = await _firebaseMessaging.getToken();
      FirebaseDatabase.instance
          .reference()
          .child(USERS)
          .child(currentUser.uid)
          .update({PUSH_ID: token});
      print('updated FCM token');
    }
  }
}
