import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomProfileScreen extends StatefulWidget {
  const CustomProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<CustomProfileScreen> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  User? user;

  @override 
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  Future<void> changePassword(String currentPassword, String newPassword) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      try {
        await user.reauthenticateWithCredential(credential);
        await user.updatePassword(newPassword);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Password changed successfully')),
          );
        } else {
          return;
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.toString()}')),
          );
        } else {
          return;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
  
    return AlertDialog(
      title: Text('Change Password'),
      content: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _currentPasswordController,
              decoration: InputDecoration(labelText: 'Current Password'),
              obscureText: true,
            ),
            TextField(
              controller: _newPasswordController,
              decoration: InputDecoration(labelText: 'New Password'),
              obscureText: true,
            ),
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(labelText: 'Confirm New Password'),
              obscureText: true,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_newPasswordController.text == _confirmPasswordController.text) {
                  changePassword(_currentPasswordController.text, _newPasswordController.text);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('New passwords do not match')),
                  );
                }
              },
              child: Text('Change Password'),
            ),
          ],
        ),
      ),
    );
  }
}

Future<List<Map<String, dynamic>>> fetchUserInvoices() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return [];
    
    final querySnapshot = await FirebaseFirestore.instance
        .collection('invoices')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .get();
        
    return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  void showInvoicesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('My Orders'),
          content: Container(
            width: double.maxFinite,
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchUserInvoices(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No orders found');
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final invoice = snapshot.data![index];
                    return ListTile(
                      title: Text('Order #${index + 1}'),
                      subtitle: Text(
                        'Total: £${invoice['totalAmount']}\n'
                        'Date: ${invoice['timestamp']?.toDate().toString() ?? 'N/A'}\n'
                        'Status: ${invoice['status']}'
                      ),
                    );
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }