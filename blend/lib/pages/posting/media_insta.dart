import 'package:flutter/material.dart';
import 'package:blend/components/imageProcessing/insta_picker_interface.dart';

const _kMultiplePickerMax = 4;

class MultiplePicker extends StatelessWidget with InstaPickerInterface {
  const MultiplePicker({super.key});

  @override
  PickerDescription get description => const PickerDescription(
        icon: '📷',
        label: 'Select Media',
        description:
            'Picker for selecting multiple images (max $_kMultiplePickerMax).',
      );

  @override
  Widget build(BuildContext context) => buildLayout(
        context,
        onPressed: () => pickAssets(context, maxAssets: _kMultiplePickerMax),
      );
}
