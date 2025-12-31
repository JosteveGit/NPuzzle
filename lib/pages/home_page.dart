import 'package:eight_puzzle/core/manipulators/shuffler.dart';
import 'package:eight_puzzle/core/manipulators/solver.dart';
import 'package:eight_puzzle/utils/styles/color_utils.dart';
import 'package:eight_puzzle/utils/widgets/github.dart';
import 'package:eight_puzzle/utils/widgets/n_puzzle/n_puzzle.dart';
import 'package:eight_puzzle/utils/widgets/puzzle_image_selector.dart';
import 'package:eight_puzzle/utils/widgets/puzzle_size_option_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedImageIndex = 0;
  int selectedOptionIndex = 0;

  List<String> images = [
    "man",
    "woman",
    "music",
    "girl",
  ];

  GlobalKey<ScaffoldState> s = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
      ),
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isSmall = constraints.maxWidth < 850;
        return Scaffold(
          key: s,
          backgroundColor: Colors.black,
          drawer: Offstage(
            offstage: !isSmall,
            child: Drawer(
              child: Container(
                color: Colors.black,
                child: Container(
                  color: baseColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).padding.top + 20,
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Text(
                                "Select Image",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 10),
                              Expanded(
                                child: Container(
                                  height: double.maxFinite,
                                  child: PuzzleImageSelector(
                                    selectedImageIndex: selectedImageIndex,
                                    images: images,
                                    size: 120,
                                    onOptionTapped: (v) {
                                      setState(() {
                                        selectedImageIndex = v;
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GITHUB(),
                      SizedBox(
                        height: MediaQuery.of(context).padding.bottom + 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          body: SafeArea(
            child: Container(
              padding: EdgeInsets.all(isSmall ? 20 : 40),
              child: Row(
                children: [
                  Offstage(
                    offstage: isSmall,
                    child: Container(
                      width: 290,
                      margin: EdgeInsets.only(right: 20),
                      height: double.maxFinite,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: baseColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: PuzzleImageSelector(
                        selectedImageIndex: selectedImageIndex,
                        images: images,
                        onOptionTapped: (v) {
                          setState(() {
                            selectedImageIndex = v;
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Offstage(
                          offstage: !isSmall,
                          child: MouseRegion(
                            cursor: SystemMouseCursors.contextMenu,
                            child: GestureDetector(
                              onTap: () {
                                s.currentState?.openDrawer();
                              },
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.menu_rounded,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: NPuzzle(
                            image: images[selectedImageIndex],
                            dimensions: selectedOptionIndex + 2,
                          ),
                        ),
                        SizedBox(height: 40),
                        PuzzleSizeOptionSelector(
                          selectedOptionIndex: selectedOptionIndex,
                          onOptionTapped: (v) {
                            if (Solver.isSolving) {
                              Solver.stop();
                            }
                            if (Shuffler.isShuffling) {
                              Shuffler.stop();
                            }
                            setState(() {
                              selectedOptionIndex = v;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Offstage(
                    offstage: isSmall,
                    child: Container(
                      height: double.maxFinite,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: baseColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          GITHUB(),
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
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
