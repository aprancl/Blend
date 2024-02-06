import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Display LoginPage
                Navigator.pushNamed(context, '/login');
              },
              child: Text('Profile'),
            ),
            ElevatedButton(
              onPressed: () {
                // Display LoginPage
                Navigator.pushNamed(context, '/register');
              },
              child: Text('Register'),
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement logout functionality
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
