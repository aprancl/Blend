import 'package:blend/components/appBars/main_app_bar.dart';
import 'package:blend/models/blendCard.dart';
import 'package:blend/models/blendUser.dart';
import 'package:blend/models/blendWorkspace.dart';
import 'package:blend/pages/workspace/edit_blendCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:blend/global_provider.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GlobalProvider>(context);
    final _bottomNavigationKey = provider.bottomNavigationKey;
    return Scaffold(
      appBar: MainAppBar().build(context),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.home,
              size: 120,
              color: Colors.white,
            ),
            Text(
              'Home Page',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w700),
            ),
            // button
            ElevatedButton(
              onPressed: () {
                provider.signOut();
              },
              child: Text('Sign Out'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/workspace/blendcard',
                );
              },
              child: Text('Blend Card'),
            )
          ],
        ),
      ),
    );
  }
}



// this class contains all the data the user sets for the posting process
