import 'package:blend/components/appBars/basic_app_bar.dart';
import 'package:blend/components/misc/tile_button.dart';
import 'package:flutter/material.dart';
import 'package:blend/global_provider.dart';
import 'package:provider/provider.dart';

class WorkspaceSettingsPage extends StatelessWidget {
  const WorkspaceSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GlobalProvider>(context);

    return Scaffold(
      appBar: BasicAppBar(title: "Workspace Settings").build(context),
      body: Center(
        child: Container(
          padding: EdgeInsets.only(top: 20),
          child: Column(
            children: [
              Text(
                "Account Settings",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              // horizontal line
              TileButton(
                title: "Workspace Information",
                route: "/undefined",
              ),
              TileButton(
                title: "Account Linking",
                route: "/workspace/settings/account-linking",
              ),
              TileButton(
                title: "Some other settings page",
                route: "/undefined",
              ),
              Divider(
                color: provider.theme.dividerColor,
                thickness: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
