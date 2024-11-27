import 'package:eashtonsfishies/main.dart';
import 'package:flutter/material.dart';


class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' aboout'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate back to first route when tapped.
            Navigator.of(context).pop(
              MaterialPageRoute(builder: (context) => HomeView())
            );
          },
          child: const Text('about us!'),
        ),
      ),
    );
  }
}
