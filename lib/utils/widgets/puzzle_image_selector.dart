import 'package:flutter/material.dart';

import 'puzzle_image.dart';

class PuzzleImageSelector extends StatelessWidget {
  final int selectedImageIndex;
  final List<String> images;
  final double size;
  final Function(int index) onOptionTapped;
  const PuzzleImageSelector(
      {Key key,
      this.selectedImageIndex,
      this.images,
      this.size,
      this.onOptionTapped})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Wrap(
          children: List.generate(
            images.length,
            (index) {
              return GestureDetector(
                onTap: () {
                  onOptionTapped(index);
                },
                child: Container(
                  margin: EdgeInsets.all(5),
                  child: PuzzleImage(
                    isSelected: index == selectedImageIndex,
                    imagePath: images[index],
                    size: size,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}