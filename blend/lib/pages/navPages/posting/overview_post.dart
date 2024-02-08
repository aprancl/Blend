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
                    SizedBox(height: 50),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      width: 350,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.purple[700],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.all(
                          Radius.circular(20.0),
                        ),
                      ),
                      child: Text(
                        provider.postCaption,
                        style: TextStyle(fontSize: 14.0),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[400]),
                      child: Text('Post Content'),
                      onPressed: () {
                        print('Post the Content');
                        // provider.goToPage(6);
                      },
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
