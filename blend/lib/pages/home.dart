import 'package:blend/pages/login.dart';
import 'package:blend/pages/register.dart';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../main.dart';

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
        page = GeneratorPage();
        break;
      case 1:
        page = FavoritesPage();
        break;
      case 2:
        page = PostingPagePlatforms();
      case 3:
        page = PostingAddCaption();
      case 4:
        page = PostingAddMedia();
      case 5:
        // push to /login
        // Navigator.pushNamed(context, '/login');
        page = LoginPage();
      case 6:
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
                  icon: Icon(Icons.home),
                  label: Text('Home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.favorite),
                  label: Text('Favorites'),
                ),
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
class PostDataState extends ChangeNotifier {
  var platforms =
      <String>[]; // a list of strings, each denoting the platforms to post to
  var text = ""; // the text to go with the post
  var media = ""; // pointer to the media that they provide
}

class PostingAddMedia extends StatelessWidget {
  XFile? image;

  Future pickImage() async {
    try {
      final img = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (img != null) {
        image = img;
        print('printing image: ${image!.path}');
      }
    } on Error catch (err) {
      debugPrint("Failed to find image: $err");
    }
  }

  @override
  Widget build(BuildContext context) {
    // var appState = context.watch<PostDataState>();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Hello world: Media'),
          ElevatedButton(
            child: Text('Add Media'),
            onPressed: () {
              pickImage();
            },
          ),
          if (image != null)
            Container(
              margin: EdgeInsets.only(top: 20.0),
              child: Image.file(
                File(image!.path),
                height: 200.0, // Set the desired height
                width: 200.0, // Set the desired width
                fit: BoxFit.cover, // Adjust the fit as needed
              ),
            ),
        ],
      ),
    );
  }
}

class PostingAddCaption extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // var appState = context.watch<PostDataState>();

    return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      TextField(
        keyboardType: TextInputType.multiline,
        maxLines: 10,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 40, horizontal: 15),
          border: OutlineInputBorder(),
          labelText: "Add caption here",
          alignLabelWithHint: true,
        ),
      ),
      Container(
        margin: EdgeInsets.only(right: 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              child: Text('back'),
              onPressed: () {
                print('We want to go back!');
              },
            ),
            ElevatedButton(
              child: Text('Next'),
              onPressed: () {
                print('We want to go next!');
              },
            ),
          ],
        ),
      ),
    ]));
  }
}

class PostingPagePlatforms extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // var appState = context.watch<PostDataState>();
    // var cur_platforms = appState.platforms;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Title(
            color: Color(0xFFFFFFFF),
            child: Text(
              "Choose Platforms",
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Divider(
            color: Colors.white,
            thickness: 3.0,
            indent: 12.0,
            endIndent: 12.0,
          ),
          MediaSelectionButton(
            Icons.camera_alt_sharp,
            "Instagram",
          ),
          MediaSelectionButton(
            Icons.music_note,
            "TikTok",
          ),
          MediaSelectionButton(
            Icons.play_arrow_sharp,
            "Youtube",
          ),
          MediaSelectionButton(
            Icons.snapchat_outlined,
            "Snapchat",
          ),
          MediaSelectionButton(
            Icons.cancel_presentation_sharp,
            "X",
          ),
          MediaSelectionButton(
            Icons.facebook,
            "Facebook",
          ),
          MediaSelectionButton(
            Icons.language_sharp,
            "LinkedIn",
          ),
          // adding a button group
          Container(
            margin: EdgeInsets.only(right: 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Spacer(),
                ElevatedButton(
                  child: Text('Next'),
                  onPressed: () {
                    print('We want to go next!');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MediaSelectionButton extends StatelessWidget {
  final IconData buttonIcon;
  final String label;

  MediaSelectionButton(this.buttonIcon, this.label);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("User selected $label");
      },
      child: Column(
        children: <Widget>[
          Container(
            margin:
                EdgeInsets.only(bottom: 10.0), // Adjust the margin as needed
            padding: EdgeInsets.only(left: 20.0, right: 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF3366FF),
                  const Color(0xFF00CCFF),
                ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
            child: ListTile(
              contentPadding:
                  EdgeInsets.all(0), // Remove default ListTile padding
              leading: Icon(buttonIcon),
              title: Text(label),
            ),
          ),
        ],
      ),
    );
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10), // Space out the text and the btn
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10), // Space out the btns
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have '
              '${appState.favorites.length} favorites:'),
        ),
        for (var pair in appState.favorites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(pair.asLowerCase),
          ),
      ],
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          pair.asLowerCase,
          style: style,
          semanticsLabel: pair.asPascalCase,
        ),
      ),
    );
  }
}
