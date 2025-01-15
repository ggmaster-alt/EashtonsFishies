import 'package:eashtonsfishies/pages/logged_in_page.dart'; // Ensure this import is correct
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:eashtonsfishies/pages/admin_page.dart'; // Ensure this import is correct
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//returning a widget
typedef HeaderBuilder = Widget Function(
 BuildContext context,
 BoxConstraints constraints,
 double shrinkOffset,
);

//sign in screen. can add other widgets as well, see https://firebase.google.com/codelabs/firebase-auth-in-flutter-apps#4
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
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
            subtitleBuilder: (context, action) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: action == AuthAction.signIn // clickable text if you want to change in/up
                  ? const Text('Welcome to E.Ashtons FISHMONGERS, please sign in!')
                  : const Text('Welcome to E.Ashtons FISHMONGERS, please sign up!'),
              );
            },
            footerBuilder: (context, action) {//need to comment on.
              return const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text(
                  'By signing in, you agree to our terms and conditions.',
                  style: TextStyle(color: Colors.grey),
                ),
              );
            },
            sideBuilder: (context, shrinkOffset) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.asset('assets/images/ashtonslogosml.png'),
                ),
              );
            },
          );
        } else {
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

  Future<DocumentSnapshot> _createOrUpdateUserDocument(User user) async {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);

    await userDoc.set({
      'uid': user.uid,
      'email': user.email,
      'isAdmin': user.email == 'georgie.gow@icloud.com' ? true : false, // Set this based on your logic
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    return userDoc.get();
  }
} 