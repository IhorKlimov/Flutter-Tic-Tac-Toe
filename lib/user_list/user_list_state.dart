import 'package:flutter/material.dart';
import 'package:flutter_tic_tac_toe/user_list/user_list.dart';

class UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Text('hi'));
}
