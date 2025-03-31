import 'dart:developer';

import 'package:eashtonsfishies/pop/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../../tables/product_information.dart';
import '../../pop/product_boxes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:badges/badges.dart' as badges;
//https://api.flutter.dev/flutter/widgets/Actions-class.html
//for flip boxes.

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  ProductListState createState() => ProductListState();
}

class ProductListState extends State<ProductList> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Flip App'),
        actions: [
          _shoppingCartCounter(),
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            log("i got here $snapshot");
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No products found'));
          } else {
            final products = snapshot.data!.where((product) => product.stock >= 0).toList();
            return GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 1.2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 1,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return FlipBox(
                  frontImage: product.image,
                  backText: product.name,
                  description: product.description,
                  name: product.name,
                  price: product.price,
                );
                
              },
            );
          }
        },
      ),
    );
  }
  Widget _shoppingCartCounter() {
    final cart = Provider.of<CartProvider>(context);
    return badges.Badge(
      position: badges.BadgePosition.topEnd(top: 0, end: 3),
      badgeContent: Text(cart.items.length.toString()),
      child: Icon(Icons.shopping_cart),
      onTap: () => Navigator.pushNamed(context, 'basket'),
    );
  }
}