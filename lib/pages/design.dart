import 'package:eight_puzzle/pages/empty.dart';
import 'package:eight_puzzle/utils/styles/color_utils.dart';
import 'package:eight_puzzle/utils/widgets/puzzle_image.dart';
import 'package:eight_puzzle/utils/widgets/puzzle_option.dart';
import 'package:flutter/material.dart';

class DesignPage extends StatefulWidget {
  @override
  _DesignPageState createState() => _DesignPageState();
}

class _DesignPageState extends State<DesignPage> {
  int selectedIndex = 0;
  int selectedOptionIndex = 0;

  List<String> images = ["man", "woman",  "music", "girl"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        padding: EdgeInsets.all(40),
        child: Row(
          children: [
            Container(
              height: double.maxFinite,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: baseColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(
                    images.length,
                    (index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        child: PuzzleImage(
                          isSelected: index == selectedIndex,
                          imagePath: images[index],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: NPuzzle(
                      image: images[selectedIndex],
                      dimensions: selectedOptionIndex + 2,
                    ),
                  ),
                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 20,
                        ),
                        child: Row(
                          children: List.generate(
                            3,
                            (index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedOptionIndex = index;
                                  });
                                },
                                child: PuzzleOption(
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
                ],
              ),
            ),
            Container(
              height: double.maxFinite,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: baseColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle
                    ),
                    child: Center(
                      child: Image.asset(
                        "assets/github.png",
                        width: 50,
                        fit: BoxFit.cover,
                      ),
                    )
                  ),
                  Spacer(),
                  Text(
                    "Built\nwith\nFlutter 💙",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
