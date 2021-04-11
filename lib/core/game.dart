import 'dart:math';

class Game {
  final List<int> state;
  int dimension;

  Game(this.state) {
    dimension = sqrt(state.length).toInt();
  }

  Map getAvaliableActionsAndStates() {
    var result = {};
    var zeroIndex = state.indexOf(0);
    var row = (zeroIndex / dimension).floor();
    var column = zeroIndex % dimension;

    if (column > 0)
      result[GameAction.LEFT] = getNextState(GameAction.LEFT);
    if (column < dimension - 1)
      result[GameAction.RIGHT] = getNextState(GameAction.RIGHT);
    if (row > 0) result[GameAction.UP] = getNextState(GameAction.UP);
    if (row < dimension - 1)
      result[GameAction.DOWN] = getNextState(GameAction.DOWN);


    return result;
  }

  getNextState(GameAction action) {
    var zeroIndex = state.indexOf(0);
    var newIndex;

    switch (action) {
      case GameAction.LEFT:
        newIndex = zeroIndex - 1;
        break;
      case GameAction.RIGHT:
        newIndex = zeroIndex + 1;
        break;
      case GameAction.UP:
        newIndex = zeroIndex - dimension;
        break;
      case GameAction.DOWN:
        newIndex = zeroIndex + dimension;
        break;
      default:
        throw new Exception('Unexpected action');
    }
    var stateArr =
        List.generate(state.length, (index) => state[index]);
    if (zeroIndex >= 0) {
      stateArr[zeroIndex] = stateArr[newIndex];
      stateArr[newIndex] = 0;
    }

    return stateArr;
  }

  List<int> getDesiredState() {
    return List.generate(state.length, (index) {
      if (index == state.length - 1) {
        return 0;
      }
      return index + 1;
    });
  }

  bool isFinished() {
    return state.join("") == getDesiredState().join("");
  }

  int getManhattanDistance() {
    var solved = getDesiredState();
    var mValue = 0;
    for (var i = 0; i < state.length; i++) {
      if (state[i] == 0) {
        continue;
      }
      var clonedRowValue = (i / dimension).floor();
      var clonedColumnValue = i % dimension;

      var solvedStateIndex = solved.indexOf(state[i]);
      var solvedStateRowValue = (solvedStateIndex / dimension).floor();
      var solvedStateColumnValue = solvedStateIndex % dimension;

      var rowDifference = (clonedRowValue - solvedStateRowValue).abs();
      var columnDifference = (clonedColumnValue - solvedStateColumnValue).abs();
      mValue += (rowDifference + columnDifference);
    }
    return mValue;
  }
}

enum GameAction {
  LEFT,
  RIGHT,
  UP,
  DOWN,
}
