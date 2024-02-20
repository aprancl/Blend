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
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.blue),
        title: Text('Sign In'),
      ),
      body: SingleChildScrollView(
        child: Padding(
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
              SizedBox(
                height: 50.0,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    signIn();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(80.0),
                    ),
                    padding: EdgeInsets.all(0.0),
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xff374ABE), Color.fromARGB(255, 27, 109, 181)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Container(
                      constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                      alignment: Alignment.center,
                      child: Text(
                        "Sign In",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 16.0),
        child: SizedBox(
          height: 70.0,
          width: MediaQuery.of(context).size.width,
          child: ClipPath(
            clipper: Clip1Clipper(),
            child: Ink(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color.fromARGB(255, 41, 119, 255), Color.fromARGB(255, 39, 48, 151)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Container( // Add a container as a child of Ink
                height: 20,
                width: 20,
                color: Colors.transparent, // Set transparent color to avoid covering the gradient
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Clip1Clipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size){
    Path path = Path();
    path.lineTo(0,size.height);
    path.lineTo(size.width, size.height);
    path.quadraticBezierTo(size.width, 0, 0, 0);
    return path;
  }

  @override
  bool shouldReclip (CustomClipper<Path> oldClipper) => false;

}
