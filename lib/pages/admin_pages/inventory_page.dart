import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eashtonsfishies/pop/image_uploader.dart';
import 'package:eashtonsfishies/tables/product_information.dart';
import 'package:eashtonsfishies/pop/price_text_field.dart';
import 'dart:html' as html;
class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  _InventoryPageState createState() => _InventoryPageState();
}
  

class _InventoryPageState extends State<InventoryPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String? imageUrl;
  
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }
  Future<html.File> getImageFromWeb() async {
    final input = html.InputElement(type: 'file')..accept = 'image/*';
    input.click();

    await input.onChange.firstWhere((_) => input.files!.length == 1);
    final file = input.files!.first;
    final downloadUrl = await uploadImageWeb(file);
    if (downloadUrl != null) {
      setState(() {
        imageUrl = downloadUrl;
      });
    }
    return file;
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
          PriceTextField(),
          FloatingActionButton(
            onPressed: getImageFromWeb, 
            child: Icon(Icons.add_a_photo)),
          //put image from disk here...
          //
          //
          //
          //
          //
          //
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
          
          child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_nameController.text.isEmpty) {
                _showErrorDialog(context, 'Forgot to enter name');
              } else if (_descriptionController.text.isEmpty) {
                _showErrorDialog(context, 'Forgot to enter description');
              } else if (_priceController.text.isEmpty) {
                _showErrorDialog(context, 'Forgot to enter price');
              } else if (imageUrl == null) {
                _showErrorDialog(context, 'Forgot to upload image');
              } else {
                final file = await getImageFromWeb();
                if (imageUrl != null) {
                  await addProduct(
                    context,
                    _nameController.text,
                    _descriptionController.text,
                    double.parse(_priceController.text),
                    imageUrl!
                  );
                  _nameController.clear();
                  _descriptionController.clear();
                  _priceController.clear();
                  setState(() {});
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Product Added'),
                        content: Text('Product added successfully!'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventory'), 
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, 'admin');//nav to home screen
          },
        ),
      ),
      body: Column(
        children: [
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
                } else if (imageUrl == null) {
                  return _showAddProductDialog(context);
                } 
              },
              child: Text('Add Product'),
            ),
          ),
          Expanded(
            child:  FutureBuilder<List<Product>>(
              future: fetchProducts(),
              builder: (context, AsyncSnapshot<List<Product>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: CircularProgressIndicator());
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('no products found'));
                } else {
                  final products = snapshot.data!;
                  return ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return ListTile(
                        title: Text(product.name),
                        subtitle: Text('£${product.price}'),
                        leading: Image.network(
                          product.image,
                          errorBuilder: (context, error, stackTrace){
                            return Icon(Icons.error);
                          },
                        ),
                        //produces error: 'package:flutter/src/painting/_network_image_io.dart': Failed assertion: line 25 pos 14: 'url != null': is not true.
                        trailing: IconButton(
                          icon: Icon(
                            Icons.delete_forever_rounded,
                            color: Colors.red,
                          ),
                          onPressed:() => 
                            FirebaseFirestore.instance.collection('products').doc(product.id).delete(),
                            
                        )
                      );
                    }
                  );
                }
              }
            ),
          )
        ],
      ),
    );
  }
}