import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class PlaygroundPage extends StatefulWidget {
  @override
  _PlaygroundPageState createState() => _PlaygroundPageState();
}

class _PlaygroundPageState extends State<PlaygroundPage> {
  List<Offset> initialOffsets = [];
  List<Offset> solvedStateOffsets = [];
  Offset emptySlotOffset;

  @override
  initState() {
    super.initState();
    initOffsets();
  }

  void initOffsets() {
    int columnIndex = 0;
    double rowIndex = 0;
    setState(() {
      for (int i = 0; i < 9; i++) {
        initialOffsets.add(Offset(217.0 * columnIndex, rowIndex));
        if ((i + 1) % 3 == 0) {
          columnIndex = 0;
          rowIndex += 217;
        } else {
          columnIndex++;
        }
      }
      solvedStateOffsets = List.generate(
          initialOffsets.length, (index) => initialOffsets[index]);
      emptySlotOffset = initialOffsets.last;
    });
  }

  int previousMoveIndex;

  void solve() async {
    List<Offset> connectedTiles = getConnectedTilesOffsets();
    List<Offset> clonedOffsets =
        List.generate(initialOffsets.length, (index) => initialOffsets[index]);
    Offset clonedEmptySlotOffset = emptySlotOffset;

    List<OffsetsAndHeuristicValue> o = [];

    connectedTiles.forEach((connectedTileOffset) {
      //Swap.
      Offset tempEmptySlotOffset = clonedEmptySlotOffset;
      clonedEmptySlotOffset = connectedTileOffset;
      int index = clonedOffsets.indexOf(connectedTileOffset);
      clonedOffsets.removeAt(index);
      clonedOffsets.insert(index, tempEmptySlotOffset);

      //Calculate Heursitic Value.
      if (previousMoveIndex != null) {
        if (index != previousMoveIndex) {
          o.add(heuristicFunction(clonedOffsets: clonedOffsets)
            ..indexMoved = index);
        }
      } else {
        o.add(heuristicFunction(clonedOffsets: clonedOffsets)
          ..indexMoved = index);
      }

      //Set back.
      clonedOffsets = List.generate(
          initialOffsets.length, (index) => initialOffsets[index]);
      clonedEmptySlotOffset = emptySlotOffset;
    });

    o.sort((a, b) {
      return a.heuristicValue.compareTo(b.heuristicValue);
    });

    OffsetsAndHeuristicValue bestFit = o.first;
    Offset tileToMoveOffset = initialOffsets[bestFit.indexMoved];
    previousMoveIndex = bestFit.indexMoved;

    setState(() {
      Offset tempEmptySlotOffset = emptySlotOffset;
      emptySlotOffset = tileToMoveOffset;
      initialOffsets.removeAt(bestFit.indexMoved);
      initialOffsets.insert(bestFit.indexMoved, tempEmptySlotOffset);
    });

    await Future.delayed(Duration(milliseconds: 200));

    if (bestFit.heuristicValue != 0) {
      solve();
    }
  }

  OffsetsAndHeuristicValue heuristicFunction({List<Offset> clonedOffsets}) {
    // int heuristicValue = 0;
    // for (int i = 0; i < clonedOffsets.length; i++) {
    //   if (clonedOffsets[i] != solvedStateOffsets[i]) {
    //     heuristicValue++;
    //   }
    // }

    int manhattanValue = 0;
    for (var i = 0; i < clonedOffsets.length; i++) {
      var clonedRowValue = (i / 3).floor();
      var clonedColumnValue = i % 3;

      int solvedStateIndex = solvedStateOffsets.indexOf(clonedOffsets[i]);
      var solvedStateRowValue = (solvedStateIndex / 3).floor();
      var solvedStateColumnValue = solvedStateIndex % 3;

      var rowDifference = (clonedRowValue - solvedStateRowValue).abs();
      var columnDifference = (clonedColumnValue - solvedStateColumnValue).abs();

      manhattanValue += (rowDifference + columnDifference);
    }

    return OffsetsAndHeuristicValue(clonedOffsets, manhattanValue);
  }

  void shuffle() {
    // int move = Random().nextInt(10 + 5);
    int count = 0;

    Timer.periodic(Duration(milliseconds: 200), (timer) {
      if (count == 10) {
        timer.cancel();
      }
      List<Offset> connectedTiles = getConnectedTilesOffsets();
      Offset tileToMoveOffset =
          connectedTiles[Random().nextInt(connectedTiles.length)];
      //swap;
      int index = initialOffsets.indexOf(tileToMoveOffset);
      setState(() {
        Offset tempEmptySlotOffset = emptySlotOffset;
        emptySlotOffset = tileToMoveOffset;
        initialOffsets.removeAt(index);
        initialOffsets.insert(index, tempEmptySlotOffset);
      });
      count++;
    });
  }

  List<Offset> getConnectedTilesOffsets() {
    Offset tile1 = Offset(emptySlotOffset.dx - 217.0, emptySlotOffset.dy);
    Offset tile2 = Offset(emptySlotOffset.dx + 217.0, emptySlotOffset.dy);
    Offset tile3 = Offset(emptySlotOffset.dx, emptySlotOffset.dy - 217.0);
    Offset tile4 = Offset(emptySlotOffset.dx, emptySlotOffset.dy + 217.0);
    List<Offset> connectedTilesOffsets = [];
    void addIfExists(Offset tile) {
      if (initialOffsets.contains(tile)) {
        connectedTilesOffsets.add(tile);
      }
    }

    addIfExists(tile1);
    addIfExists(tile2);
    addIfExists(tile3);
    addIfExists(tile4);
    return connectedTilesOffsets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: Colors.blueAccent, width: 5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                width: 217 * (initialOffsets.length / 3),
                height: 217 * (initialOffsets.length / 3),
                child: Stack(
                  children: List.generate(
                    initialOffsets.length - 1,
                    (index) {
                      int position = index + 1;
                      return Tile(
                        initialOffset: initialOffsets[index],
                        number: position.toString(),
                        emptySlotOffset: emptySlotOffset,
                        onTap: (newEmptyOffset, newTileOffset) {
                          setState(() {
                            emptySlotOffset = newEmptyOffset;
                            initialOffsets.removeAt(index);
                            initialOffsets.insert(index, newTileOffset);
                          });
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
            RaisedButton(
              child: Text("Shuffle"),
              onPressed: () {
                shuffle();
              },
            ),
            RaisedButton(
              child: Text("Solve"),
              onPressed: () {
                solve();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Tile extends StatefulWidget {
  final String number;
  final Offset initialOffset;
  final Offset emptySlotOffset;
  final Function(Offset newEmptySlotOffset, Offset newTileOffset) onTap;

  const Tile(
      {Key key,
      this.number,
      this.initialOffset,
      this.emptySlotOffset,
      this.onTap})
      : super(key: key);

  @override
  _TileState createState() => _TileState();
}

class _TileState extends State<Tile> {
  Offset tileOffset;

  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    tileOffset = widget.initialOffset ?? Offset.zero;

    return AnimatedPositioned(
      left: tileOffset.dx,
      top: tileOffset.dy,
      duration: Duration(milliseconds: 150),
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Container(
          width: 217,
          height: 217,
          decoration: BoxDecoration(
            color: Colors.pink,
            border: Border.all(color: Colors.blueAccent, width: 0.1),
          ),
          child: Center(
            child: Text(
              "${widget.number}",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onTap() {
    if (isConnectedToEmptySlot()) {
      Offset tempEmptyOffset = widget.emptySlotOffset;
      widget.onTap(tileOffset, tempEmptyOffset);
      setState(() {
        tileOffset = tempEmptyOffset;
      });
    }
  }

  bool isConnectedToEmptySlot() {
    Offset emptySlotOffset = widget.emptySlotOffset;
    // X, Y + 217
    // X, Y - 217
    // X + 217, Y
    // X - 217, Y
    Offset case1 = Offset(tileOffset.dx, tileOffset.dy + 217);
    Offset case2 = Offset(tileOffset.dx, tileOffset.dy - 217);
    Offset case3 = Offset(tileOffset.dx + 217, tileOffset.dy);
    Offset case4 = Offset(tileOffset.dx - 217, tileOffset.dy);
    bool condition = (case1 == emptySlotOffset ||
        case2 == emptySlotOffset ||
        case3 == emptySlotOffset ||
        case4 == emptySlotOffset);

    return condition;
  }
}

class OffsetsAndHeuristicValue {
  final List<Offset> offset;
  final int heuristicValue;
  int indexMoved;

  OffsetsAndHeuristicValue(this.offset, this.heuristicValue);
}

class ListWrapper<T> {
  final List<T> list;

  ListWrapper(this.list);
}
