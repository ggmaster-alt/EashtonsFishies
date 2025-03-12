
import 'package:eashtonsfishies/pages/user_pages/logged_in_page.dart';
import 'package:eashtonsfishies/pop/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eashtonsfishies/invoices/invoice_page_database_function.dart';
import 'package:flutter/services.dart';

//list for where is our town drop down
const List<String> list = <String>[ 
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

class InvoicePage extends StatelessWidget{
  InvoicePage({super.key});
  final TextEditingController _postcodeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final townvalue = TownDropdownButtonState().dropdownValue;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phonenumberController = TextEditingController();
  

  
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
                child: ListView.builder(
                  itemBuilder: (context, i) {
                    if (i>= cart.items.length){
                      return SizedBox.shrink();
                    } 
                    return InvoiceList(
                      id: cart.items.values.toList()[i].id,
                      productId: cart.items.keys.toList()[i],
                      name: cart.items.values.toList()[i].name,
                      quantity: cart.items.values.toList()[i].quantity,
                      price: cart.items.values.toList()[i].price,
                    );
                    //Add user information here, after done you need to save to database
                  },
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
                    showDialog(context: context, builder: (BuildContext context) {
                      return AlertDialog(
                        insetPadding: EdgeInsets.all(10),
                        title: Text('Checkout'),
                        content: Column(
                          children: [
                            TextField(
                              controller: _nameController,
                              decoration: InputDecoration(labelText: 'Name'),
                            ),
                            SizedBox(height: 10),
                            TextField(
                              controller: _phonenumberController,
                              decoration: InputDecoration(labelText: 'Phone number'),
                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^[0-9]{11}$')),// formating will block user from entering incorrect data at each point
                              ]
                            ),
                            SizedBox(height: 10),
                            TextField(
                              controller: _postcodeController,
                              decoration: InputDecoration(labelText: 'Postcode'),
                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^[A-Z]{1,2}[0-9]{1,2}[A-Z]? [0-9][A-Z]{2}$')),
                              ]
                            ),
                            SizedBox(height: 10),
                            TextField(
                              controller: _addressController,
                              decoration: InputDecoration(labelText: 'Address'),
                            ),
                            SizedBox(height: 10),
                            TownDropdownButton(),
                          ],
                        ),
                        actions: [
                          Row(
                            children: [
                              TextButton(
                                child: Text('Confirm'),
                                onPressed: () {
                                  InvoicePageDatabaseFunction();
                                  
                                  // Handle checkout
                                  //save to database
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
          )
        ),
      ),
    );
  }
  //add to database.
  /*
              UserInfo userInfo = UserInfo(
                  id: FirebaseAuth.instance.currentUser!.uid,
                  name: _nameController.text,
                  phonenumber: _phonenumberController.text,
                  address: _addressController.text,
                  town: townvalue,
                );
}*/
}
class TownDropdownButton extends StatefulWidget {
  const TownDropdownButton({super.key});

  // the dropdown selector widget 

  @override
  TownDropdownButtonState createState() => TownDropdownButtonState();
}

class TownDropdownButtonState extends State<TownDropdownButton> {
  String dropdownValue = list.first;
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      menuMaxHeight: 300,//this is the max height of the dropdown
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      isExpanded: true,
      iconSize: 24,
      elevation: 16,
      onChanged: (String? value) {
        setState(() {
          dropdownValue = value!;
          Navigator.of(context).pop();
        });
      },
      items: // needs to map the string items in the dropdown to a value(int) makes it easier to deal with in tables.
        list.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
        }).toList(),
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

