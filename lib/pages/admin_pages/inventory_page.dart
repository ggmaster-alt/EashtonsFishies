import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InventoryPage extends StatefulWidget {
  InventoryPage({super.key});

  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  void _showAddProductDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Checkout'),
        content: Text('add product?'),
        actions: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: 'name',
            ),
          ),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(
              hintText: 'description',
            ),
          ),
          TextField(
            controller: _priceController,
            decoration: InputDecoration(
              hintText: 'price',
            ),
          ),
          TextField(
            controller: _imageController,
            decoration: InputDecoration(
              hintText: 'image',
            ),
          ),
          //put image from disk here...
          //
          //
          //
          //
          //
          //
          ElevatedButton(
            onPressed: () async {
              await addProduct(context, 
              _nameController.text, 
              _descriptionController.text, 
              double.parse(_priceController.text), 
              _imageController.text);
            },
            child: Text('Yes'),
          ),
          
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventory'),
        ),
        body: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Back'),
              ),
            ),
            Center(
              child: Text('Inventory Page'),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_priceController.text.isEmpty) {
                    return _showAddProductDialog(context);

                  } else if (_nameController.text.isEmpty) {
                    return _showAddProductDialog(context);

                  } else if (_descriptionController.text.isEmpty) {
                    return _showAddProductDialog(context);

                  } else if (_imageController.text.isEmpty) {
                  return _showAddProductDialog(context);
                  }
                },
                child: Text('Add Product'),
              ),
            ),
          ],
      ),
    );
  }
  
  Future<void> addProduct(BuildContext context, String name, String description, double price, image) async {
    final productsDoc = FirebaseFirestore.instance.collection('products').doc(name);
      productsDoc.set({
      'name': name,
      'description': description,
      'price': price,
      'image': image,
    });// permissions error fix soon...
  }
}