import 'package:flutter/material.dart';
import 'package:flutter_tic_tac_toe/user_list/user_list.dart';
import 'package:firebase_database/firebase_database.dart';

class UserListState extends State<UserList> {
  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Text('hi'));

  void _fetchUsers() async {
    var users =
        await FirebaseDatabase.instance.reference().child('users').once();
    print(users);
  }
}
