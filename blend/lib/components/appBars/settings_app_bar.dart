import 'package:blend/global_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class SettingsAppBar extends StatelessWidget {
  final String settingsRoute;
  final String title;

  const SettingsAppBar({
    super.key,
    required this.settingsRoute,
    required this.title,
  });

  @override
  PreferredSize build(BuildContext context) {
    final provider = Provider.of<GlobalProvider>(context);

    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: AppBar(
        centerTitle: true,
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: <Widget>[
          // gear button
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              print("SETTINGS ROUTE ${settingsRoute}");
              Navigator.pushNamed(context, settingsRoute);
            },
          ),
        ],
      ),
    );
  }
}
