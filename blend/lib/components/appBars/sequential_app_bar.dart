import 'package:blend/global_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class SequentialAppBar extends StatelessWidget {
  final Function leftFunction;
  final IconData leftIcon;
  final Function rightFunction;
  final String rightText;

  const SequentialAppBar({
    super.key,
    required this.leftFunction,
    required this.leftIcon,
    required this.rightFunction,
    required this.rightText,
  });

  @override
  PreferredSize build(BuildContext context) {
    final provider = Provider.of<GlobalProvider>(context);
    final _blendUser = provider.blendUser;

    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: AppBar(
        leading: IconButton(
          icon: Icon(leftIcon),
          onPressed: () {
            leftFunction();
          },
        ),
        centerTitle: true,
        title: Text(
          'New Post',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: <Widget>[
          // button using user's profile picture
          GestureDetector(
            onTap: () {
              rightFunction();
            },
            child: Container(
                margin: EdgeInsets.only(right: 20),
                child: Text(
                  rightText,
                  style: TextStyle(
                    fontSize: 17,
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
