import 'package:flutter/material.dart';

class Basket extends StatelessWidget {
  const Basket({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Basket'),
      ),
      body: Center(
        child: Text('Basket Page'),
      ),
    );
  }
}