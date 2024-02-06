import 'package:blend/pages/auth/login.dart';
import 'package:blend/pages/auth/register.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'dart:io';
import './posting/platforms.dart';
import './posting/caption.dart';
import './posting/media.dart';
import '../main.dart';
import '../global_provider.dart';

class HomePage extends StatelessWidget {
  // const HomePage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blend',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GlobalProvider>(context);
    final _bottomNavigationKey = provider.bottomNavigationKey;
    return Container(
      decoration: BoxDecoration(color: Colors.red),
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
                color: Colors.white, fontSize: 30, fontWeight: FontWeight.w700),
          ),
          // button
          ElevatedButton(
            onPressed: () {
              
              // Update navbar
              provider.goToPage(1);
            },
            child: Text('Post'),
          ),
        ],
      ),
    );
  }
}

// this class contains all the data the user sets for the posting process
