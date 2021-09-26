import 'dart:math';

import 'package:flutter/material.dart';

class Mirror extends StatelessWidget {
  final String imagePath;
  final int dimensions;

  const Mirror({Key key, this.imagePath, this.dimensions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.white,
        width: 217 * (pow(dimensions, 2) / dimensions),
        height: 217 * (pow(dimensions, 2) / dimensions),
        child: Image.asset(
          "assets/$imagePath.jpg",
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
