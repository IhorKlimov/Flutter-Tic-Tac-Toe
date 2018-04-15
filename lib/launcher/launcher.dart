import 'package:flutter/material.dart';
import 'package:flutter_tic_tac_toe/launcher/launcher_state.dart';

class Launcher extends StatefulWidget {
  Launcher({Key key, this.title}) : super(key: key);

  final String title;

  @override
  LauncherState createState() => LauncherState();
}
