import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class GITHUB extends StatelessWidget {
  const GITHUB({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        String url = "https://github.com/JosteveGit/NPuzzle.git";
        if (await canLaunch(url)) {
          launch(url);
        }
      },
      child: MouseRegion(
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
      ),
    );
  }
}
