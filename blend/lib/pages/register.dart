import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  Future<UserCredential> signInWithGoogle() async {
    // try{
      print("google auth button SIGN IN WITH GOOGLE");
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser =
          await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance
          .signInWithCredential(credential);
  
    } 
  //   on Exception catch (e) {
  //     print(e);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
              ),
              controller: emailController,
            ),
            SizedBox(height: 16.0),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              controller: passwordController,
            ),
            SizedBox(height: 16.0),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
              ),
              controller: confirmController,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Get values from text fields
                print("Non-google sign up button pressed...");
              },
              child: Text('Sign Up'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              // Google sign in button
              onPressed: () async {
                try {
                  signInWithGoogle();
                  print("works as expected...");
                } on Exception catch (e) {
                  print(e);
                }
              },
              child: Text('Sign Up With Google'),
            ),
          ],
        ),
      ),
    );
  }
}
