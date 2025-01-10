import 'package:flutter/material.dart';
import 'package:eashtonsfishies/pages/main.dart';

class FishStock extends StatelessWidget {
  const FishStock({super.key});
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fish Stock'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(
              MaterialPageRoute(builder: (context) => HomeView())
            );
            // Navigate back to first route when tapped.
          },
          child: const Text('Fish Page'),
        ),
      ),
    );
  }
}
