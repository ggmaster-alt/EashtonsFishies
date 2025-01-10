import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';

class FlipBox extends StatelessWidget {
  final String frontImage;
  final String backText;

  const FlipBox({super.key, required this.frontImage, required this.backText});

  @override
  Widget build(BuildContext context) {
    return FlipCard(
      direction: FlipDirection.HORIZONTAL, // Can be FlipDirection.VERTICAL
      front: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(frontImage),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      back: Container(
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          children: <Widget>[ 
            Text(backText, style: TextStyle(color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Add to cart
            },
            child: const Text('Add to Cart'),)
          ],
        ),
      )
    );
  }
}