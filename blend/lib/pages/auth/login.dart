import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:blend/global_provider.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? emailErrorText = null;
  String? passwordErrorText = null;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GlobalProvider>(context);

    if (provider.existingEmail != null) {
      emailController.text = provider.existingEmail;
      provider.existingEmail = null;
    }

    void signIn() async {
      FirebaseAuthException? e =
          await provider.signIn(emailController.text, passwordController.text);

      if (e == null) {
        Navigator.popUntil(context, (route) => route.settings.name == '/');
      } else {
        if (e.code == 'user-not-found') {
          print('Account not found!');

          setState(() {
            emailErrorText = 'Account not found!';
          });
        } else if (e.code == 'wrong-password') {
          print('Invalid password!');

          setState(() {
            passwordErrorText = 'Invalid password!';
          });
        } else {
          print('Error: ${e.code}');
        }
      }
    }

    void forgotPassword(String email) async {
      if (email.isEmpty) {
        setState(() {
          emailErrorText = 'Emaiv    l is required!';
        });
      } else {
        provider.forgotPassword(email);
        // Display alert box
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Password Reset Email Sent'),
              content: Text(
                  'Please check your email for a password reset link. Be sure to check your spam folder!'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );

      }
    }
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
            // forgot password
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () async {
                    forgotPassword(emailController.text);
                  },
                  child: Text("Forgot password?"),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                signIn();
              },
              child: Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}
