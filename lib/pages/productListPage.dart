import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import '../Product.dart';
import '../FlipBox.dart';
class ProductList extends StatelessWidget {
  final List<Product> products;

  const ProductList(Required required, {super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Flip App'),
        
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 1.5,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return FlipBox(
            frontImage: product.image,
            backText: product.name,
          );
        },
      ),
    );
  }
}