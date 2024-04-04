import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:blend/global_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'media.dart';

class PostingOverviewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GlobalProvider>(context);
    TextEditingController captionController = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Title(
                      color: Color(0xFFFFFFFF),
                      child: Text(
                        "Review Post",
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ),
                    Divider(
                      color: Color.fromARGB(255, 255, 255, 255),
                      thickness: 3.0,
                      indent: 12.0,
                      endIndent: 12.0,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    ImageContainer(provider: provider),
                    SizedBox(height: 25),
                    Container(
                      child: TextField(
                        controller: captionController,
                        keyboardType: TextInputType.multiline,
                        maxLines: 10,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 40, horizontal: 15),
                          border: OutlineInputBorder(),
                          labelText: "Add your caption here",
                          alignLabelWithHint: true,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
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
                              print('Post the Content');
                              provider.postCaption = captionController.text;
                              var userInfo = await provider.getUserInfo();
                              print(userInfo);
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
