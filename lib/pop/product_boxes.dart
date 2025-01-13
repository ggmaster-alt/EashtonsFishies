import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:eashtonsfishies/pop/cart_provider.dart';
import 'package:provider/provider.dart';

class FlipBox extends StatelessWidget {
  final String id;
  final String name;
  final double price;
  final String frontImage;
  final String backText;

  const FlipBox({
    super.key,
    required this.id,
    required this.frontImage,
    required this.backText,
    required this.name,
    required this.price,
  });


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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[ 
            Text(backText, style: TextStyle(color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              // Add to cart
              Provider.of<CartProvider>(context, listen: false).addItem(id, price, name);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$name added to cart'),
                    duration: Duration(seconds: 2),
                  ),
                );
              
            },
            child: const Text('Add to Cart'),)
          ],
        ),
      )
    );
  }
}