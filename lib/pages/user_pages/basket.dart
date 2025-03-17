import 'dart:developer';

import 'package:eashtonsfishies/invoices/invoice_page.dart';
import 'package:flutter/material.dart';
import 'package:eashtonsfishies/pop/cart_provider.dart';
import 'package:provider/provider.dart';
//import 'package:get/get.dart';
// Import the CartProvider

class FishBasket extends StatefulWidget {
  const FishBasket({super.key});

  @override
  State<FishBasket> createState() => _BasketState();
}

class _BasketState extends State<FishBasket> {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    Future<bool?> checkoutPopUp(BuildContext context, CartProvider cart) =>
        showDialog<bool>( // Specify the return type <bool>
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Checkout'),
            content: const Text('Would you like to checkout?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // Return false (did not checkout)
                },
                child: const Text('No'),
              ),
              ElevatedButton(
                onPressed: () {
                  print('Checkout');
                  // Handle checkout here
                  // ... any checkout logic here
                  Navigator.of(context).pop(true); // Return true (checkout confirmed)
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        );

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
              itemBuilder: (context, i) {
                if (i>= cart.items.length){
                  return const SizedBox.shrink();
                }
                return CartItemWidget(
                  id: cart.items.values.toList()[i].id,
                  productId: cart.items.keys.toList()[i],
                  name: cart.items.values.toList()[i].name,
                  quantity: cart.items.values.toList()[i].quantity,
                  price: cart.items.values.toList()[i].price,
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Total: \$${cart.totalAmount.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              // Handle checkout
              if (context.mounted) {
                checkoutPopUp(context, cart).then((shouldCheckout) {
                  if (shouldCheckout == true && context.mounted) {
                    Navigator.pushNamed(context, 'invoices');
                    log("Navigated to invoices");
                  }
                });
              }
            },
            child: Text('Checkout'),
          ),
        ],
      ),
    );
  }
}

class CartItemWidget extends StatelessWidget {
  const CartItemWidget({
    required this.id,
    required this.productId,
    required this.name,
    required this.quantity,
    required this.price,
    super.key,
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
                icon: Icon(Icons.remove),
                onPressed: () {
                  if (quantity > 1) {
                    cart.removeSingleItem(productId);
                  } else {
                    cart.removeItem(productId);
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
