import 'package:eashtonsfishies/pages/authentication/auth_page.dart';
import 'package:flutter/material.dart';
class FishPageLogin extends StatelessWidget {
  final String title;
  const FishPageLogin(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context,
        MaterialPageRoute(builder:  (context) => AuthGate()),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
            color: Colors.lightBlue.shade900,
            borderRadius: BorderRadius.circular(0)),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      )
    );
  }
}