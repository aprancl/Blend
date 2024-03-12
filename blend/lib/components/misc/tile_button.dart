import 'package:flutter/material.dart';
import 'package:blend/global_provider.dart';
import 'package:provider/provider.dart';

class TileButton extends StatelessWidget {
  final String title;
  final Function() onTap;
  final Icon? icon;
  final bool useDivider;
  const TileButton(
      {super.key,
      required this.title,
      required this.onTap,
      this.icon,
      this.useDivider = true});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GlobalProvider>(context);

    return Container(
      child: Column(
        children: [
          // divider
          if (useDivider)
            Divider(
              color: provider.theme.dividerColor,
              thickness: 1,
            ),
          // account linking
          ListTile(
            title: Text(title),
            trailing: icon,
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}
