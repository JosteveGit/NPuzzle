import 'dart:async';
import 'dart:math';

import 'package:eight_puzzle/core/manipulators/shuffler.dart';
import 'package:eight_puzzle/core/manipulators/solver.dart';
import 'package:eight_puzzle/core/models/node.dart';
import 'package:eight_puzzle/utils/functions/tile_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'game_mirror.dart';
import 'tile.dart';

class NPuzzle extends StatefulWidget {
  final String image;
  final int dimensions;

  const NPuzzle({
    Key? key,
    required this.image,
    required this.dimensions,
  }) : super(key: key);
  @override
  _NPuzzleState createState() => _NPuzzleState();
}

class _NPuzzleState extends State<NPuzzle> {
  @override
  void initState() {
    super.initState();
    initBoardAndState();
  }

  String image = "";
  int dimensions = 0;
  List<int> state = [];
  List<TileImage> tileImages = [];

  bool justLoading = true;

  void initBoardAndState() {
    justLoading = true;
    dimensions = widget.dimensions;
    image = widget.image;
    state = List.generate(dimensions * dimensions, (index) {
      int number = index + 1;
      if (number == dimensions * dimensions) {
        return 0;
      }
      return number;
    });
    tileImages.clear();
    TileUtils.getTileImages(
      imagePath: widget.image,
      dimensions: dimensions,
      state: state,
    ).then((value) {
      setState(() {
        tileImages = value;
      });
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (dimensions != widget.dimensions || image != widget.image) {
      initBoardAndState();
    }
    return Column(
      children: [
        Expanded(
          child: Container(
            width: 700,
            height: 700,
            child: FittedBox(
              child: Stack(
                children: [
                  Transform.translate(
                    offset: Offset(18, 18),
                    child: Opacity(
                      opacity: 0.2,
                      child: Center(
                        child: Opacity(
                          opacity: 1,
                          child: Mirror(
                            imagePath: image,
                            dimensions: dimensions,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Builder(
                    builder: (context) {
                      return Center(
                        child: Container(
                          height: 217 * (state.length / dimensions),
                          width: 217 * (state.length / dimensions),
                          child: Stack(
                            children: List.generate(
                              state.length,
                              (index) {
                                TileImage? tileImage;
                                int tileImageIndex = tileImages.indexWhere(
                                  (tileImage) => tileImage.number == index + 1,
                                );
                                if (tileImageIndex != -1) {
                                  tileImage = tileImages[tileImageIndex];
                                }
                                return Tile(
                                  numberTag: index + 1,
                                  indexOfNumberTag: state.indexOf(index + 1),
                                  indexOfEmpty: state.indexOf(0),
                                  dimensions: dimensions,
                                  tileImage: tileImage,
                                  onTap: (indexOfNumberTag, indexOfEmpty) {
                                    setState(() {
                                      int temp = state[indexOfNumberTag];
                                      state[indexOfNumberTag] =
                                          state[indexOfEmpty];
                                      state[indexOfEmpty] = temp;
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                          margin: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        Wrap(
          children: [
            Container(
              margin: EdgeInsets.only(right: 10),
              child: OutlinedButton(
                onPressed: () {
                  shuffleState();
                },
                child: Text(
                  "Shuffle",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  backgroundColor: Colors.blue,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                solveState();
              },
              child: Text(
                "Solve",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.blue,
                ),
              ),
              style: ButtonStyle(
                padding: WidgetStateProperty.all(
                  EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  void shuffleState() {
    Shuffler.shuffle(
      state: state,
      onShuffle: (nextState) {
        if (Shuffler.shouldNotShuffle) {
          Shuffler.reset();
          return false;
        }
        setState(() {
          state = nextState;
        });
        return true;
      },
      moves: 5 + Random().nextInt(50),
    );
  }

  void solveState() async {
    Node bestNode = await compute(
      Solver.solve,
      Node(stateList: state),
    );
    List<List<int>> states = [];
    Solver.isSolving = true;
    while (bestNode.parent != null) {
      if (Solver.shouldNotSolve) {
        Solver.reset();
        return;
      }
      states.add(bestNode.stateList);
      bestNode = bestNode.parent!;
    }
    for (int i = states.length - 1; i >= 0; i--) {
      if (Solver.shouldNotSolve) {
        Solver.reset();
        break;
      }
      setState(() {
        state = states[i];
      });
      await Future.delayed(Duration(milliseconds: 200));
    }
    Solver.isSolving = false;
  }
}
