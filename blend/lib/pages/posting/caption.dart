import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:blend/global_provider.dart';


class PostingCaptionPage extends StatelessWidget {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GlobalProvider>(context);

    return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      TextField(
        controller: controller,
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
                provider.postCaption = controller.text;
                print(provider.postCaption);
              },
            ),
            ElevatedButton(
              child: Text('Next'),
              onPressed: () {
                print('We want to go next!');
                provider.postCaption = controller.text;
                print(provider.postCaption);
              },
            ),
          ],
        ),
      ),
    ]));
  }
}
