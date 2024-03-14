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
import 'package:flex_color_scheme/flex_color_scheme.dart';
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
              ElevatedButton(
                onPressed: (widget.unsavedChanges)
                    ? null
                    : () async {
                        // Save changes to the database
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(provider.getAuthUser()!.uid)
                            .update({
                          'customTheme': {
                            'brightness':
                                '0x${provider.theme.colorScheme.brightness.toString()}',
                            'primary':
                                '0x${provider.theme.colorScheme.primary.hexCode}',
                            'onPrimary':
                                '0x${provider.theme.colorScheme.onPrimary.hexCode}',
                            'primaryContainer':
                                '0x${provider.theme.colorScheme.primaryContainer.hexCode}',
                            'onPrimaryContainer':
                                '0x${provider.theme.colorScheme.onPrimaryContainer.hexCode}',
                            'secondary':
                                '0x${provider.theme.colorScheme.secondary.hexCode}',
                            'onSecondary':
                                '0x${provider.theme.colorScheme.onSecondary.hexCode}',
                            'secondaryContainer':
                                '0x${provider.theme.colorScheme.secondaryContainer.hexCode}',
                            'onSecondaryContainer':
                                '0x${provider.theme.colorScheme.onSecondaryContainer.hexCode}',
                            'tertiary':
                                '0x${provider.theme.colorScheme.tertiary.hexCode}',
                            'onTertiary':
                                '0x${provider.theme.colorScheme.onTertiary.hexCode}',
                            'tertiaryContainer':
                                '0x${provider.theme.colorScheme.tertiaryContainer.hexCode}',
                            'onTertiaryContainer':
                                '0x${provider.theme.colorScheme.onTertiaryContainer.hexCode}',
                            'error':
                                '0x${provider.theme.colorScheme.error.hexCode}',
                            'onError':
                                '0x${provider.theme.colorScheme.onError.hexCode}',
                            'errorContainer':
                                '0x${provider.theme.colorScheme.errorContainer.hexCode}',
                            'onErrorContainer':
                                '0x${provider.theme.colorScheme.onErrorContainer.hexCode}',
                            'outline':
                                '0x${provider.theme.colorScheme.outline.hexCode}',
                            'background':
                                '0x${provider.theme.colorScheme.background.hexCode}',
                            'onBackground':
                                '0x${provider.theme.colorScheme.onBackground.hexCode}',
                            'surface':
                                '0x${provider.theme.colorScheme.surface.hexCode}',
                            'onSurface':
                                '0x${provider.theme.colorScheme.onSurface.hexCode}',
                            'surfaceVariant':
                                '0x${provider.theme.colorScheme.surfaceVariant.hexCode}',
                            'onSurfaceVariant':
                                '0x${provider.theme.colorScheme.onSurfaceVariant.hexCode}',
                            'inverseSurface':
                                '0x${provider.theme.colorScheme.inverseSurface.hexCode}',
                            'onInverseSurface':
                                '0x${provider.theme.colorScheme.onInverseSurface.hexCode}',
                            'inversePrimary':
                                '0x${provider.theme.colorScheme.inversePrimary.hexCode}',
                            'shadow':
                                '0x${provider.theme.colorScheme.shadow.hexCode}',
                          },
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
                  ColorTools.nameThatColor(provider.theme.colorScheme.primary),
                ),
                trailing: ColorIndicator(
                  hasBorder: true,
                  width: 44,
                  height: 44,
                  borderRadius: 4,
                  color: provider.theme.colorScheme.primary,
                  onSelectFocus: false,
                  onSelect: () async {
                    // Store current color before we open the dialog.
                    final Color colorBeforeDialog =
                        provider.theme.colorScheme.primary;
                    // Wait for the picker to close, if dialog was dismissed,
                    // then restore the color we had before it was opened.
                    Color newColor = await colorPickerDialog(
                        provider.theme.colorScheme.primary);
                    if (newColor != colorBeforeDialog) {
                      setState(() {
                        ThemeData newTheme = ThemeData(
                          colorScheme: provider.theme.colorScheme.copyWith(
                            primary: newColor,
                          ),
                        );
                        provider.setTheme(newTheme);
                      });
                    }

                    if (!areThemesEqual(provider.theme, widget.originalTheme)) {
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
                      provider.theme.colorScheme.onPrimary),
                ),
                trailing: ColorIndicator(
                  hasBorder: true,
                  width: 44,
                  height: 44,
                  borderRadius: 4,
                  color: provider.theme.colorScheme.onPrimary,
                  onSelectFocus: false,
                  onSelect: () async {
                    // Store current color before we open the dialog.
                    final Color colorBeforeDialog =
                        provider.theme.colorScheme.onPrimary;
                    // Wait for the picker to close, if dialog was dismissed,
                    // then restore the color we had before it was opened.
                    Color newColor = await colorPickerDialog(
                        provider.theme.colorScheme.onPrimary);
                    if (newColor != colorBeforeDialog) {
                      setState(() {
                        ThemeData newTheme = ThemeData(
                          colorScheme: provider.theme.colorScheme.copyWith(
                            onPrimary: newColor,
                          ),
                        );
                        provider.setTheme(newTheme);
                      });
                    }

                    if (!areThemesEqual(provider.theme, widget.originalTheme)) {
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
                      provider.theme.colorScheme.primaryContainer),
                ),
                trailing: ColorIndicator(
                  hasBorder: true,
                  width: 44,
                  height: 44,
                  borderRadius: 4,
                  color: provider.theme.colorScheme.primaryContainer,
                  onSelectFocus: false,
                  onSelect: () async {
                    // Store current color before we open the dialog.
                    final Color colorBeforeDialog =
                        provider.theme.colorScheme.primaryContainer;
                    // Wait for the picker to close, if dialog was dismissed,
                    // then restore the color we had before it was opened.
                    Color newColor = await colorPickerDialog(
                        provider.theme.colorScheme.primaryContainer);
                    if (newColor != colorBeforeDialog) {
                      setState(() {
                        ThemeData newTheme = ThemeData(
                          colorScheme: provider.theme.colorScheme.copyWith(
                            primaryContainer: newColor,
                          ),
                        );
                        provider.setTheme(newTheme);
                      });
                    }

                    if (!areThemesEqual(provider.theme, widget.originalTheme)) {
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
                      provider.theme.colorScheme.onPrimaryContainer),
                ),
                trailing: ColorIndicator(
                  hasBorder: true,
                  width: 44,
                  height: 44,
                  borderRadius: 4,
                  color: provider.theme.colorScheme.onPrimaryContainer,
                  onSelectFocus: false,
                  onSelect: () async {
                    // Store current color before we open the dialog.
                    final Color colorBeforeDialog =
                        provider.theme.colorScheme.onPrimaryContainer;
                    // Wait for the picker to close, if dialog was dismissed,
                    // then restore the color we had before it was opened.
                    Color newColor = await colorPickerDialog(
                        provider.theme.colorScheme.onPrimaryContainer);
                    if (newColor != colorBeforeDialog) {
                      setState(() {
                        ThemeData newTheme = ThemeData(
                          colorScheme: provider.theme.colorScheme.copyWith(
                            onPrimaryContainer: newColor,
                          ),
                        );
                        provider.setTheme(newTheme);
                      });
                    }

                    if (!areThemesEqual(provider.theme, widget.originalTheme)) {
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
                      provider.theme.colorScheme.secondary),
                ),
                trailing: ColorIndicator(
                  hasBorder: true,
                  width: 44,
                  height: 44,
                  borderRadius: 4,
                  color: provider.theme.colorScheme.secondary,
                  onSelectFocus: false,
                  onSelect: () async {
                    // Store current color before we open the dialog.
                    final Color colorBeforeDialog =
                        provider.theme.colorScheme.secondary;
                    // Wait for the picker to close, if dialog was dismissed,
                    // then restore the color we had before it was opened.
                    Color newColor = await colorPickerDialog(
                        provider.theme.colorScheme.secondary);
                    if (newColor != colorBeforeDialog) {
                      setState(() {
                        ThemeData newTheme = ThemeData(
                          colorScheme: provider.theme.colorScheme.copyWith(
                            secondary: newColor,
                          ),
                        );
                        provider.setTheme(newTheme);
                      });
                    }

                    if (!areThemesEqual(provider.theme, widget.originalTheme)) {
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
                      provider.theme.colorScheme.onSecondary),
                ),
                trailing: ColorIndicator(
                  hasBorder: true,
                  width: 44,
                  height: 44,
                  borderRadius: 4,
                  color: provider.theme.colorScheme.onSecondary,
                  onSelectFocus: false,
                  onSelect: () async {
                    // Store current color before we open the dialog.
                    final Color colorBeforeDialog =
                        provider.theme.colorScheme.onSecondary;
                    // Wait for the picker to close, if dialog was dismissed,
                    // then restore the color we had before it was opened.
                    Color newColor = await colorPickerDialog(
                        provider.theme.colorScheme.onSecondary);
                    if (newColor != colorBeforeDialog) {
                      setState(() {
                        ThemeData newTheme = ThemeData(
                          colorScheme: provider.theme.colorScheme.copyWith(
                            onSecondary: newColor,
                          ),
                        );
                        provider.setTheme(newTheme);
                      });
                    }

                    if (!areThemesEqual(provider.theme, widget.originalTheme)) {
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
                      provider.theme.colorScheme.secondaryContainer),
                ),
                trailing: ColorIndicator(
                  hasBorder: true,
                  width: 44,
                  height: 44,
                  borderRadius: 4,
                  color: provider.theme.colorScheme.secondaryContainer,
                  onSelectFocus: false,
                  onSelect: () async {
                    // Store current color before we open the dialog.
                    final Color colorBeforeDialog =
                        provider.theme.colorScheme.secondaryContainer;
                    // Wait for the picker to close, if dialog was dismissed,
                    // then restore the color we had before it was opened.
                    Color newColor = await colorPickerDialog(
                        provider.theme.colorScheme.secondaryContainer);
                    if (newColor != colorBeforeDialog) {
                      setState(() {
                        ThemeData newTheme = ThemeData(
                          colorScheme: provider.theme.colorScheme.copyWith(
                            secondaryContainer: newColor,
                          ),
                        );
                        provider.setTheme(newTheme);
                      });
                    }

                    if (!areThemesEqual(provider.theme, widget.originalTheme)) {
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
                      provider.theme.colorScheme.onSecondaryContainer),
                ),
                trailing: ColorIndicator(
                  hasBorder: true,
                  width: 44,
                  height: 44,
                  borderRadius: 4,
                  color: provider.theme.colorScheme.onSecondaryContainer,
                  onSelectFocus: false,
                  onSelect: () async {
                    // Store current color before we open the dialog.
                    final Color colorBeforeDialog =
                        provider.theme.colorScheme.onSecondaryContainer;
                    // Wait for the picker to close, if dialog was dismissed,
                    // then restore the color we had before it was opened.
                    Color newColor = await colorPickerDialog(
                        provider.theme.colorScheme.onSecondaryContainer);
                    if (newColor != colorBeforeDialog) {
                      setState(() {
                        ThemeData newTheme = ThemeData(
                          colorScheme: provider.theme.colorScheme.copyWith(
                            onSecondaryContainer: newColor,
                          ),
                        );
                        provider.setTheme(newTheme);
                      });
                    }

                    if (!areThemesEqual(provider.theme, widget.originalTheme)) {
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
                  ColorTools.nameThatColor(provider.theme.colorScheme.tertiary),
                ),
                trailing: ColorIndicator(
                  hasBorder: true,
                  width: 44,
                  height: 44,
                  borderRadius: 4,
                  color: provider.theme.colorScheme.tertiary,
                  onSelectFocus: false,
                  onSelect: () async {
                    // Store current color before we open the dialog.
                    final Color colorBeforeDialog =
                        provider.theme.colorScheme.tertiary;
                    // Wait for the picker to close, if dialog was dismissed,
                    // then restore the color we had before it was opened.
                    Color newColor = await colorPickerDialog(
                        provider.theme.colorScheme.tertiary);
                    if (newColor != colorBeforeDialog) {
                      setState(() {
                        ThemeData newTheme = ThemeData(
                          colorScheme: provider.theme.colorScheme.copyWith(
                            tertiary: newColor,
                          ),
                        );
                        provider.setTheme(newTheme);
                      });
                    }

                    if (!areThemesEqual(provider.theme, widget.originalTheme)) {
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
                      provider.theme.colorScheme.onTertiary),
                ),
                trailing: ColorIndicator(
                  hasBorder: true,
                  width: 44,
                  height: 44,
                  borderRadius: 4,
                  color: provider.theme.colorScheme.onTertiary,
                  onSelectFocus: false,
                  onSelect: () async {
                    // Store current color before we open the dialog.
                    final Color colorBeforeDialog =
                        provider.theme.colorScheme.onTertiary;
                    // Wait for the picker to close, if dialog was dismissed,
                    // then restore the color we had before it was opened.
                    Color newColor = await colorPickerDialog(
                        provider.theme.colorScheme.onTertiary);
                    if (newColor != colorBeforeDialog) {
                      setState(() {
                        ThemeData newTheme = ThemeData(
                          colorScheme: provider.theme.colorScheme.copyWith(
                            onTertiary: newColor,
                          ),
                        );
                        provider.setTheme(newTheme);
                      });
                    }

                    if (!areThemesEqual(provider.theme, widget.originalTheme)) {
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
                      provider.theme.colorScheme.tertiaryContainer),
                ),
                trailing: ColorIndicator(
                  hasBorder: true,
                  width: 44,
                  height: 44,
                  borderRadius: 4,
                  color: provider.theme.colorScheme.tertiaryContainer,
                  onSelectFocus: false,
                  onSelect: () async {
                    // Store current color before we open the dialog.
                    final Color colorBeforeDialog =
                        provider.theme.colorScheme.tertiaryContainer;
                    // Wait for the picker to close, if dialog was dismissed,
                    // then restore the color we had before it was opened.
                    Color newColor = await colorPickerDialog(
                        provider.theme.colorScheme.tertiaryContainer);
                    if (newColor != colorBeforeDialog) {
                      setState(() {
                        ThemeData newTheme = ThemeData(
                          colorScheme: provider.theme.colorScheme.copyWith(
                            tertiaryContainer: newColor,
                          ),
                        );
                        provider.setTheme(newTheme);
                      });
                    }

                    if (!areThemesEqual(provider.theme, widget.originalTheme)) {
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
                      provider.theme.colorScheme.onTertiaryContainer),
                ),
                trailing: ColorIndicator(
                  hasBorder: true,
                  width: 44,
                  height: 44,
                  borderRadius: 4,
                  color: provider.theme.colorScheme.onTertiaryContainer,
                  onSelectFocus: false,
                  onSelect: () async {
                    // Store current color before we open the dialog.
                    final Color colorBeforeDialog =
                        provider.theme.colorScheme.onTertiaryContainer;
                    // Wait for the picker to close, if dialog was dismissed,
                    // then restore the color we had before it was opened.
                    Color newColor = await colorPickerDialog(
                        provider.theme.colorScheme.onTertiaryContainer);
                    if (newColor != colorBeforeDialog) {
                      setState(() {
                        ThemeData newTheme = ThemeData(
                          colorScheme: provider.theme.colorScheme.copyWith(
                            onTertiaryContainer: newColor,
                          ),
                        );
                        provider.setTheme(newTheme);
                      });
                    }

                    if (!areThemesEqual(provider.theme, widget.originalTheme)) {
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
                  ColorTools.nameThatColor(provider.theme.colorScheme.error),
                ),
                trailing: ColorIndicator(
                  hasBorder: true,
                  width: 44,
                  height: 44,
                  borderRadius: 4,
                  color: provider.theme.colorScheme.error,
                  onSelectFocus: false,
                  onSelect: () async {
                    // Store current color before we open the dialog.
                    final Color colorBeforeDialog =
                        provider.theme.colorScheme.error;
                    // Wait for the picker to close, if dialog was dismissed,
                    // then restore the color we had before it was opened.
                    Color newColor = await colorPickerDialog(
                        provider.theme.colorScheme.error);
                    if (newColor != colorBeforeDialog) {
                      setState(() {
                        ThemeData newTheme = ThemeData(
                          colorScheme: provider.theme.colorScheme.copyWith(
                            error: newColor,
                          ),
                        );
                        provider.setTheme(newTheme);
                      });
                    }

                    if (!areThemesEqual(provider.theme, widget.originalTheme)) {
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
                  ColorTools.nameThatColor(provider.theme.colorScheme.onError),
                ),
                trailing: ColorIndicator(
                  hasBorder: true,
                  width: 44,
                  height: 44,
                  borderRadius: 4,
                  color: provider.theme.colorScheme.onError,
                  onSelectFocus: false,
                  onSelect: () async {
                    // Store current color before we open the dialog.
                    final Color colorBeforeDialog =
                        provider.theme.colorScheme.onError;
                    // Wait for the picker to close, if dialog was dismissed,
                    // then restore the color we had before it was opened.
                    Color newColor = await colorPickerDialog(
                        provider.theme.colorScheme.onError);
                    if (newColor != colorBeforeDialog) {
                      setState(() {
                        ThemeData newTheme = ThemeData(
                          colorScheme: provider.theme.colorScheme.copyWith(
                            onError: newColor,
                          ),
                        );
                        provider.setTheme(newTheme);
                      });
                    }

                    if (!areThemesEqual(provider.theme, widget.originalTheme)) {
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
                      provider.theme.colorScheme.errorContainer),
                ),
                trailing: ColorIndicator(
                  hasBorder: true,
                  width: 44,
                  height: 44,
                  borderRadius: 4,
                  color: provider.theme.colorScheme.errorContainer,
                  onSelectFocus: false,
                  onSelect: () async {
                    // Store current color before we open the dialog.
                    final Color colorBeforeDialog =
                        provider.theme.colorScheme.errorContainer;
                    // Wait for the picker to close, if dialog was dismissed,
                    // then restore the color we had before it was opened.
                    Color newColor = await colorPickerDialog(
                        provider.theme.colorScheme.errorContainer);
                    if (newColor != colorBeforeDialog) {
                      setState(() {
                        ThemeData newTheme = ThemeData(
                          colorScheme: provider.theme.colorScheme.copyWith(
                            errorContainer: newColor,
                          ),
                        );
                        provider.setTheme(newTheme);
                      });
                    }

                    if (!areThemesEqual(provider.theme, widget.originalTheme)) {
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
                      provider.theme.colorScheme.onErrorContainer),
                ),
                trailing: ColorIndicator(
                  hasBorder: true,
                  width: 44,
                  height: 44,
                  borderRadius: 4,
                  color: provider.theme.colorScheme.onErrorContainer,
                  onSelectFocus: false,
                  onSelect: () async {
                    // Store current color before we open the dialog.
                    final Color colorBeforeDialog =
                        provider.theme.colorScheme.onErrorContainer;
                    // Wait for the picker to close, if dialog was dismissed,
                    // then restore the color we had before it was opened.
                    Color newColor = await colorPickerDialog(
                        provider.theme.colorScheme.onErrorContainer);
                    if (newColor != colorBeforeDialog) {
                      setState(() {
                        ThemeData newTheme = ThemeData(
                          colorScheme: provider.theme.colorScheme.copyWith(
                            onErrorContainer: newColor,
                          ),
                        );
                        provider.setTheme(newTheme);
                      });
                    }

                    if (!areThemesEqual(provider.theme, widget.originalTheme)) {
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
                  ColorTools.nameThatColor(provider.theme.colorScheme.outline),
                ),
                trailing: ColorIndicator(
                  hasBorder: true,
                  width: 44,
                  height: 44,
                  borderRadius: 4,
                  color: provider.theme.colorScheme.outline,
                  onSelectFocus: false,
                  onSelect: () async {
                    // Store current color before we open the dialog.
                    final Color colorBeforeDialog =
                        provider.theme.colorScheme.outline;
                    // Wait for the picker to close, if dialog was dismissed,
                    // then restore the color we had before it was opened.
                    Color newColor = await colorPickerDialog(
                        provider.theme.colorScheme.outline);
                    if (newColor != colorBeforeDialog) {
                      setState(() {
                        ThemeData newTheme = ThemeData(
                          colorScheme: provider.theme.colorScheme.copyWith(
                            outline: newColor,
                          ),
                        );
                        provider.setTheme(newTheme);
                      });
                    }

                    if (!areThemesEqual(provider.theme, widget.originalTheme)) {
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
                      provider.theme.colorScheme.background),
                ),
                trailing: ColorIndicator(
                  hasBorder: true,
                  width: 44,
                  height: 44,
                  borderRadius: 4,
                  color: provider.theme.colorScheme.background,
                  onSelectFocus: false,
                  onSelect: () async {
                    // Store current color before we open the dialog.
                    final Color colorBeforeDialog =
                        provider.theme.colorScheme.background;
                    // Wait for the picker to close, if dialog was dismissed,
                    // then restore the color we had before it was opened.
                    Color newColor = await colorPickerDialog(
                        provider.theme.colorScheme.background);
                    if (newColor != colorBeforeDialog) {
                      setState(() {
                        ThemeData newTheme = ThemeData(
                          colorScheme: provider.theme.colorScheme.copyWith(
                            background: newColor,
                          ),
                        );
                        provider.setTheme(newTheme);
                      });
                    }

                    if (!areThemesEqual(provider.theme, widget.originalTheme)) {
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
                      provider.theme.colorScheme.onBackground),
                ),
                trailing: ColorIndicator(
                  hasBorder: true,
                  width: 44,
                  height: 44,
                  borderRadius: 4,
                  color: provider.theme.colorScheme.onBackground,
                  onSelectFocus: false,
                  onSelect: () async {
                    // Store current color before we open the dialog.
                    final Color colorBeforeDialog =
                        provider.theme.colorScheme.onBackground;
                    // Wait for the picker to close, if dialog was dismissed,
                    // then restore the color we had before it was opened.
                    Color newColor = await colorPickerDialog(
                        provider.theme.colorScheme.onBackground);
                    if (newColor != colorBeforeDialog) {
                      setState(() {
                        ThemeData newTheme = ThemeData(
                          colorScheme: provider.theme.colorScheme.copyWith(
                            onBackground: newColor,
                          ),
                        );
                        provider.setTheme(newTheme);
                      });
                    }

                    if (!areThemesEqual(provider.theme, widget.originalTheme)) {
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
                  ColorTools.nameThatColor(provider.theme.colorScheme.surface),
                ),
                trailing: ColorIndicator(
                  hasBorder: true,
                  width: 44,
                  height: 44,
                  borderRadius: 4,
                  color: provider.theme.colorScheme.surface,
                  onSelectFocus: false,
                  onSelect: () async {
                    // Store current color before we open the dialog.
                    final Color colorBeforeDialog =
                        provider.theme.colorScheme.surface;
                    // Wait for the picker to close, if dialog was dismissed,
                    // then restore the color we had before it was opened.
                    Color newColor = await colorPickerDialog(
                        provider.theme.colorScheme.surface);
                    if (newColor != colorBeforeDialog) {
                      setState(() {
                        ThemeData newTheme = ThemeData(
                          colorScheme: provider.theme.colorScheme.copyWith(
                            surface: newColor,
                          ),
                        );
                        provider.setTheme(newTheme);
                      });
                    }

                    if (!areThemesEqual(provider.theme, widget.originalTheme)) {
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
                      provider.theme.colorScheme.onSurface),
                ),
                trailing: ColorIndicator(
                  hasBorder: true,
                  width: 44,
                  height: 44,
                  borderRadius: 4,
                  color: provider.theme.colorScheme.onSurface,
                  onSelectFocus: false,
                  onSelect: () async {
                    // Store current color before we open the dialog.
                    final Color colorBeforeDialog =
                        provider.theme.colorScheme.onSurface;
                    // Wait for the picker to close, if dialog was dismissed,
                    // then restore the color we had before it was opened.
                    Color newColor = await colorPickerDialog(
                        provider.theme.colorScheme.onSurface);
                    if (newColor != colorBeforeDialog) {
                      setState(() {
                        ThemeData newTheme = ThemeData(
                          colorScheme: provider.theme.colorScheme.copyWith(
                            onSurface: newColor,
                          ),
                        );
                        provider.setTheme(newTheme);
                      });
                    }

                    if (!areThemesEqual(provider.theme, widget.originalTheme)) {
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
                      provider.theme.colorScheme.surfaceVariant),
                ),
                trailing: ColorIndicator(
                  hasBorder: true,
                  width: 44,
                  height: 44,
                  borderRadius: 4,
                  color: provider.theme.colorScheme.surfaceVariant,
                  onSelectFocus: false,
                  onSelect: () async {
                    // Store current color before we open the dialog.
                    final Color colorBeforeDialog =
                        provider.theme.colorScheme.surfaceVariant;
                    // Wait for the picker to close, if dialog was dismissed,
                    // then restore the color we had before it was opened.
                    Color newColor = await colorPickerDialog(
                        provider.theme.colorScheme.surfaceVariant);
                    if (newColor != colorBeforeDialog) {
                      setState(() {
                        ThemeData newTheme = ThemeData(
                          colorScheme: provider.theme.colorScheme.copyWith(
                            surfaceVariant: newColor,
                          ),
                        );
                        provider.setTheme(newTheme);
                      });
                    }

                    if (!areThemesEqual(provider.theme, widget.originalTheme)) {
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
                      provider.theme.colorScheme.onSurfaceVariant),
                ),
                trailing: ColorIndicator(
                  hasBorder: true,
                  width: 44,
                  height: 44,
                  borderRadius: 4,
                  color: provider.theme.colorScheme.onSurfaceVariant,
                  onSelectFocus: false,
                  onSelect: () async {
                    // Store current color before we open the dialog.
                    final Color colorBeforeDialog =
                        provider.theme.colorScheme.onSurfaceVariant;
                    // Wait for the picker to close, if dialog was dismissed,
                    // then restore the color we had before it was opened.
                    Color newColor = await colorPickerDialog(
                        provider.theme.colorScheme.onSurfaceVariant);
                    if (newColor != colorBeforeDialog) {
                      setState(() {
                        ThemeData newTheme = ThemeData(
                          colorScheme: provider.theme.colorScheme.copyWith(
                            onSurfaceVariant: newColor,
                          ),
                        );
                        provider.setTheme(newTheme);
                      });
                    }

                    if (!areThemesEqual(provider.theme, widget.originalTheme)) {
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
                      provider.theme.colorScheme.inverseSurface),
                ),
                trailing: ColorIndicator(
                  hasBorder: true,
                  width: 44,
                  height: 44,
                  borderRadius: 4,
                  color: provider.theme.colorScheme.inverseSurface,
                  onSelectFocus: false,
                  onSelect: () async {
                    // Store current color before we open the dialog.
                    final Color colorBeforeDialog =
                        provider.theme.colorScheme.inverseSurface;
                    // Wait for the picker to close, if dialog was dismissed,
                    // then restore the color we had before it was opened.
                    Color newColor = await colorPickerDialog(
                        provider.theme.colorScheme.inverseSurface);
                    if (newColor != colorBeforeDialog) {
                      setState(() {
                        ThemeData newTheme = ThemeData(
                          colorScheme: provider.theme.colorScheme.copyWith(
                            inverseSurface: newColor,
                          ),
                        );
                        provider.setTheme(newTheme);
                      });
                    }

                    if (!areThemesEqual(provider.theme, widget.originalTheme)) {
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
                      provider.theme.colorScheme.inversePrimary),
                ),
                trailing: ColorIndicator(
                  hasBorder: true,
                  width: 44,
                  height: 44,
                  borderRadius: 4,
                  color: provider.theme.colorScheme.inversePrimary,
                  onSelectFocus: false,
                  onSelect: () async {
                    // Store current color before we open the dialog.
                    final Color colorBeforeDialog =
                        provider.theme.colorScheme.inversePrimary;
                    // Wait for the picker to close, if dialog was dismissed,
                    // then restore the color we had before it was opened.
                    Color newColor = await colorPickerDialog(
                        provider.theme.colorScheme.inversePrimary);
                    if (newColor != colorBeforeDialog) {
                      setState(() {
                        ThemeData newTheme = ThemeData(
                          colorScheme: provider.theme.colorScheme.copyWith(
                            inversePrimary: newColor,
                          ),
                        );
                        provider.setTheme(newTheme);
                      });
                    }

                    if (!areThemesEqual(provider.theme, widget.originalTheme)) {
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
                  ColorTools.nameThatColor(provider.theme.colorScheme.shadow),
                ),
                trailing: ColorIndicator(
                  hasBorder: true,
                  width: 44,
                  height: 44,
                  borderRadius: 4,
                  color: provider.theme.colorScheme.shadow,
                  onSelectFocus: false,
                  onSelect: () async {
                    // Store current color before we open the dialog.
                    final Color colorBeforeDialog =
                        provider.theme.colorScheme.shadow;
                    // Wait for the picker to close, if dialog was dismissed,
                    // then restore the color we had before it was opened.
                    Color newColor = await colorPickerDialog(
                        provider.theme.colorScheme.shadow);
                    if (newColor != colorBeforeDialog) {
                      setState(() {
                        ThemeData newTheme = ThemeData(
                          colorScheme: provider.theme.colorScheme.copyWith(
                            shadow: newColor,
                          ),
                        );
                        provider.setTheme(newTheme);
                      });
                    }

                    if (!areThemesEqual(provider.theme, widget.originalTheme)) {
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
