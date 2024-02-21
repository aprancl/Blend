import 'package:flutter/material.dart';

class UndefinedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('404 Page Not Found'),
      ),
      body: Center(
        child: Text(
          'Oops! The page you are looking for does not exist.',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
