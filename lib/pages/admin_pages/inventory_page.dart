import 'package:flutter/material.dart';//main import
import 'package:cloud_firestore/cloud_firestore.dart';//cloud
import 'package:eashtonsfishies/tables/product_information.dart';//data tables
import 'package:eashtonsfishies/pop/image_uploader.dart';//
import 'package:flutter/services.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  InventoryPageState createState() => InventoryPageState();
}
  

class InventoryPageState extends State<InventoryPage> {
  //holds data for this widget
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? imageUrl;
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();

  Future<void> _showAddProductDialog(BuildContext context) async {
    showDialog(// builds new context on top of page
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Product'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'name',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    hintText: 'description',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _priceController,
                  decoration: InputDecoration(
                    hintText: 'price',
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]*')),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () async {//calls image drive function
                  final downloadUrl = await pickAndUploadImage();
                  if (downloadUrl != null) {
                    setState(() {
                      imageUrl = downloadUrl;
                    });
                  }
                },
                child: Icon(Icons.upload_file),
              ),
              if (imageUrl != null && imageUrl!.isNotEmpty) ...[
                SizedBox(height: 20),
                Image.network(imageUrl!),
              ] else ...[
                Text('No image selected'),
              ],
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async { //errors '' is the string sent
              if (_nameController.text.isEmpty) {
                _showErrorDialog(context, 'Forgot to enter name');
              } else if (_descriptionController.text.isEmpty) {
                _showErrorDialog(context, 'Forgot to enter description');
              } else if (_priceController.text.isEmpty) {
                _showErrorDialog(context, 'Forgot to enter price');
              } else if (imageUrl == null || imageUrl!.isEmpty) {
                _showErrorDialog(context, 'Forgot to upload image');
              } else {
                await addProduct(
                  context,
                  _nameController.text,
                  _descriptionController.text,
                  double.parse(_priceController.text),
                  imageUrl!,
                );
                _nameController.clear();
                _descriptionController.clear();
                _priceController.clear();
                imageUrl = null;
              }
              if (mounted) {
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
              }
            },
            child: Text('Add to Database'),
          ),
        ],
      ),
    );
  }
  
  //stops the user entering incorrect data
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
  //main build
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
          child: Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  _showAddProductDialog(context);
                },
                child: Text('Add Product'),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  AlertDialog(actions: [
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'name',
                      ),
                    ),
                    TextField(
                      controller: _stockController,
                      decoration: InputDecoration(
                        hintText: 'stock',
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        updateProductStockByName(_nameController.text, int.parse(_stockController.text));
                        Navigator.of(context).pop();
                      },
                      child: Text('OK'),
                    ),
                  ],);
                },
                child: Text('edit Stock'),
              )
            ],
          ),
        ),
          Expanded(
            child:  FutureBuilder<List<Product>>(
              future: fetchProducts(),
              builder: (context, AsyncSnapshot<List<Product>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {// checks snapshot and can respond to all errors on db side and well as network errors
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
  // is the function for editing stock on admin side.
  Future<void> updateProductStockByName(String name, int newStock) async {
  try {
    // Query for document with matching name
    final querySnapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('name', isEqualTo: name)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Update first matching document
      final docId = querySnapshot.docs.first.id;
      await FirebaseFirestore.instance
          .collection('products')
          .doc(docId)
          .update({'stock': newStock});
    } else {
      throw Exception('Product not found with name: $name');
    }
  } catch (e) {
    Text('Error updating stock: $e');
    rethrow;
  }
}
}