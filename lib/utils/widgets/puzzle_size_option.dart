import 'dart:math';

import 'package:eight_puzzle/utils/styles/color_utils.dart';
import 'package:flutter/material.dart';

class PuzzleSizeOption extends StatelessWidget {
  final bool isSelected;
  final int dimension;
  final EdgeInsets margin;
  const PuzzleSizeOption({
    Key key,
    this.dimension,
    this.isSelected = false,
    this.margin,
  }) : super(key: key);

  //You are generating dimension - 1 number of vertical lines.
  //You are generating dimension - 1 number of horizontal lines.

  @override
  Widget build(BuildContext context) {
    var numberOfTiles = pow(dimension, 2);
    return AnimatedContainer(
      margin: margin,
      duration: Duration(milliseconds: 500),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isSelected? baseColor : Colors.transparent,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            child: FittedBox(
              child: Container(
                height: 25 * (numberOfTiles / dimension),
                width: 25 * (numberOfTiles / dimension),
                child: Stack(
                  children: List.generate(
                    numberOfTiles,
                    (index) {
                      if (index == numberOfTiles - 1) {
                        return SizedBox();
                      }
                      Offset tileOffset = Offset(
                        (index % dimension) * 25.0,
                        (index / dimension).floor() * 25.0,
                      );

                      return Positioned(
                        left: tileOffset.dx,
                        top: tileOffset.dy,
                        child: Container(
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            border: Border.all(color: Colors.black, width: 0.1),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            "${numberOfTiles - 1} puzzle",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
