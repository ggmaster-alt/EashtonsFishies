import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<Map<String, dynamic>>> fetchUsers() async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').get(); // tells the path of the data in firestore.
  return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList(); // maps user data as directory or relational table
}


class UserListPage extends StatefulWidget {
  const UserListPage({super.key});
  @override
  UserListPageState createState() => UserListPageState();
}

class UserListPageState extends State<UserListPage> {
  Future<List<Map<String, dynamic>>> fetchUsers() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').get();
    return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
        actions: [
          SizedBox(
            width: double.minPositive,
            height: 100,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Back'),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No users found'));
          } else {
            List<Map<String, dynamic>> users = snapshot.data!;
            return ListView.builder(// is a builder so will display a listview layout for user information
              itemCount: users.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> user = users[index];
                return ListTile(
                  title: Text(user['email'] ?? 'No email'), // If user['email'] is null, 'No email' is displayed
                  subtitle: Text(user['isAdmin'] ? 'Admin' : 'User'),// If user['isAdmin'] is true, 'Admin' is displayed, otherwise 'User'
                );
              },
            );
          }
        },
      ),
    );
  }
}