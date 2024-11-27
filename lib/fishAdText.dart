import 'package:flutter/material.dart';
class fishAdText extends StatelessWidget {
  const fishAdText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 600,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'E.Ashtons.\nFriends of the Sea',
            style: TextStyle(
                fontWeight: FontWeight.w800, fontSize: 80, height: 0.9),
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            'E.Ashtons fishmongers has stood in cardiff market for over 200 years, we provide quality fresh Fish, Seafood and Game for local businesses and individuals.',
            style: TextStyle(fontSize: 21, height: 1.7),
          ),
        ],
      ),
    );
  }
}
