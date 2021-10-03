import 'dart:math';
import 'package:eight_puzzle/core/models/game.dart';
import 'package:flutter/material.dart';

class Shuffler {
  static void shuffle({
    List<int> state,
    bool Function(List<int> state) onShuffle,
    VoidCallback onDone,
    int moves,
  }) async {
    if (Shuffler.isShuffling) {
      return;
    }
    Shuffler.isShuffling = true;
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
    Shuffler.isShuffling = false;
  }

  static void stop() {
    _shouldShuggle = false;
  }

  static bool get shouldNotShuffle => !_shouldShuggle;

  static void reset() {
    _shouldShuggle = true;
    isShuffling = false;
  }

  static bool _shouldShuggle = true;
  static bool isShuffling = false;
}
