import 'package:cloud_firestore/cloud_firestore.dart';


class Product {
  final String id;
  final String name;
  final String description;
  final String image;
  final double price;

  Product({
    required this.id,
    required this.name, 
    required this.description, 
    required this.image, 
    required this.price
  });

  // You can add more properties and methods as needed


// A list of products that can be purchased
  factory Product.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Product(
      id:doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      image: data['image'] ?? '',
      price: data['price']?.toDouble() ?? 0.0,
    );
  }
}

Future<List<Product>> fetchProducts() async {
  final querySnapshot = await FirebaseFirestore.instance.collection('products').get();
  return querySnapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
}

Future<void> addProduct(context, String name, String description, double price, String imageUrl) async {
    final productsDoc = FirebaseFirestore.instance.collection('products').doc(name);
      productsDoc.set({
      'name': name,
      'description': description,
      'price': price,
      'image': imageUrl,
    });
  }