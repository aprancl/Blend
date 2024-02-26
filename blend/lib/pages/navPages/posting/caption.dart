import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:blend/global_provider.dart';

class PostingCaptionPage extends StatelessWidget {
  TextEditingController captionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GlobalProvider>(context);

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
                        "Add a Caption",
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ),
                    SizedBox(height: 50),
                    TextField(
                      controller: captionController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 10,
                      decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 40, horizontal: 15),
                        border: OutlineInputBorder(),
                        labelText: "Add your caption here",
                        alignLabelWithHint: true,
                      ),
                    ),
                    SizedBox(height: 124.0),
                    Container(
                      margin: EdgeInsets.only(right: 0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            child: Text('back'),
                            onPressed: () {
                              print('We want to go back!');
                              provider.postCaption = captionController.text;
                              print(provider.postCaption);
<<<<<<< HEAD
                              provider.goToPage(4);
=======
                              provider.goToPage(5);
>>>>>>> parent of 351e22ca ( important: kotlin downgraded to support changes; instagram image picker working, just need to fix permissions)
                            },
                          ),
                          ElevatedButton(
                            child: Text('Next'),
                            onPressed: () {
                              print('We want to go next!');
<<<<<<< HEAD
                              provider.goToPage(5);
=======
                              provider.goToPage(6);
>>>>>>> parent of 351e22ca ( important: kotlin downgraded to support changes; instagram image picker working, just need to fix permissions)
                              provider.postCaption = captionController.text;
                              print(provider.postCaption);
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
