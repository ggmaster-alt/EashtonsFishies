import 'package:flutter/material.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('login page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [ 
            TextField(
              decoration: InputDecoration( 
                labelText: 'Email',
                constraints: BoxConstraints(
                  maxHeight: 50,
                  maxWidth: 200,
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}
