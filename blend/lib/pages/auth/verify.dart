import 'package:flutter/material.dart';
import 'package:blend/global_provider.dart';
import 'package:provider/provider.dart';

class VerifyPage extends StatelessWidget {
  const VerifyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GlobalProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Email'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Your email (${provider.authUser!.email}) isn\'t verified!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            // I verified my email button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(250, 50),
              ),
              child: Text('Confirm Verification Status'),
              onPressed: () async {
                // check if email is verified
                await provider.auth.currentUser!.reload();
                if (provider.auth.currentUser!.emailVerified) {
                  provider.getAuthUser();
<<<<<<< HEAD
                  provider.getBlendUser();
=======
>>>>>>> parent of 351e22ca ( important: kotlin downgraded to support changes; instagram image picker working, just need to fix permissions)
                } else {
                  // show dialog
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Email Not Verified'),
                        content: Text(
                            'Please check your email for a verification link. Be sure to check your spam folder!'),
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
              },
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(250, 50),
              ),
              child: Text('Resend Email'),
              onPressed: () async {
                // resend email
                await provider.auth.currentUser!.sendEmailVerification();

                // show dialog
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Email Sent'),
                      content: Text(
                          'Please check your email for a verification link. Be sure to check your spam folder!'),
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
              },
            ),
            SizedBox(height: 10),
            // sign out button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(250, 50),
              ),
              child: Text('Sign Out'),
              onPressed: () async {
                provider.signOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}
