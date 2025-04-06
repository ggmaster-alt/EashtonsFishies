import 'package:eashtonsfishies/pop/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:eashtonsfishies/invoices/invoice_page_database_function.dart';
//list for where is our town drop down
const List<String> townList = <String>[
  'llantrisent',
  'cardiff',
  'barry',
  'penarth',
  'caerphilly',
  'newport',
  'swansea',
  'bridgend',
  'treorchy',
  'rhondda',
  'swansea',
];

class InvoicePage extends StatefulWidget {
  const InvoicePage({super.key});

  @override
  State<InvoicePage> createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  final TextEditingController _postcodeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phonenumberController = TextEditingController();
  dynamic newValue; // Initialize the selected town

  @override
  void dispose() {
    _postcodeController.dispose();
    _addressController.dispose();
    _nameController.dispose();
    _phonenumberController.dispose(); // Dispose the selected town
    super.dispose();
  }
  

  bool isValidUKPostcode(String postcode) {
    return RegExp(
      r'^([A-Z]{1,2}[0-9][A-Z0-9]? ?[0-9][A-Z]{2}|GIR ?0AA)$',
      caseSensitive: false,
    ).hasMatch(postcode);
  }
  bool isValidphone(String phonenumber) {
    return RegExp(
      r'^(?:\+44|0)7\d{9}$',
      caseSensitive: false,
    ).hasMatch(phonenumber);
  }
  bool isValidUKadress(String address) {
    return RegExp(
      r'^[0-9]+[[:blank:]][A-Za-z]+[[:blank:]][A-Za-z]+',
      caseSensitive: false,
    ).hasMatch(address);
  }

  Future _handleConfirm(CartProvider cart) async {
    try {
      final invoiceDb = InvoicePageDatabaseFunction(
        id: DateTime.now().toString(), 
        name: _nameController.text, // Pass the form data
        phonenumber: _phonenumberController.text,
        postcode: _postcodeController.text,
        address: _addressController.text,
        town: newValue, // Pass the selected town
        totalAmount: cart.totalAmount, // Pass the total amount
        status: false,// Pass cart items
      );
      await invoiceDb.confirmInvoice(
        id: DateTime.now().toString(), // Generate a unique ID
        name: _nameController.text, // Pass the form data
        phonenumber: _phonenumberController.text,
        postcode: _postcodeController.text,
        address: _addressController.text,
        town: newValue, // Pass the selected town
        totalAmount: cart.totalAmount, // Pass the total amount
        status: false,
        items: cart.items.values.toList(),// Pass cart items
      );
      // Optionally, clear the cart after a successful save:
      cart.clear();
      // Show a success message or navigate to a confirmation page
      Navigator.of(context).pop();
      // Display a success message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invoice saved successfully!')),
      );
    } catch (e) {
      // Handle errors (e.g., show an error message)
      print("Error saving to database: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving invoice: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final List<Widget> invoiceItems = [];

    // Check if the cart is empty
    if (cart.items.isEmpty) {
      // Handle the case where the cart is empty
    } else {
      // If the cart has items, proceed to build the InvoiceList widgets
      for (int i = 0; i < cart.items.length; i++) {
        invoiceItems.add(InvoiceList(
          id: cart.items.values.toList()[i].id,
          productId: cart.items.keys.toList()[i],
          name: cart.items.values.toList()[i].name,
          quantity: cart.items.values.toList()[i].quantity,
          price: cart.items.values.toList()[i].price,
        ));
      }
    }
    return Scaffold(
      backgroundColor: Colors.lightBlue.shade50,
      body: Center(
        child: SizedBox(
          height: 800,
          width: 800,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: invoiceItems,
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
                    Navigator.pushReplacementNamed(
                        context, "userPage"); //replace the current page
                  },
                  child: Text('Continue shopping'),
                ),
              ),
              SizedBox(
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            insetPadding: EdgeInsets.all(10),
                            title: Text('Checkout'),
                            content: SingleChildScrollView(
                              child: Column(
                                children: [
                                  TextField(
                                    controller: _nameController,
                                    decoration:
                                    InputDecoration(labelText: 'Name'),
                                  ),
                                  SizedBox(height: 10),
                                  TextField(
                                    controller: _phonenumberController,
                                    decoration: InputDecoration(
                                        labelText: 'Phone number', hintText: 'e.g. 07712345678 | +447712345678'),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(12),
                                    ],
                                    //inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^[0-9]{11}$')), // formating will block user from entering incorrect data at each point],
                                  ),
                                  SizedBox(height: 10),
                                  TextField(
                                    controller: _postcodeController,
                                    decoration:
                                    InputDecoration(labelText: 'Postcode', hintText: 'e.g. CF24 3AA'),
                                    inputFormatters: [LengthLimitingTextInputFormatter(8)]
                                  ),
                                  SizedBox(height: 10),
                                  TextField(
                                    controller: _addressController,
                                    decoration:
                                    InputDecoration(labelText: 'Address', hintText: 'e.g. 12 Street Name'),
                                  ),
                                  SizedBox(height: 10),
                                  DropdownButton<String>(
                                    icon: Icon(Icons.arrow_drop_down),
                                    iconSize: 24,
                                    elevation: 16,
                                    value: newValue,
                                    hint: Text('Select Town'),
                                    style: TextStyle(color: Colors.black),
                                    underline: Container(
                                      height: 2,
                                      color: Colors.deepPurpleAccent,
                                    ),
                                    isExpanded: true,
                                    onChanged: (String? changedValue) {
                                      setState(() {
                                        newValue = changedValue?.toString();
                                        print(newValue);
                                      });
                                    },
                                      items: townList
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                            return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value));
                                          }).toList()),
                                ],
                              ),
                            ),
                            actions: [
                              Row(
                                children: [
                                  TextButton(
                                    child: Text('Confirm'),
                                    onPressed: () {
                                      if (!isValidUKPostcode(_postcodeController.text)) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Invalid UK postcode')),
                                        );
                                        return;
                                      }
                                      if (!isValidphone(_phonenumberController.text)) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Invalid phone number')),
                                        );
                                        return;
                                      }
                                      /*if (!isValidUKadress(_addressController.text)) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Invalid address')),
                                        );
                                        return;
                                      }*/
                                      if (newValue == null) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Please select a town')),
                                        );
                                        return;
                                      }
                                      if (_nameController.text.isEmpty ||
                                          _phonenumberController.text.isEmpty ||
                                          _postcodeController.text.isEmpty ||
                                          _addressController.text.isEmpty) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Please fill in all fields')),
                                        );
                                        return;
                                      }
                                      if (cart.items.isEmpty) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Your cart is empty')),
                                        );
                                        return;
                                      }
                                      _handleConfirm(cart);
                                    },
                                  ),
                                  TextButton(
                                    child: Text("Close"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              )
                            ],
                          );
                        });
                  },
                  child: Text('Checkout'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InvoiceList extends StatelessWidget {
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
  Widget build(BuildContext context) {
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