import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String emailErrorText = '';
  String passwordErrorText = '';

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                errorText: emailErrorText,
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                errorText: passwordErrorText,
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                try {
                  final credential =
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: emailController.text,
                    password: passwordController.text,
                  );

                  Navigator.pushNamed(context, "/");
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    print('Account not found!');

                    setState(() {
                      emailErrorText = 'Account not found!';
                    });
                  } else if (e.code == 'wrong-password') {
                    print('Invalid password!');

                    setState(() {
                      passwordErrorText =
                          'Invalid password!';
                    });
                  }
                  else {
                    print('Error: ${e.code}');
                  }
                }
              },
              child: Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}