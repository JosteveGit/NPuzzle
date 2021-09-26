import 'package:flutter/material.dart';

class TileImage {
  final Image image;
  final int number;

  TileImage(this.image, this.number);
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