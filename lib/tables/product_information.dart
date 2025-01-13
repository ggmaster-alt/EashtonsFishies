
class Product {
  final String id;
  final String name;
  final String image;
  final double price;

  Product({required this.id, required this.name, required this.image, required this.price});

  // You can add more properties and methods as needed
}

// A list of products that can be purchased
final List<Product> products = [
      Product(id: '1', name: 'Fish 1', image: 'assets/images/ashtonslogosml.png', price: 10.0),
      Product(id: '2', name: 'Fish 2', image: 'assets/images/ashtonslogosml.png', price: 20.0),
      Product(id: '3', name: 'Fish 3', image: 'assets/images/ashtonslogosml.png', price: 30.0),
    ];