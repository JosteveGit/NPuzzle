import 'game.dart';

class Node {
  List<int> stateList;
  Node parent;
  int cost;
  GameAction action;
  Game game;

  Node({
    this.stateList,
    this.parent,
    this.cost = 0,
    this.action,
  }) {
    game = Game(stateList);
  }

  List<Node> expand() {
    List<Node> result = [];

    var avaliableActionsAndStates = game.getAvaliableActionsAndStates();

    avaliableActionsAndStates.forEach((action, state) {
      Node childNode = Node(
        stateList: state,
        parent: this,
        cost: (this.cost ?? 0) + 1,
        action: action,
      );
      result.add(childNode);
    });

    return result;
  }

  @override
  String toString() {
    return "Node(state: $stateList, cost: $cost, action: ${action.toString()}, heurisitcVale: ${game.getManhattanDistance() + cost})";
  }

  String get state => stateList.join("");
}
