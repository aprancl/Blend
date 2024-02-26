import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:blend/global_provider.dart';
import 'media.dart';

class PostingOverviewPage extends StatelessWidget {
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
                      padding: EdgeInsets.all(10.0),
                      width: 350,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 35, 70, 198).withOpacity(0.3),
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.all(
                          Radius.circular(20.0),
                        ),
                      ),
                      
                      child: TextField(
                          keyboardType: TextInputType.multiline,
                          maxLines: 10,
                          decoration: const InputDecoration(
                            contentPadding:
<<<<<<< HEAD
                                EdgeInsets.symmetric(vertical: 10, horizontal: 15),
=======
                                EdgeInsets.symmetric(vertical: 40, horizontal: 15),
>>>>>>> parent of 351e22ca ( important: kotlin downgraded to support changes; instagram image picker working, just need to fix permissions)
                            border: OutlineInputBorder(),
                            labelText: "Add your caption here",
                            alignLabelWithHint: true,
                          ),
                        ),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            child: Text('Back'),
                            onPressed: () {
                              print('We want to go back!');
                              provider.goToPage(4);
                            },
                          ),
                          Spacer(),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[400]),
                            child: Text('Post Content'),
                            onPressed: () {
                              print('Post the Content');
<<<<<<< HEAD
                              // provider.goToPage(5);
=======
                              // provider.goToPage(6);
>>>>>>> parent of 351e22ca ( important: kotlin downgraded to support changes; instagram image picker working, just need to fix permissions)
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

