import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eashtonsfishies/tables/cart.dart'; //tables
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eashtonsfishies/invoices/invoice_page.dart';

// This class is now only responsible for database functions.
class InvoicePageDatabaseFunction {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String id;
  final String name;
  final String phonenumber;
  final String postcode;
  final String address;
  final String town;
  final double totalAmount;
  final Timestamp timestamp;
  final bool status;  
  
  InvoicePageDatabaseFunction({
    required this.id,
    required this.name,
    required this.phonenumber,
    required this.postcode,
    required this.address,
    required this.town,
    required this.totalAmount,
    required this.timestamp,
    required this.status,
  });
  factory InvoicePageDatabaseFunction.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return InvoicePageDatabaseFunction(
      id: doc.id,
      name: data['name'] ?? '',
      phonenumber: data['phonenumber'] ?? '',
      postcode: data['postcode'] ?? '',
      address: data['address'] ?? '',
      town: data['town'] ?? '',
      totalAmount: data['totalAmount']?.toDouble() ?? 0.0,
      timestamp: data['timestamp'] ?? Timestamp.now(),
      status: data['status'] ?? false,
    );
  }
  Future<List<InvoicePageDatabaseFunction>> fetchInvoices() async {
    final querySnapshot = await FirebaseFirestore.instance.collection('invoices').get();
    return querySnapshot.docs.map((doc) => InvoicePageDatabaseFunction.fromFirestore(doc)).toList();
  }
  Future<void> confirmInvoice({
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
      await invoiceRef.set({
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'name': name,
        'phonenumber': phonenumber,
        'postcode': postcode,
        'address': address,
        'town': town, // Now we use the passed town value
        'totalAmount': totalAmount,
        'timestamp': FieldValue.serverTimestamp(),
        'status': false,
      });
    } catch (e) {
      throw Exception('Failed to save invoice: $e');
    }
  }

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
        'status': false,
      });
    } catch (e) {
      throw Exception('Failed to save invoice: $e');
    }
  }

  
}