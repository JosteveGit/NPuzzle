import 'dart:async';
import 'dart:math';
import 'package:eight_puzzle/core/game.dart';
import 'package:eight_puzzle/core/node.dart';
import 'package:eight_puzzle/core/search.dart';
import 'package:flutter/material.dart';

class PlaygroundPage2 extends StatefulWidget {
  @override
  _PlaygroundPage2State createState() => _PlaygroundPage2State();
}

class _PlaygroundPage2State extends State<PlaygroundPage2> {
  @override
  initState() {
    super.initState();
    initSolved();
  }

  List<String> stateList = [];
  List<int> solved = [];
  List<Offset> initialOffsets = [];

  void initSolved() {
    int columnIndex = 0;
    double rowIndex = 0;
    for (int i = 0; i < 9; i++) {
      initialOffsets.add(Offset(217.0 * columnIndex, rowIndex));
      if ((i + 1) % 3 == 0) {
        columnIndex = 0;
        rowIndex += 217;
      } else {
        columnIndex++;
      }
      if (i == 8) {
        stateList.add('0');
        continue;
      }
      stateList.add((i + 1).toString());
    }
    setState(() {});
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
              child: IgnorePointer(
                ignoring: !allowTapping,
                child: Container(
                  width: 217.0 * (stateList.length / 3),
                  height: 217.0 * (stateList.length / 3),
                  child: Stack(
                    children: List.generate(
                      stateList.length,
                      (index) {
                        if (stateList[index] == '0') {
                          return SizedBox();
                        }
                        return Tile(
                          tileOffset: initialOffsets[index],
                          number: stateList[index],
                          indexOfEmptySlot: stateList.indexOf('0'),
                          onTap: (isConnectedToEmtpySlot) async {
                            if (isConnectedToEmtpySlot) {
                              setState(() {
                                allowTapping = false;
                              });
                              await Future.delayed(Duration(milliseconds: 150));
                              setState(() {
                                int indexOfEmpty = stateList.indexOf('0');
                                print(indexOfEmpty);
                                print(initialOffsets);
                                Offset savedEmptyOffset =
                                    initialOffsets[indexOfEmpty];

                                initialOffsets[indexOfEmpty] =initialOffsets[index];
                                initialOffsets.removeAt(index);
                                initialOffsets.insert(index, savedEmptyOffset);

                                print(initialOffsets[indexOfEmpty]);

                                allowTapping = true;
                                stateList[indexOfEmpty] = stateList[index];
                                stateList[index] = '0';
                              });
                            }
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            RaisedButton(
              onPressed: () {
                scramble();
              },
              child: Text("Shuffle"),
            ),
            RaisedButton(
              onPressed: () {
                solve();
              },
              child: Text("Solve"),
            ),
          ],
        ),
      ),
    );
  }

  void scramble() {
    // shuffle(
    //   game: Game(stateList.join("")),
    //   onShuffle: (stateList) {
    //     setState(() {
    //       this.stateList = stateList.map((e) => e.toString()).toList();
    //     });
    //   },
    //   moves: 100,
    // );
  }

  void solve() {
    // search(
    //   node: Node(state: stateList.join("")),
    //   onNextNode: (node) {
    //     setState(() {
    //       stateList = node.state.split("");
    //     });
    //   },
    // );
  }

  bool allowTapping = true;
}

class Tile extends StatefulWidget {
  final String number;
  final Offset tileOffset;
  final int indexOfEmptySlot;
  final Function(bool isConnected) onTap;

  Tile({
    Key key,
    this.number,
    this.tileOffset,
    this.onTap,
    this.indexOfEmptySlot,
  }) : super(key: key);

  _TileState tileState = _TileState();

  @override
  _TileState createState() => tileState;
}

class _TileState extends State<Tile> {
  Offset offset;

  @override
  void initState() {
    // setOffset(widget.index);
    super.initState();
  }

  // void setOffset(int index) {
  //   setState(() {
  //     offset = Offset((index % 3) * 217.0, (index / 3).floor() * 217.0);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    offset = widget.tileOffset ?? Offset.zero;
    return AnimatedPositioned(
      left: offset.dx,
      top: offset.dy,
      duration: Duration(milliseconds: 150),
      child: GestureDetector(
        onTap: () {
          bool x = isConnetedToEmptySlot();
          if (x) {
            widget.onTap(x);
          }
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

  bool isConnetedToEmptySlot() {
    List connectedIndices = [
      widget.indexOfEmptySlot + 1,
      widget.indexOfEmptySlot - 1,
      widget.indexOfEmptySlot - 3,
      widget.indexOfEmptySlot + 3
    ];
    return true;
    // return connectedIndices.contains(widget.index);
  }
}

// String offsetToNumbers(List<Offset> offsets) {
//   String numbers = "";
//   solvedStateOffsets.forEach((element) {
//     int index = offsets.indexOf(element);
//     numbers += index == 8 ? "_" : (index + 1).toString();
//   });
//   return numbers;
// }

// List<Offset> numbersToOffset(String numbers) {
//   List<Offset> offsets = [];
//   for (int i = 0; i < numbers.length; i++) {
//     int indexInSolve = numbers[i] == '_' ? 8 : int.parse(numbers[i]);
//     offsets.add(solvedStateOffsets[indexInSolve]);
//   }
//   return offsets;
// }
