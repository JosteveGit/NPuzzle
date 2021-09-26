import 'dart:math';
import 'package:eight_puzzle/core/models/game.dart';

class Shuffler {
  static void shuffle({
    List<int> state,
    bool Function(List<int> state) onShuffle,
    int moves,
  }) async {
    Game game = Game(state);
    while (moves != 0) {
      Map actionAndState = game.getAvaliableActionsAndStates();
      int random = Random().nextInt(actionAndState.length);
      var action = actionAndState.keys.toList()[random];
      List<int> nextState = actionAndState[action];
      game = Game(nextState);
      bool shouldContinue = onShuffle(nextState);
      if (shouldContinue) {
        await Future.delayed(Duration(milliseconds: 200));
        moves--;
      } else {
        break;
      }
    }
  }
}
