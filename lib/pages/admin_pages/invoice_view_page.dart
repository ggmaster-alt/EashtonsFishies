import 'package:eashtonsfishies/invoices/invoice_page_database_function.dart';
import 'package:eashtonsfishies/main.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eashtonsfishies/tables/cart.dart'; //tables
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eashtonsfishies/invoices/invoice_page.dart';

class InvoiceView extends StatelessWidget {
  const InvoiceView({super.key});
  Future<List<InvoicePageDatabaseFunction>> fetchInvoices() async {
    final querySnapshot = await FirebaseFirestore.instance.collection('invoices').get();
    return querySnapshot.docs.map((doc) => InvoicePageDatabaseFunction.fromFirestore(doc)).toList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue.shade50,
      appBar: AppBar(
        title: Text('Invoice View'),
        actions: [
        ],
      ),
      body: FutureBuilder<List<InvoicePageDatabaseFunction>>(
        future: fetchInvoices(),
        builder: (context, snapshot) {
          itemCounter() {
            return snapshot.data!.length;
          }
          itemBuilder(context, index) {
            final invoice = snapshot.data![index];
            return ListTile(
              title: Text(invoice.name),
              subtitle: Text(invoice.totalAmount.toString()),

              onTap: () {
              },
            );
          }
          return ListView.builder(
            itemBuilder: itemBuilder, 
            itemCount: itemCounter());

        },
      )
    );
  }
}