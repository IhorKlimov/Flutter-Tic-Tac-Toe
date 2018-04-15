import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tic_tac_toe/constants/constants.dart';
import 'package:flutter_tic_tac_toe/model/user.dart';
import 'package:flutter_tic_tac_toe/user_list/user_list.dart';

class UserListState extends State<UserList> {
  List<User> _users = List<User>();

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    print('build');

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: ListView.builder(
            itemCount: _users.length, itemBuilder: _buildListRow));
  }

  Widget _buildListRow(BuildContext context, int index) => Container(
      height: 56.0,
      child: InkWell(
          onTap: () {
            Scaffold.of(context).showSnackBar(
                SnackBar(content: Text('Clicked on ${_users[index].name}')));
          },
          child: Container(
              padding: EdgeInsets.all(16.0),
              alignment: Alignment.centerLeft,
              child: Text(
                '${_users[index].name}',// Some weird bugs if passed without quotes
                style: TextStyle(fontSize: 18.0),
              ))));

  void _fetchUsers() async {
    var snapshot =
        await FirebaseDatabase.instance.reference().child('users').once();

    Map<String, dynamic> users = snapshot.value.cast<String, dynamic>();
    users.forEach((userId, userMap) {
      User user = _parseUser(userId, userMap);
      setState(() {
        _users.add(user);
      });
    });
  }

  // Haven't figured out how to use built-in map-to-POJO parsers yet
  User _parseUser(String userId, Map<dynamic, dynamic> user) {
    String name, photoUrl, pushId;
    user.forEach((key, value) {
      if (key == NAME) {
        name = value as String;
      }
      if (key == PHOTO_URL) {
        photoUrl = value as String;
      }
      if (key == PUSH_ID) {
        pushId = value as String;
      }
    });

    return User(userId, name, photoUrl, pushId);
  }
}
