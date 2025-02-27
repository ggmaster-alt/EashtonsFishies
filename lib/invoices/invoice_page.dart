
import 'package:eashtonsfishies/pages/user_pages/logged_in_page.dart';
import 'package:eashtonsfishies/pop/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InvoicePage extends StatelessWidget{
  const InvoicePage({super.key});
  @override
  Widget build(BuildContext context){
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      backgroundColor: Colors.lightBlue.shade50,
      body: Center(
        child: 
        SizedBox(
          height: 800,
          width: 800,
          child: Column(
            children: [
              Expanded(
                child: 
                  ListView.builder(
                    itemBuilder: (context, i) => InvoiceList(
                      id: cart.items.values.toList()[i].id,
                      productId: cart.items.keys.toList()[i],
                      name: cart.items.values.toList()[i].name,
                      quantity: cart.items.values.toList()[i].quantity,
                      price: cart.items.values.toList()[i].price,
                  ),
                ),
              ),
              SizedBox(
                child: Card(
                  child: Column(
                    children: [
                      Text(
                        'Total: \$${cart.totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                child: ElevatedButton(
                  onPressed: () {
                    // Handle checkout
                    MaterialPageRoute(builder: (context) => HomeLogScreen());
                  },
                  child: Text('Continue shopping'),
                ),
              ),
              SizedBox(
                child: ElevatedButton(
                  onPressed: () {
                    // Handle checkout
                  
                    MaterialPageRoute(builder: (context) => HomeLogScreen());

                  },
                  child: Text('Checkout'),
                ),
              ),
            ],
          )
        ),
      ),
    );
  }
}

class InvoiceList extends StatelessWidget{
  final String id;
  final String productId;
  final String name;
  final int quantity;
  final double price;

  const InvoiceList({
    required this.id,
    required this.productId,
    required this.name,
    required this.quantity,
    required this.price,
    super.key,
  });

  @override
  Widget build(BuildContext context){
    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: ListTile(
          title: Text(name),
          subtitle: Text('Total: \$${(price * quantity).toStringAsFixed(2)}'),
          trailing: Text('$quantity x'),
        ),
      ),
    );
  }
}

