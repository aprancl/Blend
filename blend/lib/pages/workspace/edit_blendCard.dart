import 'dart:ui';

import 'package:animated_list_plus/transitions.dart';
import 'package:blend/components/misc/skewbox.dart';
import 'package:blend/components/misc/tile_button.dart';
import 'package:blend/global_provider.dart';
import 'package:blend/models/blendCard.dart';
import 'package:blend/models/blendCardPlatform.dart';
import 'package:blend/models/blendUser.dart';
import 'package:blend/models/blendWorkspace.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:animated_list_plus/animated_list_plus.dart';

class EditBlendCardPage extends StatefulWidget {
  EditBlendCardPage({super.key});
  BlendCardData? cardData = BlendCardData(
    card: BlendCard(
      background: "https://upload.wikimedia.org/wikipedia/commons/c/ca/1x1.png",
      topColor: "rgba(0, 0, 0, 0)",
      bottomColor: "rgba(0, 0, 0, 0)",
      bio: "Loading...",
      platforms: [],
    ),
    workspaceRef: null,
    blendCardRef: null,
  );
  BlendCardData? originalCard = BlendCardData(
    card: BlendCard(
      background: "https://upload.wikimedia.org/wikipedia/commons/c/ca/1x1.png",
      topColor: "rgba(0, 0, 0, 0)",
      bottomColor: "rgba(0, 0, 0, 0)",
      bio: "Loading...",
      platforms: [],
    ),
    workspaceRef: null,
    blendCardRef: null,
  );
  bool unsavedChanges = false;
  String? workspaceID = "";
  String? newPlatformType = "website";
  String? editPlatformType = "";

  @override
  State<EditBlendCardPage> createState() => _EditBlendCardPageState();
}

class _EditBlendCardPageState extends State<EditBlendCardPage> {
  TextEditingController _backgroundController = TextEditingController();
  TextEditingController _bioController = TextEditingController();
  TextEditingController _platformNameController = TextEditingController();
  TextEditingController _platformUrlController = TextEditingController();
  TextEditingController _editNameController = TextEditingController();
  TextEditingController _editUrlController = TextEditingController();

  @override
  void initState() {
    // super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      print('BlendCardPage: initState');
      BlendUser user = await Provider.of<GlobalProvider>(context, listen: false)
          .getBlendUser();
      // Get the id of the first workspace
      widget.workspaceID = user.workspaceRefs![0].id;
      BlendWorkspace workspace = user.workspaces![0];
      BlendCard card = await Provider.of<GlobalProvider>(context, listen: false)
          .getBlendCard(workspace.blendCard!);
      card.topColor = colorToCss(cssToColor(card.topColor!));
      card.bottomColor = colorToCss(cssToColor(card.bottomColor!));
      _backgroundController.text = card.background!;
      _bioController.text = card.bio!;
      print("BLEND CARD PLATFORMS: ${card.platforms}");
      setState(() {
        widget.cardData = BlendCardData(
          card: card,
          workspaceRef: user.workspaceRefs![0],
          blendCardRef: workspace.blendCard!,
        );
        List<BlendCardPlatform> platforms = [];

        for (var platform in card.platforms!) {
          platforms.add(BlendCardPlatform(
            title: platform.title,
            type: platform.type,
            url: platform.url,
          ));
        }
        widget.originalCard = BlendCardData(
          card: BlendCard(
            background: card.background,
            topColor: card.topColor,
            bottomColor: card.bottomColor,
            bio: card.bio,
            platforms: platforms,
          ),
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

        if (widget.cardData!.equals(widget.originalCard!)) {
          widget.unsavedChanges = false;
        } else {
          widget.unsavedChanges = true;
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
    final provider = Provider.of<GlobalProvider>(context);

    return Scaffold(
      appBar: AppBar(
          title: Text('Edit Blend Card'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              if (widget.unsavedChanges) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Unsaved Changes"),
                      content: Text(
                          "If you leave this page, your changes will be lost. Are you sure you want to leave?"),
                      actions: <Widget>[
                        TextButton(
                          child: Text("Close"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text("Discard Changes"),
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              } else {
                Navigator.of(context).pop();
              }
            },
          )),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SkewBox(
                topColor: cssToColor(widget.cardData!.card!.topColor!),
                bottomColor: cssToColor(widget.cardData!.card!.bottomColor!),
                height: (MediaQuery.of(context).size.width / 16) * 9,
                width: MediaQuery.of(context).size.width,
                image: widget.cardData!.card!.background!,
              ),

              SizedBox(
                height: 10,
              ),
              // Full-width save changes button
              ElevatedButton(
                onPressed: (!widget.unsavedChanges)
                    ? null
                    : () async {
                        // Save changes to the database
                        await widget.cardData!.blendCardRef!.update({
                          "background": widget.cardData!.card!.background,
                          "topColor": widget.cardData!.card!.topColor,
                          "bottomColor": widget.cardData!.card!.bottomColor,
                          "bio": widget.cardData!.card!.bio,
                          "platforms": widget.cardData!.card!.platforms
                              ?.map((e) => e.toMap())
                              .toList(),
                        });
                        // Show snackbar
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Changes saved"),
                          ),
                        );

                        initState();
                      },
                child: Text("Save Changes"),
                // full width
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(10),
                  minimumSize: Size(MediaQuery.of(context).size.width - 20, 50),
                  // border radius
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              // Full-width button to copy link for blendcard
              TileButton(
                title: "Copy Link",
                icon: Icon(Icons.link),
                useDivider: false,
                onTap: () {
                  // Copy link to clipboard
                  Clipboard.setData(
                    ClipboardData(
                      text:
                          "https://barista-blend.web.app/profile/${widget.cardData!.workspaceRef!.id}",
                    ),
                  );
                  // Show snackbar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Link copied to clipboard"),
                    ),
                  );
                },
              ),
              Divider(
                color: provider.theme.dividerColor,
                thickness: 1,
              ),
              Text(
                "Edit Colors",
                style: Theme.of(context).textTheme.titleMedium,
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

                    if (widget.cardData!.equals(widget.originalCard!)) {
                      widget.unsavedChanges = false;
                    } else {
                      widget.unsavedChanges = true;
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

                    if (widget.cardData!.equals(widget.originalCard!)) {
                      widget.unsavedChanges = false;
                    } else {
                      widget.unsavedChanges = true;
                    }
                  },
                ),
              ),

              // --------- BACKGROUND SECTION ---------
              Text("Edit Background Image",
                  style: Theme.of(context).textTheme.titleMedium),
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

                      if (widget.cardData!.equals(widget.originalCard!)) {
                        widget.unsavedChanges = false;
                      } else {
                        widget.unsavedChanges = true;
                      }
                    });
                  },
                  // starting value
                  controller: _backgroundController,
                ),
              ),

              // --------- BIO SECTION ---------
              SizedBox(
                height: 10,
              ),
              Text("Edit Bio", style: Theme.of(context).textTheme.titleMedium),
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

                      if (widget.cardData!.equals(widget.originalCard!)) {
                        widget.unsavedChanges = false;
                      } else {
                        widget.unsavedChanges = true;
                      }
                    });
                  },
                  controller: _bioController,
                ),
              ),

              // --------- PLATFORMS SECTION ---------
              SizedBox(
                height: 5,
              ),
              Text("Edit Links",
                  style: Theme.of(context).textTheme.titleMedium),
              // Add link button
              TileButton(
                title: "Add Link",
                icon: Icon(Icons.add_box_outlined),
                onTap: () {
                  // Show dialog to add a new platform
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Add a new platform"),
                        content: SizedBox(
                          height: 250,
                          width: 250,
                          child: Column(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: TextField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Name',
                                  ),
                                  controller: _platformNameController,
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: TextField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'URL',
                                  ),
                                  controller: _platformUrlController,
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              // Dropdown selection for platform type
                              DropdownButtonFormField<String>(
                                value: widget.newPlatformType,
                                items: <String>[
                                  'discord',
                                  'douyin',
                                  'email',
                                  'facebook',
                                  'github',
                                  'instagram',
                                  'linkedin',
                                  'messenger',
                                  'myspace',
                                  'pinterest',
                                  'quora',
                                  'reddit',
                                  'researchgate',
                                  'skype',
                                  'snapchat',
                                  'soundcloud',
                                  'spotify',
                                  'stackoverflow',
                                  'steam',
                                  'telegram',
                                  'threads',
                                  'tiktok',
                                  'tumblr',
                                  'twitch',
                                  'vk',
                                  'website',
                                  'wechat',
                                  'whatsapp',
                                  'x',
                                  'youtube',
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? value) {
                                  setState(() {
                                    widget.newPlatformType = value;
                                  });
                                },
                                onSaved: (String? value) {
                                  setState(() {
                                    widget.newPlatformType = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text("Close"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text("Add"),
                            onPressed: () {
                              setState(() {
                                if (_platformNameController.text.isEmpty ||
                                    _platformUrlController.text.isEmpty) {
                                  // Show dialog saying that one or more fields are empty
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Error"),
                                        content: Text(
                                            "One or more fields are empty"),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text("Close"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  widget.cardData!.card!.platforms!.add(
                                    BlendCardPlatform(
                                      title: _platformNameController.text,
                                      url: _platformUrlController.text,
                                      type: widget.newPlatformType,
                                    ),
                                  );

                                  if (widget.cardData!
                                      .equals(widget.originalCard!)) {
                                    widget.unsavedChanges = false;
                                  } else {
                                    widget.unsavedChanges = true;
                                  }

                                  _platformNameController.clear();
                                  _platformUrlController.clear();
                                  widget.newPlatformType = "website";
                                  Navigator.of(context).pop();
                                }
                              });
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              buildPlatformList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPlatformList() {
    return ImplicitlyAnimatedReorderableList<BlendCardPlatform>(
      items: widget.cardData!.card!.platforms!,
      areItemsTheSame: (oldItem, newItem) => oldItem.equals(newItem),
      onReorderFinished: (item, from, to, newItems) {
        // Remember to update the underlying data when the list has been
        // reordered.
        setState(() {
          widget.cardData!.card!.platforms!
            ..clear()
            ..addAll(newItems);
        });

        if (widget.cardData!.equals(widget.originalCard!)) {
          widget.unsavedChanges = false;
        } else {
          widget.unsavedChanges = true;
        }
      },
      itemBuilder: (context, itemAnimation, item, index) {
        // Each item must be wrapped in a Reorderable widget.
        return Reorderable(
          // Each item must have an unique key.
          key: ValueKey(item),
          // The animation of the Reorderable builder can be used to
          // change to appearance of the item between dragged and normal
          // state. For example to add elevation when the item is being dragged.
          // This is not to be confused with the animation of the itemBuilder.
          // Implicit animations (like AnimatedContainer) are sadly not yet supported.
          builder: (context, dragAnimation, inDrag) {
            final t = dragAnimation.value;
            final elevation = lerpDouble(0, 8, t);
            final color =
                Color.lerp(Colors.white, Colors.white.withOpacity(0.8), t);

            return SizeFadeTransition(
              sizeFraction: 0.7,
              curve: Curves.easeInOut,
              animation: itemAnimation,
              child: Material(
                color: color,
                elevation: elevation!,
                type: MaterialType.transparency,
                child: ListTile(
                  trailing: SizedBox(
                    width: 97,
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              widget.cardData!.card!.platforms!.removeAt(index);
                            });

                            if (widget.cardData!.equals(widget.originalCard!)) {
                              widget.unsavedChanges = false;
                            } else {
                              widget.unsavedChanges = true;
                            }
                          },
                        ),
                        // Edit button
                        IconButton(
                          icon: Icon(Icons.edit),
                          padding: EdgeInsets.only(right: 0),
                          onPressed: () {
                            widget.editPlatformType =
                                widget.cardData!.card!.platforms![index].type;
                            _editNameController.text =
                                widget.cardData!.card!.platforms![index].title!;
                            _editUrlController.text =
                                widget.cardData!.card!.platforms![index].url!;
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Edit Link"),
                                  content: SizedBox(
                                    height: 250,
                                    width: 250,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          width: double.infinity,
                                          child: TextField(
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'Name',
                                            ),
                                            controller: _editNameController,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          child: TextField(
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'URL',
                                            ),
                                            controller: _editUrlController,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        // Dropdown selection for platform type
                                        DropdownButtonFormField<String>(
                                          value: widget.editPlatformType,
                                          items: <String>[
                                            'discord',
                                            'douyin',
                                            'email',
                                            'facebook',
                                            'github',
                                            'instagram',
                                            'linkedin',
                                            'messenger',
                                            'myspace',
                                            'pinterest',
                                            'quora',
                                            'reddit',
                                            'researchgate',
                                            'skype',
                                            'snapchat',
                                            'soundcloud',
                                            'spotify',
                                            'stackoverflow',
                                            'steam',
                                            'telegram',
                                            'threads',
                                            'tiktok',
                                            'tumblr',
                                            'twitch',
                                            'vk',
                                            'website',
                                            'wechat',
                                            'whatsapp',
                                            'x',
                                            'youtube',
                                          ].map<DropdownMenuItem<String>>(
                                              (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                          onChanged: (String? value) {
                                            setState(() {
                                              widget.editPlatformType = value;
                                            });
                                          },
                                          onSaved: (String? value) {
                                            setState(() {
                                              widget.editPlatformType = value;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text("Close"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: Text("Add"),
                                      onPressed: () {
                                        setState(() {
                                          if (_editNameController
                                                  .text.isEmpty ||
                                              _editUrlController.text.isEmpty) {
                                            // Show dialog saying that one or more fields are empty
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text("Error"),
                                                  content: Text(
                                                      "One or more fields are empty"),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: Text("Close"),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          } else {
                                            widget.cardData!.card!
                                                .platforms![index]
                                              ..title = _editNameController.text
                                              ..url = _editUrlController.text
                                              ..type = widget.editPlatformType;
                                            if (widget.cardData!
                                                .equals(widget.originalCard!)) {
                                              widget.unsavedChanges = false;
                                            } else {
                                              widget.unsavedChanges = true;
                                            }
                                            Navigator.of(context).pop();
                                          }
                                        });
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        )
                      ],
                    ),
                  ),
                  title: Text(item.title!),
                  // The child of a Handle can initialize a drag/reorder.
                  // This could for example be an Icon or the whole item itself. You can
                  // use the delay parameter to specify the duration for how long a pointer
                  // must press the child, until it can be dragged.
                  leading: Handle(
                    delay: const Duration(milliseconds: 100),
                    child: Icon(
                      Icons.list,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
      // Since version 0.2.0 you can also display a widget
      // before the reorderable items...

      // If you want to use headers or footers, you should set shrinkWrap to true
      shrinkWrap: true,
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

  bool equals(BlendCardData data) {
    if (data.card!.platforms!.length != card!.platforms!.length) {
      return false;
    }

    for (var i = 0; i < data.card!.platforms!.length; i++) {
      if (!data.card!.platforms![i].equals(card!.platforms![i])) {
        return false;
      }
    }

    return data.card!.background == card!.background &&
        data.card!.topColor == card!.topColor &&
        data.card!.bottomColor == card!.bottomColor &&
        data.card!.bio == card!.bio &&
        data.workspaceRef == workspaceRef &&
        data.blendCardRef == blendCardRef;
  }
}
