import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eashtonsfishies/tables/cart.dart'; //tables
import 'package:firebase_auth/firebase_auth.dart';

// This class is now only responsible for database functions.
class InvoicePageDatabaseFunction {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> saveInvoiceToFirebase({
    required List<CartItem> items,
    required double totalAmount,
    required String name,
    required String phonenumber,
    required String postcode,
    required String address,
    required String town,
  }) async {
    try {
      final invoiceRef = firestore.collection('invoices').doc();

      final itemsList = items.map((item) => {
        'id': item.id,
        'name': item.name,
        'quantity': item.quantity,
        'price': item.price,
      }).toList();

      await invoiceRef.set({
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'name': name,
        'phonenumber': phonenumber,
        'postcode': postcode,
        'address': address,
        'town': town, // Now we use the passed town value
        'items': itemsList,
        'totalAmount': totalAmount,
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'pending',
      });
    } catch (e) {
      throw Exception('Failed to save invoice: $e');
    }
  }
}