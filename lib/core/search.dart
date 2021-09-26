import 'dart:math';
import 'node.dart';

_NextSearchDetails _search({
  Node node,
  List<Node> frontierListx,
  int maxFrontierListLengthx = 0,
  int maxExpandedNodesLengthx = 0,
  Map expandedNodesx,
}) {
  Map expandedNodes = expandedNodesx ?? {};
  int maxExpandedNodesLength = maxExpandedNodesLengthx;
  int maxFrontierListLength = maxFrontierListLengthx;
  List<Node> frontierList = frontierListx ?? [];

  var expandedList = node.expand();
  expandedNodes[node.state] = node;
  maxExpandedNodesLength = max(maxExpandedNodesLength, expandedNodes.length);

  var expandedUnexploredList = expandedList.where((node) {
    var alreadyExpandedNode = expandedNodes[node.state];
    if (alreadyExpandedNode != null) {
      if (alreadyExpandedNode.cost <= node.cost) return false;
    }

    var filter = frontierList.where((element) => element.state == node.state);
    if (filter.isNotEmpty) {
      var alternativeNode = filter.first;

      if (alternativeNode.cost <= node.cost)
        return false;
      else if (alternativeNode.cost > node.cost) {
        frontierList.remove(alreadyExpandedNode);
      }
    }
    return true;
  }).toList();

  frontierList.addAll(expandedUnexploredList);
  maxFrontierListLength = max(maxFrontierListLength, frontierList.length);

  var nextNode = _getNextNode(frontierList);
  frontierList.remove(nextNode);

  return _NextSearchDetails(
    node: nextNode,
    frontierListx: frontierList,
    maxFrontierListLengthx: maxFrontierListLength,
    maxExpandedNodesLengthx: maxExpandedNodesLength,
    expandedNodesx: expandedNodes,
  );
}

Node _getNextNode(List<Node> frontierList) {
  List<Node> a = frontierList;
  a.sort((a, b) {
    int aHeuristicValue = a.game.getManhattanDistance() + a.cost;
    int bHeuristicValue = b.game.getManhattanDistance() + b.cost;
    return aHeuristicValue.compareTo(bHeuristicValue);
  });
  Node bestNode = a.first;
  return bestNode;
}

void solve({
  Node node,
  Function(Node node) onNextNode,
  Function(Node node, int steps) onFinalNode,
}) {
  Node nextNode = node;
  Map expandedNodes = {};
  int maxExpandedNodesLength = 0;
  int maxFrontierListLength = 0;
  List<Node> frontierList = [];
  int step = 0;
  while (!nextNode.game.isFinished()) {
    _NextSearchDetails nextSearchDetails = _search(
      node: nextNode,
      expandedNodesx: expandedNodes,
      maxExpandedNodesLengthx: maxExpandedNodesLength,
      maxFrontierListLengthx: maxFrontierListLength,
      frontierListx: frontierList,
    );
    nextNode = nextSearchDetails.node;
    expandedNodes = nextSearchDetails.expandedNodesx;
    maxExpandedNodesLength = nextSearchDetails.maxExpandedNodesLengthx;
    maxFrontierListLength = nextSearchDetails.maxFrontierListLengthx;
    frontierList = nextSearchDetails.frontierListx;
    onNextNode(nextNode);
    step++;
  }
  onFinalNode(nextNode, step);
}

class _NextSearchDetails {
  final Node node;
  final List<Node> frontierListx;
  final int maxFrontierListLengthx;
  final int maxExpandedNodesLengthx;
  final Map expandedNodesx;

  _NextSearchDetails({
    this.node,
    this.frontierListx,
    this.expandedNodesx,
    this.maxExpandedNodesLengthx = 0,
    this.maxFrontierListLengthx = 0,
  });
}
