import 'package:eight_puzzle/utils/styles/color_utils.dart';
import 'package:flutter/material.dart';

import 'puzzle_size_option.dart';

class PuzzleSizeOptionSelector extends StatelessWidget {
  final int selectedOptionIndex;
  final Function(int index) onOptionTapped;
  const PuzzleSizeOptionSelector({
    Key? key,
    required this.selectedOptionIndex,
    required this.onOptionTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 700,
      height: 200,
      child: FittedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 20,
              ),
              child: Row(
                children: List.generate(
                  4,
                  (index) {
                    return GestureDetector(
                      onTap: () {
                        onOptionTapped(index);
                      },
                      child: PuzzleSizeOption(
                        dimension: (index + 2),
                        isSelected: selectedOptionIndex == index,
                        margin: EdgeInsets.only(
                          right: index == 3 ? 0 : 10,
                        ),
                      ),
                    );
                  },
                ),
              ),
              decoration: BoxDecoration(
                color: baseColor,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
