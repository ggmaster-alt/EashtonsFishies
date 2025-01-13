import 'package:flutter/material.dart';
import 'package:eashtonsfishies/pop/cart_provider.dart';
import 'package:provider/provider.dart';
// Import the CartProvider

class Basket extends StatelessWidget {
  const Basket({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Basket'),

        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx, i) => CartItemWidget(
                id: cart.items.values.toList()[i].id,
                productId: cart.items.keys.toList()[i],
                name: cart.items.values.toList()[i].name,
                quantity: cart.items.values.toList()[i].quantity,
                price: cart.items.values.toList()[i].price,
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Total: \$${cart.totalAmount.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              // Handle checkout
              checkoutpopup(context, cart);
            },
            child: Text('Checkout'),
          ),
        ],
      ),
    );
  }

  Future<void> checkoutpopup(BuildContext context, CartProvider cart) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Checkout'),
        content: Text('Would you like to checkout?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('No'),
          ),
          TextButton(
            onPressed: () async {
              // Handle checkout
              
              cart.clear();
              Navigator.of(context).pop();
            },
            child: Text('Yes'),
          ),
        ],
      ),
    );
}

class CartItemWidget extends StatelessWidget {
  const CartItemWidget({
    required this.id,
    required this.productId,
    required this.name,
    required this.quantity,
    required this.price,
  });
  final String id;
  final String productId;
  final String name;
  final int quantity;
  final double price;


  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: ListTile(
          leading: CircleAvatar(
            child: Padding(
              padding: EdgeInsets.all(5),
              child: FittedBox(
                child: Text('\$$price'),
              ),
            ),
          ),
          title: Text(name),
          subtitle: Text('Total: \$${(price * quantity).toStringAsFixed(2)}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
/* 
is an error as when you press the button
it will not remove the item from the cart. 
just add more of the same item.
 */
                icon: Icon(Icons.remove),
                onPressed: () {
                  if (quantity == 1) {
                    cart.removeItem(productId);
                  } else {
                    cart.removeItem(productId);//Solution to the error: you need to create a new table for basket items
                  }
                },
              ),
              Text('$quantity x'),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  cart.addItem(productId, price, name);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
