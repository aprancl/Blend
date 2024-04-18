import 'dart:io';

import 'package:blend/components/appBars/sequential_app_bar.dart';
import 'package:blend/components/posting/image_container.dart';
import 'package:blend/models/platformSelection.dart';
import 'package:blend/pages/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:blend/global_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'media.dart';
import 'package:expandable_widgets/expandable_widgets.dart';

class PostingOverviewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GlobalProvider>(context);
    TextEditingController captionController = TextEditingController();

    return Scaffold(
      // ------------ AppBar ------------
      appBar: SequentialAppBar(
        leftFunction: () {
          print('Going back');
          provider.goToPage(4);
        },
        leftIcon: Icons.arrow_back,
        rightFunction: () {
          print("POSTING");
        },
        rightText: "Post",
      ).build(context),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Center(
                // ------------ Main Content ------------
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ------------ Image Display ------------
                    ImageContainer(provider: provider),
                    // ------------ Caption ------------
                    TextField(
                      controller: captionController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                        labelText: "Add your caption here",
                        alignLabelWithHint: true,
                        labelStyle: TextStyle(fontSize: 15.0),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // ------------ Platform Fields ------------
                    Center(
                      child: Text("Platform-Specfic Fields"),
                    ),
                    Expandable(backgroundColor: Colors.red, firstChild: Text("hello"), secondChild: Text("world"),),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            child: Text('Back'),
                            onPressed: () {
                              print('We want to go back!');
                              provider.goToPage(7);
                            },
                          ),
                          Spacer(),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[400]),
                            child: Text('Post Content'),
                            onPressed: () async {
                              provider.postCaption = captionController.text;

                              print('Posting Content...');

                              provider.postAll();

                              print("Content Posted!");
                              provider.hasSelectedMedia = false;
                              provider.goToPage(1);

                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
