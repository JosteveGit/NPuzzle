import 'package:flutter/material.dart';

class GITHUB extends StatelessWidget {
  const GITHUB({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Image.asset(
            "assets/github.png",
            width: 50,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
