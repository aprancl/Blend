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
          emailErrorText = 'Email is required!';
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
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.blue),
        title: Text('Sign In'),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'images/login.png'), // Replace 'path_to_your_image.jpg' with the actual path to your image file
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 50.0),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Welcome', // Header text
                    style: TextStyle(
                      fontSize: 42.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Color of the text
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Back!', // Header text
                    style: TextStyle(
                      fontSize: 42.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Color of the text
                    ),
                  ),
                ),
                SizedBox(height: 180.0),
                TextField(
                  controller: emailController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: 'Email',
                    errorText: emailErrorText,
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: passwordController,
                  style: TextStyle(color: Colors.black),
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
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
                // SizedBox(
                //   height: 50.0,
                //   width: double.infinity,
                //   child: ElevatedButton(
                //     onPressed: () async {
                //       signIn();
                //     },
                //     child: Text("Forgot password?"),
                //   ),
                // ),
                SizedBox(height: 20.0),
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
                        color: const Color.fromARGB(255, 18, 93, 154),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xff374ABE),
                              Color.fromARGB(255, 27, 109, 181)
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Container(
                          constraints:
                              BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
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
                ),
               SizedBox(height: 300.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// floatingActionButton: Align(
//         alignment: Alignment.topRight,
//         child: Padding(
//           padding: EdgeInsets.only(top: 16.0, right: 16.0),
//           child: ClipPath(
//             clipper: Clip1Clipper(),
//             child: ElevatedButton(
//               onPressed: () async {
//                 // Add your onPressed logic here
//               },
//               style: ElevatedButton.styleFrom(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(80.0), // Same as the Clip1Clipper
//                 ),
//               ),
//               child: Ink(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Color.fromARGB(255, 41, 119, 255), Color.fromARGB(255, 39, 48, 151)],
//                     begin: Alignment.centerLeft,
//                     end: Alignment.centerRight,
//                   ),
//                   borderRadius: BorderRadius.circular(80.0), // Same as the Clip1Clipper
//                 ),
//                 child: Container(
//                   height: 70.0,
//                   width: MediaQuery.of(context).size.width * 0.3,
//                   alignment: Alignment.center,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),

class Clip1Clipper extends CustomClipper<Path> {
  Path getClip(Size size) {
    var height = size.height;
    var width = size.width;
    var path = new Path();

    path.lineTo(0, size.height);
    path.lineTo(size.width, height);
    path.lineTo(size.width, 0);

    /// [Top Left corner]
    var secondControlPoint = Offset(0, 0);
    var secondEndPoint = Offset(width * .2, height * .3);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    /// [Left Middle]
    var fifthControlPoint = Offset(width * .3, height * .5);
    var fiftEndPoint = Offset(width * .23, height * .6);
    path.quadraticBezierTo(fifthControlPoint.dx, fifthControlPoint.dy,
        fiftEndPoint.dx, fiftEndPoint.dy);

    /// [Bottom Left corner]
    var thirdControlPoint = Offset(0, height);
    var thirdEndPoint = Offset(width, height);
    path.quadraticBezierTo(thirdControlPoint.dx, thirdControlPoint.dy,
        thirdEndPoint.dx, thirdEndPoint.dy);

    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}
