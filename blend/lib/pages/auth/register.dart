import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:blend/global_provider.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();

  String? fnameErrorText = null;
  String? lnameErrorText = null;
  String? emailErrorText = null;
  String? passwordErrorText = null;
  String? confirmErrorText = null;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  bool validate(fname, lname, email, password, confirm) {
    bool isValid = true;

    // Confirm first name is not empty
    if (fname.isEmpty) {
      print('First name is empty');
      setState(() {
        this.fnameErrorText = 'This field is required';
        isValid = false;
      });
    } else {
      // Clear first name error text
      setState(() {
        this.fnameErrorText = null;
      });
    }

    // Confirm last name is not empty
    if (lname.isEmpty) {
      print('Last name is empty');
      setState(() {
        this.lnameErrorText = 'This field is required';
        isValid = false;
      });
    } else {
      // Clear last name error text
      setState(() {
        this.lnameErrorText = null;
      });
    }

    // Confirm email is valid
    if (email.contains(RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'))) {
      // Clear email error text
      setState(() {
        this.emailErrorText = null;
      });
    } else {
      print('Invalid email');
      setState(() {
        this.emailErrorText = 'Invalid email';
      });
      isValid = false;
    }

    // Confirm passwords match
    if (password == confirm) {
      // Clear confirm error text
      setState(() {
        this.confirmErrorText = null;
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
                  this.passwordErrorText = null;
                });
              } else {
                print('Password must contain a special character');
                setState(() {
                  this.passwordErrorText =
                      'Password must contain a special character';
                });
                isValid = false;
              }
            } else {
              print('Password must contain a number');
              setState(() {
                this.passwordErrorText = 'Password must contain a number';
              });
              isValid = false;
            }
          } else {
            print('Password must contain a lowercase letter');
            setState(() {
              this.passwordErrorText =
                  'Password must contain a lowercase letter';
            });
            isValid = false;
          }
        } else {
          print('Password must contain an uppercase letter');
          setState(() {
            this.passwordErrorText =
                'Password must contain an uppercase letter';
          });
          isValid = false;
        }
      } else {
        print('Password must be at least 10 characters');
        setState(() {
          this.passwordErrorText = 'Password must be at least 10 characters';
        });
        isValid = false;
      }
    } else {
      print('Passwords do not match');
      setState(() {
        this.confirmErrorText = 'Passwords do not match';
      });
      isValid = false;
    }
    return isValid;
  }

  Future<UserCredential> signInWithGoogle() async {
    // try{
    print("google auth button SIGN IN WITH GOOGLE");
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
  //   on Exception catch (e) {
  //     print(e);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GlobalProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Create an Accout'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'First Name',
                errorText: this.fnameErrorText,
              ),
              controller: fnameController,
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Last Name',
                errorText: this.lnameErrorText,
              ),
              controller: lnameController,
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                errorText: this.emailErrorText,
              ),
              controller: emailController,
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                errorText: this.passwordErrorText,
              ),
              controller: passwordController,
            ),
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
                if (validate(
                    fnameController.text.trim(),
                    lnameController.text.trim(),
                    emailController.text.trim(),
                    passwordController.text.trim(),
                    confirmController.text.trim())) {
                  FirebaseAuthException? e = await provider.signUp(
                      fnameController.text.trim(),
                      lnameController.text.trim(),
                      emailController.text.trim(),
                      passwordController.text.trim());

                  if (e == null) {
                    Navigator.popUntil(
                        context, (route) => route.settings.name == '/');
                  } else {
                    if (e.code == 'weak-password') {
                      print('The password provided is too weak.');
                    } else if (e.code == 'email-already-in-use') {
                      print('The account already exists for that email.');
                      // Launch alert dialog
                      _accountAlreadyExists(context, emailController.text);
                    }
                  }
                }
              },
              child: Text('Sign Up'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              // Google sign in button
              onPressed: () async {
                try {
                  await signInWithGoogle();
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

Future<void> _accountAlreadyExists(BuildContext context, String email) async {
  print("registerEmail: $email");
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      final provider = Provider.of<GlobalProvider>(context);
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
              provider.existingEmail = email;
              Navigator.of(context).pop();
              Navigator.pushNamed(context, "/login");
            },
          ),
        ],
      );
    },
  );
}
