import 'package:flutter/material.dart';
import 'package:flutter_tic_tac_toe/user_list/user_list_state.dart';

class UserList extends StatefulWidget {
  final String title;

  UserList({Key key, this.title}) : super(key: key);

  @override
  UserListState createState() => UserListState();
}
