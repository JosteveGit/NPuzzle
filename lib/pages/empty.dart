import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:eight_puzzle/core/node.dart';
import 'package:eight_puzzle/core/search.dart';
import 'package:eight_puzzle/core/shuffle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as image;

class NPuzzle extends StatefulWidget {
  final String image;
  final int dimensions;

  const NPuzzle({Key key, this.image, this.dimensions}) : super(key: key);
  @override
  _NPuzzleState createState() => _NPuzzleState();
}

class _NPuzzleState extends State<NPuzzle> {
  @override
  void initState() {
    super.initState();
    initBoardAndState();
  }

  int dimension = 0;

  void initBoardAndState() {
    dimension = widget.dimensions;
    image = widget.image;
    state = List.generate(dimension * dimension, (index) {
      int number = index + 1;
      if (number == dimension * dimension) {
        return 0;
      }
      return number;
    });
    tileImages.clear();
    setState(() {});
  }

  String image;

  List<int> state = [];
  List<TileImage> tileImages = [];

  @override
  Widget build(BuildContext context) {
    if (dimension != widget.dimensions || image != widget.image) {
      initBoardAndState();
    }
    int dimensions = sqrt(state.length).toInt();
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
                          child: Breakable(
                            imagePath: widget.image,
                            getImages: (images) {
                              setState(() {
                                tileImages = List.generate(
                                  state.length,
                                  (index) {
                                    int number = state[index];
                                    return TileImage(
                                      images[index],
                                      number,
                                    );
                                  },
                                );
                              });
                            },
                            dimensions: sqrt(state.length).toInt(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Builder(builder: (context) {
                    if (tileImages.length != state.length) {
                      // return Center(
                      //   child: Text(
                      //     "Fetching",
                      //     style: TextStyle(
                      //       color: Colors.white
                      //     ),
                      //   ),
                      // );
                    }
                    return Center(
                      child: Container(
                        height: 217 * (state.length / dimensions),
                        width: 217 * (state.length / dimensions),
                        child: Stack(
                          children: List.generate(
                            state.length,
                            (index) {
                              TileImage tileImage;
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
                  }),
                ],
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: () {
                shuffleState();
              },
              child: Text(
                "Shuffle",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              style: ButtonStyle(
                padding: MaterialStateProperty.all(
                  EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                ),
              ),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                solveState();
              },
              child: Text(
                "Solve",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              style: ButtonStyle(
                padding: MaterialStateProperty.all(
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
    shuffle(
      state: state,
      onShuffle: (nextState) {
        setState(() {
          state = nextState;
        });
      },
      moves: 50,
    );
  }

  void solveState() {
    solve(
      node: Node(stateList: state),
      onNextNode: (nextNode) {},
      onFinalNode: (finalNode, _) async {
        Node bestNode = finalNode;
        List<List<int>> states = [];
        while (bestNode.parent != null) {
          states.add(bestNode.stateList);
          bestNode = bestNode.parent;
        }
        for (int i = states.length - 1; i >= 0; i--) {
          setState(() {
            state = states[i];
          });
          await Future.delayed(Duration(milliseconds: 200));
        }
      },
    );
  }
}

class Tile extends StatefulWidget {
  final int numberTag;
  final int indexOfNumberTag;
  final Function(int indexOfNumberTag, int indexOfEmpty) onTap;
  final indexOfEmpty;
  final int dimensions;
  final TileImage tileImage;
  const Tile({
    Key key,
    this.numberTag,
    this.onTap,
    this.indexOfNumberTag,
    this.indexOfEmpty,
    this.dimensions = 3,
    this.tileImage,
  }) : super(key: key);

  @override
  _TileState createState() => _TileState();
}

class _TileState extends State<Tile> {
  Offset tileOffset = Offset.zero;
  int dimensions;

  @override
  void initState() {
    initOffsets();
    super.initState();
  }

  void initOffsets() {
    dimensions = widget.dimensions;
    int indexOfNumberTag = widget.indexOfNumberTag;
    tileOffset = Offset(
      (indexOfNumberTag % dimensions) * 217.0,
      (indexOfNumberTag / dimensions).floor() * 217.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    initOffsets();
    return AnimatedPositioned(
      left: tileOffset.dx,
      top: tileOffset.dy,
      duration: Duration(milliseconds: 150),
      child: GestureDetector(
        onTap: () {
          if (isConnectedToEmptySlot()) {
            int index = widget.indexOfEmpty;
            setState(() {
              tileOffset = Offset(
                (index % dimensions) * 217.0,
                (index / dimensions).floor() * 217.0,
              );
            });
            widget.onTap(widget.indexOfNumberTag, index);
          }
        },
        child: Container(
          width: 217,
          height: 217,
          color: Colors.transparent,
          child: Center(
            child: Stack(
              children: [
                // Text(
                //   widget.numberTag.toString(),
                //   style: TextStyle(
                //     color: Colors.white,
                //     fontSize: 50,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                if (widget.tileImage != null) widget.tileImage.image,
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool isConnectedToEmptySlot() {
    int index = widget.indexOfEmpty;
    Offset emptySlotOffset = Offset(
        (index % dimensions) * 217.0, (index / dimensions).floor() * 217.0);
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

class Breakable extends StatefulWidget {
  final Widget child;
  final Function(List<Image> images) getImages;
  final int dimensions;
  final String imagePath;

  const Breakable(
      {Key key,
      this.child,
      this.getImages,
      this.dimensions = 3,
      this.imagePath})
      : super(key: key);

  @override
  _BreakableState createState() => _BreakableState();
}

class _BreakableState extends State<Breakable> {
  GlobalKey _globalKey = GlobalKey();
  Size size;
  int dimensions = 0;
  String imagePath;

  List<Image> images = [];

  @override
  void initState() {
    super.initState();
    snap();
  }

  void snap() async {
    dimensions = widget.dimensions;
    imagePath = widget.imagePath;
    String key = "$imagePath#$dimensions";
    if (cache.containsKey(key)) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        widget.getImages(cache[key]);
      });
    } else {
      var data = await rootBundle.load('assets/${widget.imagePath}.jpg');
      var pngBytes = data.buffer.asUint8List();
      List<Image> images = splitImage(pngBytes, widget.dimensions);
      cache.putIfAbsent(key, () => images);
      widget.getImages(images);
      // Timer(Duration(milliseconds: 500), () async {
      //   // RenderRepaintBoundary boundary =
      //   //     _globalKey.currentContext.findRenderObject();
      //   // //cache image for later
      //   // size = boundary.size;
      //   //      // var img = await boundary.toImage();
      //   // var byteData = await img.toByteData(format: ImageByteFormat.png);
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (dimensions != widget.dimensions || imagePath != widget.imagePath) {
      snap();
    }
    return RepaintBoundary(
      key: _globalKey,
      child: Center(
        child: Container(
          color: Colors.white,
          width: 217 * (pow(widget.dimensions, 2) / widget.dimensions),
          height: 217 * (pow(widget.dimensions, 2) / widget.dimensions),
          child: Image.asset(
            "assets/${widget.imagePath}.jpg",
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  List<Image> splitImage(List<int> input, int dimensions) {
    // convert image to image from image package
    image.Image img = image.decodeImage(input);
    var now = DateTime.now();
    img = image.copyResizeCropSquare(img, 217 * (pow(dimensions, 2) ~/ dimensions));
    var newNow = DateTime.now();
    print(now);
    print(newNow);

    int x = 0, y = 0;
    int width = (img.width / dimensions).round();
    int height = (img.height / dimensions).round();

    // split image to parts
    List<image.Image> parts = [];
    for (int i = 0; i < dimensions; i++) {
      for (int j = 0; j < dimensions; j++) {
        parts.add(image.copyCrop(img, x, y, width, height));
        x += width;
      }
      x = 0;
      y += height;
    }

    // convert image from image package to Image Widget to display
    List<Image> output = [];
    for (var img in parts) {
      output.add(Image.memory(image.encodeJpg(img)));
    }

    return output;
  }
}

Map<String, List<Image>> cache = {};

class TileImage {
  final Image image;
  final int number;

  TileImage(this.image, this.number);
}
