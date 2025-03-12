import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eashtonsfishies/tables/cart.dart'; //tables
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eashtonsfishies/invoices/invoice_page.dart'; // pages

// point of this class is to add items in the invoice page to a invoice section.
class InvoicePageDatabaseFunction extends InvoicePage { 
  InvoicePageDatabaseFunction({super.key});
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController _postcodeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phonenumberController = TextEditingController();
   Future<void> saveInvoiceToFirebase({
    required List<CartItem> items,
    required double totalAmount,
  }) async {
    try {
      final invoiceRef = firestore.collection('invoices').doc();
      // Convert cart items to map format
      final itemsList = items.map((item) => {
        'id': item.id,
        'name': item.name,
        'quantity': item.quantity,
        'price': item.price,
      }).toList();

      await invoiceRef.set({
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'name': _nameController.text,
        'phonenumber': _phonenumberController.text,
        'postcode': _postcodeController.text,
        'address': _addressController.text,
        'town': townvalue,
        'items': itemsList,
        'totalAmount': totalAmount,
        'timestamp': FieldValue.serverTimestamp(),
        // add address and payment details.r
        'status': 'pending',
      });
    } catch (e) {
      throw Exception('Failed to save invoice: $e');
    }
  }
}
