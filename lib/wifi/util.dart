import 'package:firebase_database/firebase_database.dart';

class Util{
  static savePushToken(String token, String userId) {
    print('saving user token $token of user id $userId');
    FirebaseDatabase.instance.reference()
        .child('users')
        .child(userId)
        .child('pushId')
        .set(token);
  }
}