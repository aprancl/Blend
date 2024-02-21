import 'package:blend/global_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class BasicAppBar extends StatelessWidget {
  final String title;
  const BasicAppBar({super.key, required this.title});

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
          // spacer to center text
          SizedBox(width: 40),
        ],
      ),
    );
  }
}
