import 'package:blend/components/misc/skewbox.dart';
import 'package:blend/global_provider.dart';
import 'package:blend/models/blendCard.dart';
import 'package:blend/models/blendUser.dart';
import 'package:blend/models/blendWorkspace.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditBlendCardPage extends StatefulWidget {
  EditBlendCardPage({super.key});
  BlendCardData? cardData = BlendCardData(
      card: BlendCard(
        background:
            "https://upload.wikimedia.org/wikipedia/commons/c/ca/1x1.png",
        topColor: "rgba(0, 0, 0, 0)",
        bottomColor: "rgba(0, 0, 0, 0)",
        bio: "Loading...",
        platforms: [],
      ),
      workspaceRef: null,
      blendCardRef: null);

  @override
  State<EditBlendCardPage> createState() => _EditBlendCardPageState();
}

class _EditBlendCardPageState extends State<EditBlendCardPage> {
  

  @protected
  @mustCallSuper
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      print('BlendCardPage: initState');
      BlendUser user = await Provider.of<GlobalProvider>(context, listen: false).getBlendUser();
      BlendWorkspace workspace = user.workspaces![0];
      BlendCard card = await Provider.of<GlobalProvider>(context, listen: false).getBlendCard(workspace.blendCard!);
      setState(() {
        widget.cardData = BlendCardData(
          card: card,
          workspaceRef: user.workspaceRefs![0],
          blendCardRef: workspace.blendCard!,
        );
        print("finishedInitState");
      
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Method to convert string containing CSS rgba color to Color object
    Color cssToColor(String color) {
      String hex = color.split('(')[1].split(')')[0];
      List<String> rgba = hex.split(',');
      return Color.fromRGBO(
        int.parse(rgba[0]),
        int.parse(rgba[1]),
        int.parse(rgba[2]),
        double.parse(rgba[3]),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Blend Card'),
      ),
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SkewBox(
              topColor: cssToColor(widget.cardData!.card!.topColor!),
              bottomColor: cssToColor(widget.cardData!.card!.bottomColor!),
              height: (MediaQuery.of(context).size.width / 16) * 9,
              width: MediaQuery.of(context).size.width,
              image: widget.cardData!.card!.background!,
            ),
            SizedBox(
              height: 20,
            ),
            // Color picker
            
          ],
        ),
      ),
    );
  }
}

class BlendCardData {
  final BlendCard? card;
  final DocumentReference<Map<String, dynamic>>? workspaceRef;
  final DocumentReference<Map<String, dynamic>>? blendCardRef;

  BlendCardData({
    required this.card,
    required this.workspaceRef,
    required this.blendCardRef,
  });
}
