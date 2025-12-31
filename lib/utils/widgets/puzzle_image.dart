import 'package:eight_puzzle/utils/styles/color_utils.dart';
import 'package:flutter/material.dart';

class PuzzleImage extends StatelessWidget {
  final bool isSelected;
  final String imagePath;
  final double? size;
  const PuzzleImage({
    Key? key,
    this.isSelected = false,
    required this.imagePath,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        width: size ?? 217,
        height: size ?? 217,
        margin: EdgeInsets.only(bottom: 20),
        duration: Duration(milliseconds: 500),
        padding: EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blueAccent.withOpacity(0.7) : baseColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              "assets/$imagePath.jpg",
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
