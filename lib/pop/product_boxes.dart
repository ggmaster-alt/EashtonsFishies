import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:eashtonsfishies/pop/cart_provider.dart';
import 'package:provider/provider.dart';

class FlipBox extends StatelessWidget {
  final String description;
  final String name;
  final double price;
  final String frontImage;//this will cause error
  final String backText;//this will cause error

  const FlipBox({
    super.key,
    required this.description,
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
            image: NetworkImage(frontImage),//this will cause error
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
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
            ),
            SizedBox(
              height: 10
            ),
            Consumer<CartProvider>(
              builder: (context, cart, child) => Text(
                'In Cart: ${cart.items[description]?.quantity ?? 0}',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: () { // Add to cart
                Provider.of<CartProvider>(context, listen: false).addItem(description, price, name);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$name added to cart'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }, child: const Text('Add Item'),
            ),
            SizedBox(
              height: 10
            ),
            ElevatedButton(
              onPressed: (){
                Provider.of<CartProvider>(context, listen: false).removeSingleItem(description);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('One $name removed from cart'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }, child: const Text('Remove Item'),
            ),
          ],
        ),
      )
    );
  }
}