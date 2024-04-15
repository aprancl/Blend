import 'dart:ffi';

import 'package:blend/global_provider.dart';
import 'package:flutter/material.dart';
import 'package:insta_assets_picker/insta_assets_picker.dart';
import 'package:blend/components/imageProcessing/crop_result_view.dart';
// import 'package:insta_assets_picker_demo/main.dart';
import 'package:provider/provider.dart';

class PickerDescription {
  final String icon;
  final String label;
  final String? description;

  const PickerDescription({
    required this.icon,
    required this.label,
    this.description,
  });

  String get fullLabel => '$icon $label';
}

mixin InstaPickerInterface on Widget {
  PickerDescription get description;

  ThemeData getPickerTheme(BuildContext context) {
    return InstaAssetPicker.themeData(Colors.deepPurple).copyWith(
      appBarTheme: const AppBarTheme(titleTextStyle: TextStyle(fontSize: 16)),
    );
  }

  AppBar get _appBar => AppBar(title: Text(description.fullLabel));

  Column pickerColumn({
    required BuildContext context,
    String? text,
    required VoidCallback onPressed,
    required GlobalProvider provider,
  }) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: TextButton(
              onPressed: onPressed,
              child: FittedBox(
                child: Text(
                  'Select media from gallery',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Container(
            margin: EdgeInsets.only(right: 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: Text('Continue'),
                  onPressed: () {
                    print('We want to go next!');
                    provider.goToPage(6);
                  },
                ),
              ],
            ),
          ),
        ],
      );

  Scaffold buildLayout(BuildContext context,
          {required VoidCallback onPressed,
          required GlobalProvider provider}) =>
      Scaffold(
        appBar: _appBar,
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: pickerColumn(
              onPressed: onPressed, context: context, provider: provider),
        ),
      );

  Scaffold buildCustomLayout(
    BuildContext context, {
    required Widget child,
  }) =>
      Scaffold(
        appBar: _appBar,
        body: Padding(padding: const EdgeInsets.all(16), child: child),
      );

  void pickAssets(BuildContext context, {required int maxAssets}) =>
      InstaAssetPicker.pickAssets(
        context,
        title: description.fullLabel,
        closeOnComplete: true,
        maxAssets: maxAssets,
        pickerTheme: getPickerTheme(context),
        onCompleted: (Stream<InstaAssetsExportDetails> cropStream) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PickerCropResultScreen(
                cropStream: cropStream,
                provider: Provider.of<GlobalProvider>(context),
              ),
            ),
          );
        },
      );
}
