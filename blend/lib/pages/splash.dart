import 'package:flutter/material.dart';
import 'package:blend/global_provider.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GlobalProvider>(context);
    final authUser = provider.authUser;


    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16.0),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: Text('Sign In'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: Text('Create an Account'),
            ),
          ],
        ),
      ),
    );
  }
}
