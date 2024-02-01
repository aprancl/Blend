import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();

  String emailErrorText = '';
  String passwordErrorText = '';
  String confirmErrorText = '';

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  @override
  bool validate(email, password, confirm) {
    // Confirm email is valid
    if (email.contains(RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'))) {
      // Clear email error text
      setState(() {
        this.emailErrorText = '';
      });
    } else {
      print('Invalid email');
      setState(() {
        this.emailErrorText = 'Invalid email';
      });
    }

    // Confirm passwords match
    if (password == confirm) {
      // Clear confirm error text
      setState(() {
        this.confirmErrorText = '';
      });
      // Password length >= 10
      if (password.length >= 10) {
        // Password contains an uppercase letter
        if (password.contains(RegExp(r'[A-Z]'))) {
          // Password contains a lowercase letter
          if (password.contains(RegExp(r'[a-z]'))) {
            // Password contains a number
            if (password.contains(RegExp(r'[0-9]'))) {
              // Password contains a special character
              if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>_]'))) {
                // Clear password error text
                setState(() {
                  this.passwordErrorText = '';
                });
                return true;
              } else {
                print('Password must contain a special character');
                setState(() {
                  this.passwordErrorText =
                      'Password must contain a special character';
                });
              }
            } else {
              print('Password must contain a number');
              setState(() {
                this.passwordErrorText = 'Password must contain a number';
              });
            }
          } else {
            print('Password must contain a lowercase letter');
            setState(() {
              this.passwordErrorText =
                  'Password must contain a lowercase letter';
            });
          }
        } else {
          print('Password must contain an uppercase letter');
          setState(() {
            this.passwordErrorText =
                'Password must contain an uppercase letter';
          });
        }
      } else {
        print('Password must be at least 10 characters');
        setState(() {
          this.passwordErrorText = 'Password must be at least 10 characters';
        });
      }
    } else {
      print('Passwords do not match');
      setState(() {
        this.confirmErrorText = 'Passwords do not match';
      });
    }
    return false;
  }

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
                errorText: this.emailErrorText,
              ),
              controller: emailController,
            ),
            SizedBox(height: 16.0),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                errorText: this.passwordErrorText,
              ),
              controller: passwordController,
            ),
            SizedBox(height: 16.0),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                errorText: this.confirmErrorText,
              ),
              controller: confirmController,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                if (validate(emailController.text, passwordController.text,
                    confirmController.text)) {
                  try {
                    final credential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                      email: emailController.text,
                      password: passwordController.text,
                    );
                    Navigator.pushNamed(context, "/");
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      print('The password provided is too weak.');
                    } else if (e.code == 'email-already-in-use') {
                      print('The account already exists for that email.');
                      // Launch alert dialog
                      _accountAlreadyExists(context);
                    }
                  } catch (e) {
                    print(e);
                  }
                }
              },
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _accountAlreadyExists(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Account Already Exists!'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('An account already exists for that email.'),
              Text('Would you like to sign in?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('No'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Yes'),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushNamed(context, "/login");
            },
          ),
        ],
      );
    },
  );
}