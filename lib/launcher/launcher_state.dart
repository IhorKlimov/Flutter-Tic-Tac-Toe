import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tic_tac_toe/common/constants.dart';
import 'package:flutter_tic_tac_toe/game/game.dart';
import 'package:flutter_tic_tac_toe/launcher/launcher.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_tic_tac_toe/model/user.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_tic_tac_toe/common/util.dart';
import 'package:http/http.dart' as http;

class LauncherState extends State<Launcher> {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print("onMessage: $message");
        handleMessage(message);
      },
      onLaunch: (Map<String, dynamic> message) {
        print("onLaunch: $message");
        handleMessage(message);
      },
      onResume: (Map<String, dynamic> message) {
        print("onResume: $message");
        handleMessage(message);
      },
    );
    firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    updateFcmToken();
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

  void showInvitePopup(BuildContext context, Map<String, dynamic> message) {
    print(context == null);

    Timer(Duration(milliseconds: 200), () {
      showDialog<bool>(
        context: context,
        builder: (_) => buildDialog(context, message),
      );
    });
  }

  Widget buildDialog(BuildContext context, Map<String, dynamic> message) {
    var fromName = getValueFromMap(message, 'fromName');

    return AlertDialog(
      content: Text('$fromName invites you to play!'),
      actions: <Widget>[
        FlatButton(
          child: Text('Decline'),
          onPressed: () {},
        ),
        FlatButton(
          child: Text('Accept'),
          onPressed: () {
            accept(message);
          },
        ),
      ],
    );
  }

  void openUserList() async {
    FirebaseUser user = await signInWithGoogle();
    await saveUserToFirebase(user);
    Navigator.of(context).pushNamed('userList');
  }

  Future<FirebaseUser> signInWithGoogle() async {
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

  Future<void> saveUserToFirebase(FirebaseUser user) async {
    print('saving user to firebase');
    var token = await firebaseMessaging.getToken();

    await saveUserToPreferences(user.uid, user.displayName, token);

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

  saveUserToPreferences(String userId, String userName, String pushId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(USER_ID, userId);
    prefs.setString(PUSH_ID, pushId);
    prefs.setString(USER_NAME, userName);
  }

  // Not sure how FCM token gets updated yet
  // just to make sure correct one is always set
  void updateFcmToken() async {
    var currentUser = await _auth.currentUser();
    if (currentUser != null) {
      var token = await firebaseMessaging.getToken();
      print(token);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(PUSH_ID, token);

      FirebaseDatabase.instance
          .reference()
          .child(USERS)
          .child(currentUser.uid)
          .update({PUSH_ID: token});
      print('updated FCM token');
    }
  }

  void accept(Map<String, dynamic> message) async {
    String fromPushId = getValueFromMap(message, 'fromPushId');
    String fromId = getValueFromMap(message, 'fromId');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var username = prefs.getString(USER_NAME);
    var pushId = prefs.getString(PUSH_ID);
    var userId = prefs.getString(USER_ID);

    var base = 'https://us-central1-tictactoe-64902.cloudfunctions.net';
    String dataURL =
        '$base/sendNotification2?to=$fromPushId&fromPushId=$pushId&fromId=$userId&fromName=$username&type=accept';
    print(dataURL);
    http.Response response = await http.get(dataURL);

    String gameId = '$fromId-$userId';

    Navigator.of(context).push(new MaterialPageRoute(
        builder: (context) => new Game(
            title: 'Tic Tac Toe',
            type: "wifi",
            me: 'O',
            gameId: gameId,
            withId: fromId)));
  }

  void handleMessage(Map<String, dynamic> message) async {
    var type = getValueFromMap(message, 'type');
    var fromId = getValueFromMap(message, 'fromId');

    print(type);
    if (type == 'invite') {
      showInvitePopup(context, message);
    } else if (type == 'accept') {
      var currentUser = await _auth.currentUser();

      String gameId = '${currentUser.uid}-$fromId';
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (context) => new Game(
              title: 'Tic Tac Toe',
              type: "wifi",
              me: 'X',
              gameId: gameId,
              withId: fromId)));
    } else if (type == 'reject') {}
  }
}
