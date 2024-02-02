import 'package:blend/pages/auth/login.dart';
import 'package:blend/pages/auth/register.dart';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import './posting/platforms.dart';
import './posting/caption.dart';
import './posting/media.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = PostingPlatformsPage();
      case 1:
        page = PostingCaptionPage();
      case 2:
        page = PostingMediaPage();
      case 3:
        // push to /login
        // Navigator.pushNamed(context, '/login');
        page = LoginPage();
      case 4:
        // push to /register
        // Navigator.pushNamed(context, '/register');
        page = RegisterPage();
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return Scaffold(
      body: Row(
        children: [
          SafeArea(
            child: NavigationRail(
              extended: false,
              //
              destinations: [
                NavigationRailDestination(
                  icon: Icon(Icons.cloud_circle_outlined),
                  label: Text('Post'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.book),
                  label: Text("Add Text"),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.camera),
                  label: Text("Add Media"),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.login),
                  label: Text('Login'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.person_add),
                  label: Text('Register'),
                ),
              ],
              selectedIndex: selectedIndex,
              onDestinationSelected: (value) {
                setState(() {
                  print(value);
                  selectedIndex = value;
                });
              },
            ),
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: page,
            ),
          ),
        ],
      ),
    );
  }
}

// this class contains all the data the user sets for the posting process
