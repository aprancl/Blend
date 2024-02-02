import 'package:flutter/material.dart';
import './postingState.dart';

class PostingCaptionPage extends StatelessWidget {
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
