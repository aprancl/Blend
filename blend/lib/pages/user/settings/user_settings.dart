import 'package:blend/components/appBars/basic_app_bar.dart';
import 'package:blend/components/misc/tile_button.dart';
import 'package:flutter/material.dart';
import 'package:blend/global_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserSettingsPage extends StatelessWidget {
  const UserSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GlobalProvider>(context);

    void deleteAccount() {
      // Show a dialog to confirm the deletion of the account, requiring the user to confirm their username
      final User authUser = provider.getAuthUser()!;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Delete your account"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    "Are you sure you want to delete your account? This action cannot be undone."),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  await provider.deleteAccount();
                  // pop to route /login
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith(
                    (states) => provider.theme.primaryColor,
                  ),
                ),
                child: Text("Delete"),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: BasicAppBar(title: "Account Settings").build(context),
      body: Center(
        child: Container(
          padding: EdgeInsets.only(top: 20),
          child: Column(
            children: [
              Text(
                "Account Settings",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TileButton(
                title: "Sign Out",
                onTap: () {
                  provider.signOut();
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                },
              ),
              TileButton(
                title: "Edit theme",
                onTap: () {
                  Navigator.pushNamed(context, '/user/settings/theme');
                },
              ),
              TileButton(
                title: "Delete your account",
                onTap: deleteAccount,
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
