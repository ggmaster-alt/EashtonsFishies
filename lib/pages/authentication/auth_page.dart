import 'package:eashtonsfishies/pages/user_pages/logged_in_page.dart'; // Ensure this import is correct
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:eashtonsfishies/pages/admin_pages/admin_page.dart'; // Ensure this import is correct
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//builds a standard border.
typedef HeaderBuilder = Widget Function(
 BuildContext context,
 BoxConstraints constraints,
 double shrinkOffset,
);

//sign in screen. can add other widgets as well, see https://firebase.google.com/codelabs/firebase-auth-in-flutter-apps#4
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  // IMPORTANT NOTE
  // this is asynconous and 
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(), // A stack of snapshots of current variables, tells firebase if its a signin or sign out
      builder: (context, snapshot) { // look at docs; 'builder: ' is complex and very specific
        if (!snapshot.hasData) {
          return SignInScreen(//sign in screen firebase widget
            providers: [
              EmailAuthProvider(),
            ],
            headerBuilder: (context, constraints, shrinkOffset){
              return Padding(
                padding: const EdgeInsets.all(20),
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Image.asset('assets/images/ashtonslogosml.png')
                ),
              );
            },
            subtitleBuilder: (context, action) { // small message under header
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: action == AuthAction.signIn // clickable text if you want to change in/up
                  ? const Text('Welcome to E.Ashtons FISHMONGERS, please sign in!')
                  : const Text('Welcome to E.Ashtons FISHMONGERS, please sign up!'),
              );
            },
            footerBuilder: (context, action) { // goes at the bottom
              return const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text(
                  'By signing in, you agree to our terms and conditions.',
                  style: TextStyle(color: Colors.grey),
                ),
              );
            },
            sideBuilder: (context, shrinkOffset) { // builds to left
              return Padding(
                padding: const EdgeInsets.all(20),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.asset('assets/images/ashtonslogosml.png'),
                ),
              );
            },
          );
        } else { // this process will go through once deatils have been entered.
          return FutureBuilder<DocumentSnapshot>(
            future: _createOrUpdateUserDocument(snapshot.data!),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (userSnapshot.hasError) {
                return Text('Error: ${userSnapshot.error}');
              } else if (userSnapshot.hasData) {
                final userData = userSnapshot.data!.data() as Map<String, dynamic>;
                final isAdmin = userData['isAdmin'] ?? false;
                if (isAdmin == true) {
                  return AdminHomePage();
                } else {
                  return HomeLogScreen();
                }
              } else {
                return Text('No user data found');
              }
            },
          );
        }
      },
    );
  }
  // collects information that is processed in firebase authentication and sends user information in admin user page
  // TO NOTE: this is security problem,'isadmin'. REMOVE
  Future<DocumentSnapshot> _createOrUpdateUserDocument(User user) async {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);//creates a file path or follows one if it already exists.

    final docSnapshot = await userDoc.get();
    if (docSnapshot.exists) {
      return userDoc.get();
    } else {
      await userDoc.set({
      'uid': user.uid,
      'email': user.email,
      'isAdmin': false, // Set this based on your logic
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    return userDoc.get();
    }
  } 
}