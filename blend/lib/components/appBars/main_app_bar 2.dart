import 'package:blend/global_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class MainAppBar extends StatelessWidget {
  const MainAppBar({super.key});

  @override
  PreferredSize build(BuildContext context) {
    final provider = Provider.of<GlobalProvider>(context);
    final _blendUser = provider.blendUser;

    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            // do something
          },
        ),
        centerTitle: true,
        title: Text(
          'Blend',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: <Widget>[
          // button using user's profile picture
          IconButton(
            icon: CircleAvatar(
              backgroundImage: NetworkImage(_blendUser.pfp ??
                  "https://www.pngkey.com/png/full/114-1149878_setting-user-avatar-in-specific-size-without-breaking.png"),
            ),
            onPressed: () {
              // Display user profile
              Navigator.pushNamed(context, '/user/profile');
            },
          ),
        ],
      ),
    );
  }
}
