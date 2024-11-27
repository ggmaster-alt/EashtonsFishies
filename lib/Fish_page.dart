import 'package:flutter/material.dart';
import 'package:eashtonsfishies/loginPage.dart';
class FishPageLogin extends StatelessWidget {
  final String title;
  const FishPageLogin(this.title);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context,
        MaterialPageRoute(builder:  (context) => const SecondRoute()),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        decoration: BoxDecoration(
            color: Colors.lightBlue.shade900,
            borderRadius: BorderRadius.circular(0)),
      )
    );
  }
}