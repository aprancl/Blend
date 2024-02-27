import 'package:blend/components/misc/skewbox.dart';
import 'package:blend/global_provider.dart';
import 'package:blend/models/blendCard.dart';
import 'package:blend/models/blendUser.dart';
import 'package:blend/models/blendWorkspace.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flex_color_picker/flex_color_picker.dart';

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
  TextEditingController _backgroundController = TextEditingController();
  TextEditingController _bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      print('BlendCardPage: initState');
      BlendUser user = await Provider.of<GlobalProvider>(context, listen: false)
          .getBlendUser();
      BlendWorkspace workspace = user.workspaces![0];
      BlendCard card = await Provider.of<GlobalProvider>(context, listen: false)
          .getBlendCard(workspace.blendCard!);
      _backgroundController.text = card.background!;
      _bioController.text = card.bio!;
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

  Future<bool> colorPickerDialog(bool top) async {
    return ColorPicker(
      color: cssToColor(top
          ? widget.cardData!.card!.topColor!
          : widget.cardData!.card!.bottomColor!),
      onColorChanged: (Color color) => setState(() {
        if (top) {
          widget.cardData!.card!.topColor = colorToCss(color);
        } else {
          widget.cardData!.card!.bottomColor = colorToCss(color);
        }
      }),
      width: 40,
      height: 40,
      borderRadius: 4,
      spacing: 5,
      runSpacing: 5,
      wheelDiameter: 155,
      heading: Text(
        'Select color',
        style: Theme.of(context).textTheme.titleSmall,
      ),
      subheading: Text(
        'Select color shade',
        style: Theme.of(context).textTheme.titleSmall,
      ),
      wheelSubheading: Text(
        'Selected color and its shades',
        style: Theme.of(context).textTheme.titleSmall,
      ),
      showMaterialName: true,
      showColorName: true,
      showColorCode: true,
      copyPasteBehavior: const ColorPickerCopyPasteBehavior(
        longPressMenu: true,
      ),
      materialNameTextStyle: Theme.of(context).textTheme.bodySmall,
      colorNameTextStyle: Theme.of(context).textTheme.bodySmall,
      colorCodeTextStyle: Theme.of(context).textTheme.bodySmall,
      enableOpacity: true,
      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.both: false,
        ColorPickerType.primary: false,
        ColorPickerType.accent: false,
        ColorPickerType.bw: false,
        ColorPickerType.custom: false,
        ColorPickerType.wheel: true,
      },
    ).showPickerDialog(
      context,
      // New in version 3.0.0 custom transitions support.
      transitionBuilder: (BuildContext context, Animation<double> a1,
          Animation<double> a2, Widget widget) {
        final double curvedValue =
            Curves.easeInOutBack.transform(a1.value) - 1.0;
        return Transform(
          transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
          child: Opacity(
            opacity: a1.value,
            child: widget,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
      constraints:
          const BoxConstraints(minHeight: 460, minWidth: 300, maxWidth: 320),
    );
  }

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

  String colorToCss(Color color) {
    return "rgba(${color.red}, ${color.green}, ${color.blue}, ${color.opacity})";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Blend Card'),
      ),
      body: SingleChildScrollView(
        child: Center(
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
              // "Edit Blend Card" title
              Text(
                "Edit Colors",
                style: Theme.of(context).textTheme.titleSmall,
              ),
              // --------- COLORS SECTION ---------
              ListTile(
                title: const Text('Edit Primary Color'),
                subtitle: Text(
                  ColorTools.nameThatColor(
                      cssToColor(widget.cardData!.card!.topColor!)),
                ),
                trailing: ColorIndicator(
                  hasBorder: true,
                  width: 44,
                  height: 44,
                  borderRadius: 4,
                  color: cssToColor(widget.cardData!.card!.topColor!),
                  onSelectFocus: false,
                  onSelect: () async {
                    // Store current color before we open the dialog.
                    final Color colorBeforeDialog =
                        cssToColor(widget.cardData!.card!.topColor!);
                    // Wait for the picker to close, if dialog was dismissed,
                    // then restore the color we had before it was opened.
                    if (!(await colorPickerDialog(true))) {
                      setState(() {
                        widget.cardData!.card!.topColor =
                            colorToCss(colorBeforeDialog);
                      });
                    }
                  },
                ),
              ),

              ListTile(
                title: const Text('Edit Secondary Color'),
                subtitle: Text(
                  ColorTools.nameThatColor(
                      cssToColor(widget.cardData!.card!.bottomColor!)),
                ),
                trailing: ColorIndicator(
                  hasBorder: true,
                  width: 44,
                  height: 44,
                  borderRadius: 4,
                  color: cssToColor(widget.cardData!.card!.bottomColor!),
                  onSelectFocus: false,
                  onSelect: () async {
                    // Store current color before we open the dialog.
                    final Color colorBeforeDialog =
                        cssToColor(widget.cardData!.card!.bottomColor!);
                    // Wait for the picker to close, if dialog was dismissed,
                    // then restore the color we had before it was opened.
                    if (!(await colorPickerDialog(false))) {
                      setState(() {
                        widget.cardData!.card!.bottomColor =
                            colorToCss(colorBeforeDialog);
                      });
                    }
                  },
                ),
              ),

              // --------- BACKGROUND SECTION ---------
              Text("Edit Background Image",
                  style: Theme.of(context).textTheme.titleSmall),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Background Image URL',
                  ),
                  onChanged: (value) {
                    setState(() {
                      widget.cardData!.card!.background = value;
                    });
                  },
                  // starting value
                  controller: _backgroundController,
                ),
              ),

              // --------- BIO SECTION ---------
              Text("Edit Bio", style: Theme.of(context).textTheme.titleSmall),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Bio',
                  ),
                  onChanged: (value) {
                    setState(() {
                      widget.cardData!.card!.bio = value;
                    });
                  },
                  controller: _bioController,
                ),
              ),

              // --------- PLATFORMS SECTION ---------
              Text("Edit Platforms",
                  style: Theme.of(context).textTheme.titleSmall),
              SizedBox(
                height: 5,
              ),
              
            ],
          ),
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
