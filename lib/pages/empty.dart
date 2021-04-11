import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:eight_puzzle/core/node.dart';
import 'package:eight_puzzle/core/search.dart';
import 'package:eight_puzzle/core/shuffle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as image;

class EmptyPage extends StatefulWidget {
  @override
  _EmptyPageState createState() => _EmptyPageState();
}

class _EmptyPageState extends State<EmptyPage> {
  List<int> state = [1, 2, 3, 4, 5, 6, 7, 8, 0];
  List<TileImage> tileImages = [];

  @override
  Widget build(BuildContext context) {
    int dimensions = sqrt(state.length).toInt();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Breakable(
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
                  print(tileImages);
                });
              },
              child: Center(
                child: Container(
                  color: Colors.white,
                  width: 651,
                  height: 651,
                  child: Image.asset(
                    "assets/woman.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Container(
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
                    if(tileImageIndex != -1){
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
                          state[indexOfNumberTag] = state[indexOfEmpty];
                          state[indexOfEmpty] = temp;
                        });
                      },
                    );
                  },
                ),
              ),
              margin: EdgeInsets.all(20),
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.orange)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaisedButton(
                  onPressed: () {
                    shuffleState();
                  },
                  child: Text("Shuffle"),
                ),
                SizedBox(width: 10),
                RaisedButton(
                  onPressed: () {
                    solveState();
                  },
                  child: Text("Solve"),
                ),
              ],
            )
          ],
        ),
      ),
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
          color: Colors.blueGrey,
          child: Center(
            child: Stack(
              children: [
                Text(
                  widget.numberTag.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),
               if(widget.tileImage != null) widget.tileImage.image,
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

  const Breakable({Key key, this.child, this.getImages}) : super(key: key);

  @override
  _BreakableState createState() => _BreakableState();
}

class _BreakableState extends State<Breakable> {
  GlobalKey _globalKey = GlobalKey();
  Size size;

  List<Image> images = [];

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 1), () async {
      RenderRepaintBoundary boundary =
          _globalKey.currentContext.findRenderObject();
      //cache image for later
      size = boundary.size;
      var img = await boundary.toImage();
      var byteData = await img.toByteData(format: ImageByteFormat.png);
      var pngBytes = byteData.buffer.asUint8List();
      widget.getImages(splitImage(pngBytes));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      height: 651,
      width: 651,
      child: RepaintBoundary(
        key: _globalKey,
        child: widget.child,
      ),
    );
  }

  List<Image> splitImage(List<int> input) {
    // convert image to image from image package
    image.Image img = image.decodeImage(input);

    int x = 0, y = 0;
    int width = (img.width / 3).round();
    int height = (img.height / 3).round();

    // split image to parts
    List<image.Image> parts = [];
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
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

class TileImage {
  final Image image;
  final int number;

  TileImage(this.image, this.number);
}
