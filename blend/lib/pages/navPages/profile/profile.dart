import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:blend/global_provider.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GlobalProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(provider.getAuthUser() == null
                ? 'No user signed in'
                : 'User ' + provider.getAuthUser()!.email! + ' signed in'),
            ElevatedButton(
              onPressed: () {
                // Display LoginPage
                provider.goToPage(4);
              },
              child: Text('Sign In'),
            ),
            ElevatedButton(
              onPressed: () {
                // Display LoginPage
                provider.goToPage(5);
              },
              child: Text('Sign Up'),
            ),
            ElevatedButton(
              onPressed: () {
                // Log out
                provider.signOut();
              },
              child: Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}
