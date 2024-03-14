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

class UserThemePage extends StatefulWidget {
  UserThemePage({super.key});
  bool unsavedChanges = false;
  ThemeData? themeData = ThemeData(
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: Color.fromARGB(255, 213, 220, 231),
      onPrimary: Color.fromARGB(255, 0, 157, 255),
      primaryContainer: Color(0xff0028ff),
      onPrimaryContainer: Color(0xffd0d9ff),
      secondary: Color(0xff00d3ff),
      onSecondary: Color(0xff061e1e),
      secondaryContainer: Color(0xff009fad),
      onSecondaryContainer: Color(0xffd0f5f8),
      tertiary: Color(0xff86d2e1),
      onTertiary: Color(0xff151e1e),
      tertiaryContainer: Color.fromARGB(255, 0, 78, 89),
      onTertiaryContainer: Color(0xffd0e2e5),
      error: Color(0xffffb4a9),
      onError: Color(0xff680003),
      errorContainer: Color(0xff930006),
      onErrorContainer: Color(0xffffb4a9),
      outline: Color(0xff93969a),
      background: Color.fromARGB(255, 11, 41, 102),
      onBackground: Color.fromARGB(255, 255, 255, 255),
      surface: Color.fromARGB(255, 0, 7, 48),
      onSurface: Color(0xfff0f1f1),
      surfaceVariant: Color(0xff10171e),
      onSurfaceVariant: Color(0xffe2e3e4),
      inverseSurface: Color(0xfff8fbff),
      onInverseSurface: Color(0xff0e0e0f),
      inversePrimary: Color.fromARGB(255, 14, 70, 115),
      shadow: Color(0xff000000),
    ),
  );
  ThemeData originalTheme = ThemeData();

  @override
  State<UserThemePage> createState() => _UserThemePageState();
}

class _UserThemePageState extends State<UserThemePage> {
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
      // Get theme data from global provider
      final provider = Provider.of<GlobalProvider>(context, listen: false);
      widget.themeData = provider.theme;
      widget.originalTheme = ThemeData.from(
        colorScheme: widget.themeData!.colorScheme,
      );
    });
  }

  Future<Color> colorPickerDialog(Color themeColor) async {
    await ColorPicker(
      color: themeColor,
      onColorChanged: (Color color) => setState(() {
        themeColor = color;
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
    return themeColor;
  }

  bool areThemesEqual(ThemeData theme1, ThemeData theme2) {
    if (theme1.colorScheme.primary == theme2.colorScheme.primary) {
      if (theme1.colorScheme.primaryContainer ==
          theme2.colorScheme.primaryContainer) {
        if (theme1.colorScheme.secondary == theme2.colorScheme.secondary) {
          if (theme1.colorScheme.secondaryContainer ==
              theme2.colorScheme.secondaryContainer) {
            if (theme1.colorScheme.tertiary == theme2.colorScheme.tertiary) {
              if (theme1.colorScheme.tertiaryContainer ==
                  theme2.colorScheme.tertiaryContainer) {
                if (theme1.colorScheme.error == theme2.colorScheme.error) {
                  if (theme1.colorScheme.errorContainer ==
                      theme2.colorScheme.errorContainer) {
                    if (theme1.colorScheme.outline ==
                        theme2.colorScheme.outline) {
                      if (theme1.colorScheme.background ==
                          theme2.colorScheme.background) {
                        if (theme1.colorScheme.surface ==
                            theme2.colorScheme.surface) {
                          if (theme1.colorScheme.surfaceVariant ==
                              theme2.colorScheme.surfaceVariant) {
                            if (theme1.colorScheme.inverseSurface ==
                                theme2.colorScheme.inverseSurface) {
                              if (theme1.colorScheme.inversePrimary ==
                                  theme2.colorScheme.inversePrimary) {
                                if (theme1.colorScheme.shadow ==
                                    theme2.colorScheme.shadow) {
                                  return true;
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GlobalProvider>(context);

    return Scaffold(
      appBar: AppBar(
          title: Text('Edit Theme'),
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
              SizedBox(height: 20),
              Text(
                "Edit Colors",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              // --------- COLORS SECTION ---------

              // primary: Color.fromARGB(255, 213, 220, 231),
              // onPrimary: Color.fromARGB(255, 0, 157, 255),
              // primaryContainer: Color(0xff0028ff),
              // onPrimaryContainer: Color(0xffd0d9ff),
              // secondary: Color(0xff00d3ff),
              // onSecondary: Color(0xff061e1e),
              // secondaryContainer: Color(0xff009fad),
              // onSecondaryContainer: Color(0xffd0f5f8),
              // tertiary: Color(0xff86d2e1),
              // onTertiary: Color(0xff151e1e),
              // tertiaryContainer: Color.fromARGB(255, 0, 78, 89),
              // onTertiaryContainer: Color(0xffd0e2e5),
              // error: Color(0xffffb4a9),
              // onError: Color(0xff680003),
              // errorContainer: Color(0xff930006),
              // onErrorContainer: Color(0xffffb4a9),
              // outline: Color(0xff93969a),
              // background: Color.fromARGB(255, 11, 41, 102),
              // onBackground: Color.fromARGB(255, 255, 255, 255),
              // surface: Color.fromARGB(255, 0, 7, 48),
              // onSurface: Color(0xfff0f1f1),
              // surfaceVariant: Color(0xff10171e),
              // onSurfaceVariant: Color(0xffe2e3e4),
              // inverseSurface: Color(0xfff8fbff),
              // onInverseSurface: Color(0xff0e0e0f),
              // inversePrimary: Color.fromARGB(255, 14, 70, 115),
              // shadow: Color(0xff000000),

              ListTile(
                title: const Text('Primary'),
                subtitle: Text(
                  ColorTools.nameThatColor(
                      widget.themeData!.colorScheme.primary),
                ),
                trailing: ColorIndicator(
                  hasBorder: true,
                  width: 44,
                  height: 44,
                  borderRadius: 4,
                  color: widget.themeData!.colorScheme.primary,
                  onSelectFocus: false,
                  onSelect: () async {
                    // Store current color before we open the dialog.
                    final Color colorBeforeDialog =
                        widget.themeData!.colorScheme.primary;
                    // Wait for the picker to close, if dialog was dismissed,
                    // then restore the color we had before it was opened.
                    Color newColor = await colorPickerDialog(
                        widget.themeData!.colorScheme.primary);
                    if (newColor != colorBeforeDialog) {
                      setState(() {
                        ThemeData newTheme = ThemeData(
                          colorScheme: widget.themeData!.colorScheme.copyWith(
                            primary: newColor,
                          ),
                        );
                        widget.themeData = newTheme;
                      });
                    }

                    if (!areThemesEqual(
                        widget.themeData!, widget.originalTheme)) {
                      widget.unsavedChanges = true;
                    } else {
                      widget.unsavedChanges = false;
                    }
                  },
                ),
              ),
              ListTile(
                title: const Text('On Primary'),
                subtitle: Text(
                  ColorTools.nameThatColor(
                      widget.themeData!.colorScheme.onPrimary),
                ),
                trailing: ColorIndicator(
                  hasBorder: true,
                  width: 44,
                  height: 44,
                  borderRadius: 4,
                  color: widget.themeData!.colorScheme.onPrimary,
                  onSelectFocus: false,
                  onSelect: () async {
                    // Store current color before we open the dialog.
                    final Color colorBeforeDialog =
                        widget.themeData!.colorScheme.onPrimary;
                    // Wait for the picker to close, if dialog was dismissed,
                    // then restore the color we had before it was opened.
                    Color newColor = await colorPickerDialog(
                        widget.themeData!.colorScheme.onPrimary);
                    if (newColor != colorBeforeDialog) {
                      setState(() {
                        ThemeData newTheme = ThemeData(
                          colorScheme: widget.themeData!.colorScheme.copyWith(
                            onPrimary: newColor,
                          ),
                        );
                        widget.themeData = newTheme;
                      });
                    }

                    if (!areThemesEqual(
                        widget.themeData!, widget.originalTheme)) {
                      widget.unsavedChanges = true;
                    } else {
                      widget.unsavedChanges = false;
                    }
                  },
                ),
              ),
              ListTile(
                title: const Text('Primary Container'),
                subtitle: Text(
                  ColorTools.nameThatColor(
                      widget.themeData!.colorScheme.primaryContainer),
                ),
                trailing: ColorIndicator(
                  hasBorder: true,
                  width: 44,
                  height: 44,
                  borderRadius: 4,
                  color: widget.themeData!.colorScheme.primaryContainer,
                  onSelectFocus: false,
                  onSelect: () async {
                    // Store current color before we open the dialog.
                    final Color colorBeforeDialog =
                        widget.themeData!.colorScheme.primaryContainer;
                    // Wait for the picker to close, if dialog was dismissed,
                    // then restore the color we had before it was opened.
                    Color newColor = await colorPickerDialog(
                        widget.themeData!.colorScheme.primaryContainer);
                    if (newColor != colorBeforeDialog) {
                      setState(() {
                        ThemeData newTheme = ThemeData(
                          colorScheme: widget.themeData!.colorScheme.copyWith(
                            primaryContainer: newColor,
                          ),
                        );
                        widget.themeData = newTheme;
                      });
                    }

                    if (!areThemesEqual(
                        widget.themeData!, widget.originalTheme)) {
                      widget.unsavedChanges = true;
                    } else {
                      widget.unsavedChanges = false;
                    }
                  },
                ),
              ),
              ListTile(
                title: const Text('On Primary Container'),
                subtitle: Text(
                  ColorTools.nameThatColor(
                      widget.themeData!.colorScheme.onPrimaryContainer),
                ),
                trailing: ColorIndicator(
                  hasBorder: true,
                  width: 44,
                  height: 44,
                  borderRadius: 4,
                  color: widget.themeData!.colorScheme.onPrimaryContainer,
                  onSelectFocus: false,
                  onSelect: () async {
                    // Store current color before we open the dialog.
                    final Color colorBeforeDialog =
                        widget.themeData!.colorScheme.onPrimaryContainer;
                    // Wait for the picker to close, if dialog was dismissed,
                    // then restore the color we had before it was opened.
                    Color newColor = await colorPickerDialog(
                        widget.themeData!.colorScheme.onPrimaryContainer);
                    if (newColor != colorBeforeDialog) {
                      setState(() {
                        ThemeData newTheme = ThemeData(
                          colorScheme: widget.themeData!.colorScheme.copyWith(
                            onPrimaryContainer: newColor,
                          ),
                        );
                        widget.themeData = newTheme;
                      });
                    }

                    if (!areThemesEqual(
                        widget.themeData!, widget.originalTheme)) {
                      widget.unsavedChanges = true;
                    } else {
                      widget.unsavedChanges = false;
                    }
                  },
                ),
              ),
              ListTile(
                title: const Text('Secondary'),
                subtitle: Text(
                  ColorTools.nameThatColor(
                      widget.themeData!.colorScheme.secondary),
                ),
                trailing: ColorIndicator(
                  hasBorder: true,
                  width: 44,
                  height: 44,
                  borderRadius: 4,
                  color: widget.themeData!.colorScheme.secondary,
                  onSelectFocus: false,
                  onSelect: () async {
                    // Store current color before we open the dialog.
                    final Color colorBeforeDialog =
                        widget.themeData!.colorScheme.secondary;
                    // Wait for the picker to close, if dialog was dismissed,
                    // then restore the color we had before it was opened.
                    Color newColor = await colorPickerDialog(
                        widget.themeData!.colorScheme.secondary);
                    if (newColor != colorBeforeDialog) {
                      setState(() {
                        ThemeData newTheme = ThemeData(
                          colorScheme: widget.themeData!.colorScheme.copyWith(
                            secondary: newColor,
                          ),
                        );
                        widget.themeData = newTheme;
                      });
                    }

                    if (!areThemesEqual(
                        widget.themeData!, widget.originalTheme)) {
                      widget.unsavedChanges = true;
                    } else {
                      widget.unsavedChanges = false;
                    }
                  },
                ),
              ),
              ListTile(
                title: const Text('On Secondary'),
                subtitle: Text(
                  ColorTools.nameThatColor(
                      widget.themeData!.colorScheme.onSecondary),
                ),
                trailing: ColorIndicator(
                  hasBorder: true,
                  width: 44,
                  height: 44,
                  borderRadius: 4,
                  color: widget.themeData!.colorScheme.onSecondary,
                  onSelectFocus: false,
                  onSelect: () async {
                    // Store current color before we open the dialog.
                    final Color colorBeforeDialog =
                        widget.themeData!.colorScheme.onSecondary;
                    // Wait for the picker to close, if dialog was dismissed,
                    // then restore the color we had before it was opened.
                    Color newColor = await colorPickerDialog(
                        widget.themeData!.colorScheme.onSecondary);
                    if (newColor != colorBeforeDialog) {
                      setState(() {
                        ThemeData newTheme = ThemeData(
                          colorScheme: widget.themeData!.colorScheme.copyWith(
                            onSecondary: newColor,
                          ),
                        );
                        widget.themeData = newTheme;
                      });
                    }

                    if (!areThemesEqual(
                        widget.themeData!, widget.originalTheme)) {
                      widget.unsavedChanges = true;
                    } else {
                      widget.unsavedChanges = false;
                    }
                  },
                ),
              ),
              ListTile(
                title: const Text('Secondary Container'),
                subtitle: Text(
                  ColorTools.nameThatColor(
                      widget.themeData!.colorScheme.secondaryContainer),
                ),
                trailing: ColorIndicator(
                  hasBorder: true,
                  width: 44,
                  height: 44,
                  borderRadius: 4,
                  color: widget.themeData!.colorScheme.secondaryContainer,
                  onSelectFocus: false,
                  onSelect: () async {
                    // Store current color before we open the dialog.
                    final Color colorBeforeDialog =
                        widget.themeData!.colorScheme.secondaryContainer;
                    // Wait for the picker to close, if dialog was dismissed,
                    // then restore the color we had before it was opened.
                    Color newColor = await colorPickerDialog(
                        widget.themeData!.colorScheme.secondaryContainer);
                    if (newColor != colorBeforeDialog) {
                      setState(() {
                        ThemeData newTheme = ThemeData(
                          colorScheme: widget.themeData!.colorScheme.copyWith(
                            secondaryContainer: newColor,
                          ),
                        );
                        widget.themeData = newTheme;
                      });
                    }

                    if (!areThemesEqual(
                        widget.themeData!, widget.originalTheme)) {
                      widget.unsavedChanges = true;
                    } else {
                      widget.unsavedChanges = false;
                    }
                  },
                ),
              ),
              ListTile(
                title: const Text('On Secondary Container'),
                subtitle: Text(
                  ColorTools.nameThatColor(
                      widget.themeData!.colorScheme.onSecondaryContainer),
                ),
                trailing: ColorIndicator(
                  hasBorder: true,
                  width: 44,
                  height: 44,
                  borderRadius: 4,
                  color: widget.themeData!.colorScheme.onSecondaryContainer,
                  onSelectFocus: false,
                  onSelect: () async {
                    // Store current color before we open the dialog.
                    final Color colorBeforeDialog =
                        widget.themeData!.colorScheme.onSecondaryContainer;
                    // Wait for the picker to close, if dialog was dismissed,
                    // then restore the color we had before it was opened.
                    Color newColor = await colorPickerDialog(
                        widget.themeData!.colorScheme.onSecondaryContainer);
                    if (newColor != colorBeforeDialog) {
                      setState(() {
                        ThemeData newTheme = ThemeData(
                          colorScheme: widget.themeData!.colorScheme.copyWith(
                            onSecondaryContainer: newColor,
                          ),
                        );
                        widget.themeData = newTheme;
                      });
                    }

                    if (!areThemesEqual(
                        widget.themeData!, widget.originalTheme)) {
                      widget.unsavedChanges = true;
                    } else {
                      widget.unsavedChanges = false;
                    }
                  },
                ),
              ),
              ListTile(
                title: const Text('Tertiary'),
                subtitle: Text(
                  ColorTools.nameThatColor(
                      widget.themeData!.colorScheme.tertiary),
                ),
                trailing: ColorIndicator(
                  hasBorder: true,
                  width: 44,
                  height: 44,
                  borderRadius: 4,
                  color: widget.themeData!.colorScheme.tertiary,
                  onSelectFocus: false,
                  onSelect: () async {
                    // Store current color before we open the dialog.
                    final Color colorBeforeDialog =
                        widget.themeData!.colorScheme.tertiary;
                    // Wait for the picker to close, if dialog was dismissed,
                    // then restore the color we had before it was opened.
                    Color newColor = await colorPickerDialog(
                        widget.themeData!.colorScheme.tertiary);
                    if (newColor != colorBeforeDialog) {
                      setState(() {
                        ThemeData newTheme = ThemeData(
                          colorScheme: widget.themeData!.colorScheme.copyWith(
                            tertiary: newColor,
                          ),
                        );
                        widget.themeData = newTheme;
                      });
                    }

                    if (!areThemesEqual(
                        widget.themeData!, widget.originalTheme)) {
                      widget.unsavedChanges = true;
                    } else {
                      widget.unsavedChanges = false;
                    }
                  },
                ),
              ),
              ListTile(
                title: const Text('On Tertiary'),
                subtitle: Text(
                  ColorTools.nameThatColor(
                      widget.themeData!.colorScheme.onTertiary),
                ),
                trailing: ColorIndicator(
                  hasBorder: true,
                  width: 44,
                  height: 44,
                  borderRadius: 4,
                  color: widget.themeData!.colorScheme.onTertiary,
                  onSelectFocus: false,
                  onSelect: () async {
                    // Store current color before we open the dialog.
                    final Color colorBeforeDialog =
                        widget.themeData!.colorScheme.onTertiary;
                    // Wait for the picker to close, if dialog was dismissed,
                    // then restore the color we had before it was opened.
                    Color newColor = await colorPickerDialog(
                        widget.themeData!.colorScheme.onTertiary);
                    if (newColor != colorBeforeDialog) {
                      setState(() {
                        ThemeData newTheme = ThemeData(
                          colorScheme: widget.themeData!.colorScheme.copyWith(
                            onTertiary: newColor,
                          ),
                        );
                        widget.themeData = newTheme;
                      });
                    }

                    if (!areThemesEqual(
                        widget.themeData!, widget.originalTheme)) {
                      widget.unsavedChanges = true;
                    } else {
                      widget.unsavedChanges = false;
                    }
                  },
                ),
              ),
              ListTile(
                title: const Text('Tertiary Container'),
                subtitle: Text(
                  ColorTools.nameThatColor(
                      widget.themeData!.colorScheme.tertiaryContainer),
                ),
                trailing: ColorIndicator(
                  hasBorder: true,
                  width: 44,
                  height: 44,
                  borderRadius: 4,
                  color: widget.themeData!.colorScheme.tertiaryContainer,
                  onSelectFocus: false,
                  onSelect: () async {
                    // Store current color before we open the dialog.
                    final Color colorBeforeDialog =
                        widget.themeData!.colorScheme.tertiaryContainer;
                    // Wait for the picker to close, if dialog was dismissed,
                    // then restore the color we had before it was opened.
                    Color newColor = await colorPickerDialog(
                        widget.themeData!.colorScheme.tertiaryContainer);
                    if (newColor != colorBeforeDialog) {
                      setState(() {
                        ThemeData newTheme = ThemeData(
                          colorScheme: widget.themeData!.colorScheme.copyWith(
                            tertiaryContainer: newColor,
                          ),
                        );
                        widget.themeData = newTheme;
                      });
                    }

                    if (!areThemesEqual(
                        widget.themeData!, widget.originalTheme)) {
                      widget.unsavedChanges = true;
                    } else {
                      widget.unsavedChanges = false;
                    }
                  },
                ),
              ),
              ListTile(
                title: const Text('On Tertiary Container'),
                subtitle: Text(
                  ColorTools.nameThatColor(
                      widget.themeData!.colorScheme.onTertiaryContainer),
                ),
                trailing: ColorIndicator(
                  hasBorder: true,
                  width: 44,
                  height: 44,
                  borderRadius: 4,
                  color: widget.themeData!.colorScheme.onTertiaryContainer,
                  onSelectFocus: false,
                  onSelect: () async {
                    // Store current color before we open the dialog.
                    final Color colorBeforeDialog =
                        widget.themeData!.colorScheme.onTertiaryContainer;
                    // Wait for the picker to close, if dialog was dismissed,
                    // then restore the color we had before it was opened.
                    Color newColor = await colorPickerDialog(
                        widget.themeData!.colorScheme.onTertiaryContainer);
                    if (newColor != colorBeforeDialog) {
                      setState(() {
                        ThemeData newTheme = ThemeData(
                          colorScheme: widget.themeData!.colorScheme.copyWith(
                            onTertiaryContainer: newColor,
                          ),
                        );
                        widget.themeData = newTheme;
                      });
                    }

                    if (!areThemesEqual(
                        widget.themeData!, widget.originalTheme)) {
                      widget.unsavedChanges = true;
                    } else {
                      widget.unsavedChanges = false;
                    }
                  },
                ),
              ),
              ListTile(
                title: const Text('Error'),
                subtitle: Text(
                  ColorTools.nameThatColor(widget.themeData!.colorScheme.error),
                ),
                trailing: ColorIndicator(
                  hasBorder: true,
                  width: 44,
                  height: 44,
                  borderRadius: 4,
                  color: widget.themeData!.colorScheme.error,
                  onSelectFocus: false,
                  onSelect: () async {
                    // Store current color before we open the dialog.
                    final Color colorBeforeDialog =
                        widget.themeData!.colorScheme.error;
                    // Wait for the picker to close, if dialog was dismissed,
                    // then restore the color we had before it was opened.
                    Color newColor = await colorPickerDialog(
                        widget.themeData!.colorScheme.error);
                    if (newColor != colorBeforeDialog) {
                      setState(() {
                        ThemeData newTheme = ThemeData(
                          colorScheme: widget.themeData!.colorScheme.copyWith(
                            error: newColor,
                          ),
                        );
                        widget.themeData = newTheme;
                      });
                    }

                    if (!areThemesEqual(
                        widget.themeData!, widget.originalTheme)) {
                      widget.unsavedChanges = true;
                    } else {
                      widget.unsavedChanges = false;
                    }
                  },
                ),
              ),
              ListTile(
                title: const Text('On Error'),
                subtitle: Text(
                  ColorTools.nameThatColor(
                      widget.themeData!.colorScheme.onError),
                ),
                trailing: ColorIndicator(
                  hasBorder: true,
                  width: 44,
                  height: 44,
                  borderRadius: 4,
                  color: widget.themeData!.colorScheme.onError,
                  onSelectFocus: false,
                  onSelect: () async {
                    // Store current color before we open the dialog.
                    final Color colorBeforeDialog =
                        widget.themeData!.colorScheme.onError;
                    // Wait for the picker to close, if dialog was dismissed,
                    // then restore the color we had before it was opened.
                    Color newColor = await colorPickerDialog(
                        widget.themeData!.colorScheme.onError);
                    if (newColor != colorBeforeDialog) {
                      setState(() {
                        ThemeData newTheme = ThemeData(
                          colorScheme: widget.themeData!.colorScheme.copyWith(
                            onError: newColor,
                          ),
                        );
                        widget.themeData = newTheme;
                      });
                    }

                    if (!areThemesEqual(
                        widget.themeData!, widget.originalTheme)) {
                      widget.unsavedChanges = true;
                    } else {
                      widget.unsavedChanges = false;
                    }
                  },
                ),
              ),
              ListTile(
                title: const Text('Error Container'),
                subtitle: Text(
                  ColorTools.nameThatColor(
                      widget.themeData!.colorScheme.errorContainer),
                ),
                trailing: ColorIndicator(
                  hasBorder: true,
                  width: 44,
                  height: 44,
                  borderRadius: 4,
                  color: widget.themeData!.colorScheme.errorContainer,
                  onSelectFocus: false,
                  onSelect: () async {
                    // Store current color before we open the dialog.
                    final Color colorBeforeDialog =
                        widget.themeData!.colorScheme.errorContainer;
                    // Wait for the picker to close, if dialog was dismissed,
                    // then restore the color we had before it was opened.
                    Color newColor = await colorPickerDialog(
                        widget.themeData!.colorScheme.errorContainer);
                    if (newColor != colorBeforeDialog) {
                      setState(() {
                        ThemeData newTheme = ThemeData(
                          colorScheme: widget.themeData!.colorScheme.copyWith(
                            errorContainer: newColor,
                          ),
                        );
                        widget.themeData = newTheme;
                      });
                    }

                    if (!areThemesEqual(
                        widget.themeData!, widget.originalTheme)) {
                      widget.unsavedChanges = true;
                    } else {
                      widget.unsavedChanges = false;
                    }
                  },
                ),
              ),
              ListTile(
                title: const Text('On Error Container'),
                subtitle: Text(
                  ColorTools.nameThatColor(
                      widget.themeData!.colorScheme.onErrorContainer),
                ),
                trailing: ColorIndicator(
                  hasBorder: true,
                  width: 44,
                  height: 44,
                  borderRadius: 4,
                  color: widget.themeData!.colorScheme.onErrorContainer,
                  onSelectFocus: false,
                  onSelect: () async {
                    // Store current color before we open the dialog.
                    final Color colorBeforeDialog =
                        widget.themeData!.colorScheme.onErrorContainer;
                    // Wait for the picker to close, if dialog was dismissed,
                    // then restore the color we had before it was opened.
                    Color newColor = await colorPickerDialog(
                        widget.themeData!.colorScheme.onErrorContainer);
                    if (newColor != colorBeforeDialog) {
                      setState(() {
                        ThemeData newTheme = ThemeData(
                          colorScheme: widget.themeData!.colorScheme.copyWith(
                            onErrorContainer: newColor,
                          ),
                        );
                        widget.themeData = newTheme;
                      });
                    }

                    if (!areThemesEqual(
                        widget.themeData!, widget.originalTheme)) {
                      widget.unsavedChanges = true;
                    } else {
                      widget.unsavedChanges = false;
                    }
                  },
                ),
              ),
              ListTile(
                title: const Text('Outline'),
                subtitle: Text(
                  ColorTools.nameThatColor(
                      widget.themeData!.colorScheme.outline),
                ),
                trailing: ColorIndicator(
                  hasBorder: true,
                  width: 44,
                  height: 44,
                  borderRadius: 4,
                  color: widget.themeData!.colorScheme.outline,
                  onSelectFocus: false,
                  onSelect: () async {
                    // Store current color before we open the dialog.
                    final Color colorBeforeDialog =
                        widget.themeData!.colorScheme.outline;
                    // Wait for the picker to close, if dialog was dismissed,
                    // then restore the color we had before it was opened.
                    Color newColor = await colorPickerDialog(
                        widget.themeData!.colorScheme.outline);
                    if (newColor != colorBeforeDialog) {
                      setState(() {
                        ThemeData newTheme = ThemeData(
                          colorScheme: widget.themeData!.colorScheme.copyWith(
                            outline: newColor,
                          ),
                        );
                        widget.themeData = newTheme;
                      });
                    }

                    if (!areThemesEqual(
                        widget.themeData!, widget.originalTheme)) {
                      widget.unsavedChanges = true;
                    } else {
                      widget.unsavedChanges = false;
                    }
                  },
                ),
              ),
              ListTile(
                title: const Text('Background'),
                subtitle: Text(
                  ColorTools.nameThatColor(
                      widget.themeData!.colorScheme.background),
                ),
                trailing: ColorIndicator(
                  hasBorder: true,
                  width: 44,
                  height: 44,
                  borderRadius: 4,
                  color: widget.themeData!.colorScheme.background,
                  onSelectFocus: false,
                  onSelect: () async {
                    // Store current color before we open the dialog.
                    final Color colorBeforeDialog =
                        widget.themeData!.colorScheme.background;
                    // Wait for the picker to close, if dialog was dismissed,
                    // then restore the color we had before it was opened.
                    Color newColor = await colorPickerDialog(
                        widget.themeData!.colorScheme.background);
                    if (newColor != colorBeforeDialog) {
                      setState(() {
                        ThemeData newTheme = ThemeData(
                          colorScheme: widget.themeData!.colorScheme.copyWith(
                            background: newColor,
                          ),
                        );
                        widget.themeData = newTheme;
                      });
                    }

                    if (!areThemesEqual(
                        widget.themeData!, widget.originalTheme)) {
                      widget.unsavedChanges = true;
                    } else {
                      widget.unsavedChanges = false;
                    }
                  },
                ),
              ),
              ListTile(
                title: const Text('On Background'),
                subtitle: Text(
                  ColorTools.nameThatColor(
                      widget.themeData!.colorScheme.onBackground),
                ),
                trailing: ColorIndicator(
                  hasBorder: true,
                  width: 44,
                  height: 44,
                  borderRadius: 4,
                  color: widget.themeData!.colorScheme.onBackground,
                  onSelectFocus: false,
                  onSelect: () async {
                    // Store current color before we open the dialog.
                    final Color colorBeforeDialog =
                        widget.themeData!.colorScheme.onBackground;
                    // Wait for the picker to close, if dialog was dismissed,
                    // then restore the color we had before it was opened.
                    Color newColor = await colorPickerDialog(
                        widget.themeData!.colorScheme.onBackground);
                    if (newColor != colorBeforeDialog) {
                      setState(() {
                        ThemeData newTheme = ThemeData(
                          colorScheme: widget.themeData!.colorScheme.copyWith(
                            onBackground: newColor,
                          ),
                        );
                        widget.themeData = newTheme;
                      });
                    }

                    if (!areThemesEqual(
                        widget.themeData!, widget.originalTheme)) {
                      widget.unsavedChanges = true;
                    } else {
                      widget.unsavedChanges = false;
                    }
                  },
                ),
              ),
              ListTile(
                title: const Text('Surface'),
                subtitle: Text(
                  ColorTools.nameThatColor(
                      widget.themeData!.colorScheme.surface),
                ),
                trailing: ColorIndicator(
                  hasBorder: true,
                  width: 44,
                  height: 44,
                  borderRadius: 4,
                  color: widget.themeData!.colorScheme.surface,
                  onSelectFocus: false,
                  onSelect: () async {
                    // Store current color before we open the dialog.
                    final Color colorBeforeDialog =
                        widget.themeData!.colorScheme.surface;
                    // Wait for the picker to close, if dialog was dismissed,
                    // then restore the color we had before it was opened.
                    Color newColor = await colorPickerDialog(
                        widget.themeData!.colorScheme.surface);
                    if (newColor != colorBeforeDialog) {
                      setState(() {
                        ThemeData newTheme = ThemeData(
                          colorScheme: widget.themeData!.colorScheme.copyWith(
                            surface: newColor,
                          ),
                        );
                        widget.themeData = newTheme;
                      });
                    }

                    if (!areThemesEqual(
                        widget.themeData!, widget.originalTheme)) {
                      widget.unsavedChanges = true;
                    } else {
                      widget.unsavedChanges = false;
                    }
                  },
                ),
              ),
              ListTile(
                title: const Text('On Surface'),
                subtitle: Text(
                  ColorTools.nameThatColor(
                      widget.themeData!.colorScheme.onSurface),
                ),
                trailing: ColorIndicator(
                  hasBorder: true,
                  width: 44,
                  height: 44,
                  borderRadius: 4,
                  color: widget.themeData!.colorScheme.onSurface,
                  onSelectFocus: false,
                  onSelect: () async {
                    // Store current color before we open the dialog.
                    final Color colorBeforeDialog =
                        widget.themeData!.colorScheme.onSurface;
                    // Wait for the picker to close, if dialog was dismissed,
                    // then restore the color we had before it was opened.
                    Color newColor = await colorPickerDialog(
                        widget.themeData!.colorScheme.onSurface);
                    if (newColor != colorBeforeDialog) {
                      setState(() {
                        ThemeData newTheme = ThemeData(
                          colorScheme: widget.themeData!.colorScheme.copyWith(
                            onSurface: newColor,
                          ),
                        );
                        widget.themeData = newTheme;
                      });
                    }

                    if (!areThemesEqual(
                        widget.themeData!, widget.originalTheme)) {
                      widget.unsavedChanges = true;
                    } else {
                      widget.unsavedChanges = false;
                    }
                  },
                ),
              ),
              ListTile(
                title: const Text('Surface Variant'),
                subtitle: Text(
                  ColorTools.nameThatColor(
                      widget.themeData!.colorScheme.surfaceVariant),
                ),
                trailing: ColorIndicator(
                  hasBorder: true,
                  width: 44,
                  height: 44,
                  borderRadius: 4,
                  color: widget.themeData!.colorScheme.surfaceVariant,
                  onSelectFocus: false,
                  onSelect: () async {
                    // Store current color before we open the dialog.
                    final Color colorBeforeDialog =
                        widget.themeData!.colorScheme.surfaceVariant;
                    // Wait for the picker to close, if dialog was dismissed,
                    // then restore the color we had before it was opened.
                    Color newColor = await colorPickerDialog(
                        widget.themeData!.colorScheme.surfaceVariant);
                    if (newColor != colorBeforeDialog) {
                      setState(() {
                        ThemeData newTheme = ThemeData(
                          colorScheme: widget.themeData!.colorScheme.copyWith(
                            surfaceVariant: newColor,
                          ),
                        );
                        widget.themeData = newTheme;
                      });
                    }

                    if (!areThemesEqual(
                        widget.themeData!, widget.originalTheme)) {
                      widget.unsavedChanges = true;
                    } else {
                      widget.unsavedChanges = false;
                    }
                  },
                ),
              ),
              ListTile(
                title: const Text('On Surface Variant'),
                subtitle: Text(
                  ColorTools.nameThatColor(
                      widget.themeData!.colorScheme.onSurfaceVariant),
                ),
                trailing: ColorIndicator(
                  hasBorder: true,
                  width: 44,
                  height: 44,
                  borderRadius: 4,
                  color: widget.themeData!.colorScheme.onSurfaceVariant,
                  onSelectFocus: false,
                  onSelect: () async {
                    // Store current color before we open the dialog.
                    final Color colorBeforeDialog =
                        widget.themeData!.colorScheme.onSurfaceVariant;
                    // Wait for the picker to close, if dialog was dismissed,
                    // then restore the color we had before it was opened.
                    Color newColor = await colorPickerDialog(
                        widget.themeData!.colorScheme.onSurfaceVariant);
                    if (newColor != colorBeforeDialog) {
                      setState(() {
                        ThemeData newTheme = ThemeData(
                          colorScheme: widget.themeData!.colorScheme.copyWith(
                            onSurfaceVariant: newColor,
                          ),
                        );
                        widget.themeData = newTheme;
                      });
                    }

                    if (!areThemesEqual(
                        widget.themeData!, widget.originalTheme)) {
                      widget.unsavedChanges = true;
                    } else {
                      widget.unsavedChanges = false;
                    }
                  },
                ),
              ),
              ListTile(
                title: const Text('Inverse Surface'),
                subtitle: Text(
                  ColorTools.nameThatColor(
                      widget.themeData!.colorScheme.inverseSurface),
                ),
                trailing: ColorIndicator(
                  hasBorder: true,
                  width: 44,
                  height: 44,
                  borderRadius: 4,
                  color: widget.themeData!.colorScheme.inverseSurface,
                  onSelectFocus: false,
                  onSelect: () async {
                    // Store current color before we open the dialog.
                    final Color colorBeforeDialog =
                        widget.themeData!.colorScheme.inverseSurface;
                    // Wait for the picker to close, if dialog was dismissed,
                    // then restore the color we had before it was opened.
                    Color newColor = await colorPickerDialog(
                        widget.themeData!.colorScheme.inverseSurface);
                    if (newColor != colorBeforeDialog) {
                      setState(() {
                        ThemeData newTheme = ThemeData(
                          colorScheme: widget.themeData!.colorScheme.copyWith(
                            inverseSurface: newColor,
                          ),
                        );
                        widget.themeData = newTheme;
                      });
                    }

                    if (!areThemesEqual(
                        widget.themeData!, widget.originalTheme)) {
                      widget.unsavedChanges = true;
                    } else {
                      widget.unsavedChanges = false;
                    }
                  },
                ),
              ),
              ListTile(
                title: const Text('On Inverse Surface'),
                subtitle: Text(
                  ColorTools.nameThatColor(
                      widget.themeData!.colorScheme.onInverseSurface),
                ),
                trailing: ColorIndicator(
                  hasBorder: true,
                  width: 44,
                  height: 44,
                  borderRadius: 4,
                  color: widget.themeData!.colorScheme.onInverseSurface,
                  onSelectFocus: false,
                  onSelect: () async {
                    // Store current color before we open the dialog.
                    final Color colorBeforeDialog =
                        widget.themeData!.colorScheme.onInverseSurface;
                    // Wait for the picker to close, if dialog was dismissed,
                    // then restore the color we had before it was opened.
                    Color newColor = await colorPickerDialog(
                        widget.themeData!.colorScheme.onInverseSurface);
                    if (newColor != colorBeforeDialog) {
                      setState(() {
                        ThemeData newTheme = ThemeData(
                          colorScheme: widget.themeData!.colorScheme.copyWith(
                            onInverseSurface: newColor,
                          ),
                        );
                        widget.themeData = newTheme;
                      });
                    }

                    if (!areThemesEqual(
                        widget.themeData!, widget.originalTheme)) {
                      widget.unsavedChanges = true;
                    } else {
                      widget.unsavedChanges = false;
                    }
                  },
                ),
              ),
              ListTile(
                title: const Text('Inverse Primary'),
                subtitle: Text(
                  ColorTools.nameThatColor(
                      widget.themeData!.colorScheme.inversePrimary),
                ),
                trailing: ColorIndicator(
                  hasBorder: true,
                  width: 44,
                  height: 44,
                  borderRadius: 4,
                  color: widget.themeData!.colorScheme.inversePrimary,
                  onSelectFocus: false,
                  onSelect: () async {
                    // Store current color before we open the dialog.
                    final Color colorBeforeDialog =
                        widget.themeData!.colorScheme.inversePrimary;
                    // Wait for the picker to close, if dialog was dismissed,
                    // then restore the color we had before it was opened.
                    Color newColor = await colorPickerDialog(
                        widget.themeData!.colorScheme.inversePrimary);
                    if (newColor != colorBeforeDialog) {
                      setState(() {
                        ThemeData newTheme = ThemeData(
                          colorScheme: widget.themeData!.colorScheme.copyWith(
                            inversePrimary: newColor,
                          ),
                        );
                        widget.themeData = newTheme;
                      });
                    }

                    if (!areThemesEqual(
                        widget.themeData!, widget.originalTheme)) {
                      widget.unsavedChanges = true;
                    } else {
                      widget.unsavedChanges = false;
                    }
                  },
                ),
              ),
              ListTile(
                title: const Text('Shadow'),
                subtitle: Text(
                  ColorTools.nameThatColor(widget.themeData!.shadowColor),
                ),
                trailing: ColorIndicator(
                  hasBorder: true,
                  width: 44,
                  height: 44,
                  borderRadius: 4,
                  color: widget.themeData!.shadowColor,
                  onSelectFocus: false,
                  onSelect: () async {
                    // Store current color before we open the dialog.
                    final Color colorBeforeDialog =
                        widget.themeData!.shadowColor;
                    // Wait for the picker to close, if dialog was dismissed,
                    // then restore the color we had before it was opened.
                    Color newColor =
                        await colorPickerDialog(widget.themeData!.shadowColor);
                    if (newColor != colorBeforeDialog) {
                      setState(() {
                        ThemeData newTheme = widget.themeData!.copyWith(
                          shadowColor: newColor,
                        );
                        widget.themeData = newTheme;
                      });
                    }

                    if (!areThemesEqual(
                        widget.themeData!, widget.originalTheme)) {
                      widget.unsavedChanges = true;
                    } else {
                      widget.unsavedChanges = false;
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
