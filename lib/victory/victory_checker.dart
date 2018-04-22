import 'package:flutter_tic_tac_toe/common/constants.dart';
import 'package:flutter_tic_tac_toe/victory/victory.dart';

class VictoryChecker {
  static Victory checkForVictory(List<List<String>> field, String playerChar) {
    Victory v;
    //check horizontal lines
    if (field[0][0].isNotEmpty &&
        field[0][0] == field[0][1] &&
        field[0][0] == field[0][2]) {
      v = new Victory(0, 0, HORIZONTAL,
          field[0][0] == playerChar ? PLAYER_WINNER : AI_WINNER);
    } else if (field[1][0].isNotEmpty &&
        field[1][0] == field[1][1] &&
        field[1][0] == field[1][2]) {
      v = new Victory(1, 0, HORIZONTAL,
          field[1][0] == playerChar ? PLAYER_WINNER : AI_WINNER);
    } else if (field[2][0].isNotEmpty &&
        field[2][0] == field[2][1] &&
        field[2][0] == field[2][2]) {
      v = new Victory(2, 0, HORIZONTAL,
          field[2][0] == playerChar ? PLAYER_WINNER : AI_WINNER);
    }

    //check vertical lines
    else if (field[0][0].isNotEmpty &&
        field[0][0] == field[1][0] &&
        field[0][0] == field[2][0]) {
      v = new Victory(0, 0, VERTICAL,
          field[0][0] == playerChar ? PLAYER_WINNER : AI_WINNER);
    } else if (field[0][1].isNotEmpty &&
        field[0][1] == field[1][1] &&
        field[0][1] == field[2][1]) {
      v = new Victory(0, 1, VERTICAL,
          field[0][1] == playerChar ? PLAYER_WINNER : AI_WINNER);
    } else if (field[0][2].isNotEmpty &&
        field[0][2] == field[1][2] &&
        field[0][2] == field[2][2]) {
      v = new Victory(0, 2, VERTICAL,
          field[0][2] == playerChar ? PLAYER_WINNER : AI_WINNER);
    }

    //check diagonal
    else if (field[0][0].isNotEmpty &&
        field[0][0] == field[1][1] &&
        field[0][0] == field[2][2]) {
      v = new Victory(0, 0, DIAGONAL_DESCENDING,
          field[0][0] == playerChar ? PLAYER_WINNER : AI_WINNER);
    } else if (field[2][0].isNotEmpty &&
        field[2][0] == field[1][1] &&
        field[2][0] == field[0][2]) {
      v = new Victory(2, 0, DIAGONAL_ASCENDING,
          field[2][0] == playerChar ? PLAYER_WINNER : AI_WINNER);
    } else if (field[0][0].isNotEmpty &&
        field[0][1].isNotEmpty &&
        field[0][2].isNotEmpty &&
        field[1][0].isNotEmpty &&
        field[1][1].isNotEmpty &&
        field[1][2].isNotEmpty &&
        field[2][0].isNotEmpty &&
        field[2][1].isNotEmpty &&
        field[2][2].isNotEmpty) {
      v = new Victory(-1, -1, -1, DRAFT);
    }

    return v;
  }
}
