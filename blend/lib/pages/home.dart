import 'package:blend/components/main_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:blend/global_provider.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';


class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MainAppBar mainAppBar = MainAppBar();

  String _accessToken = 'No access token';

  Future<void> _loginWithFacebook() async {
    try {
      // Log in with Facebook
      final LoginResult result = await FacebookAuth.instance.login();

      // Check if login was successful
      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;
        setState(() {
          _accessToken = accessToken.token;
        });
      } else {
        setState(() {
          _accessToken = 'Login failed';
        });
      }
    } catch (e) {
      setState(() {
        _accessToken = 'Error: $e';
      });
    }
  }

  void _signOut() {
    // Implement your sign out logic here
    setState(() {
       Provider.of<GlobalProvider>(context, listen: false).signOut();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GlobalProvider>(context);
    final _bottomNavigationKey = provider.bottomNavigationKey;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: mainAppBar.build(context),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          
          children: [
            Icon(
              Icons.home,
              size: 120,
              color: Colors.white,
            ),
            Text(
              'Home Page',
              style: TextStyle(
                  color: Colors.white, fontSize: 30, fontWeight: FontWeight.w700),
            ),
            // button
            ElevatedButton(
              onPressed: () {
                provider.signOut();
              },
              child: Text('Sign Out'),
            ),
            ElevatedButton(
            onPressed: _loginWithFacebook,
            child: Text('Login with Facebook'),
          ),
          SizedBox(height: 20),
          // Sign out button
          ElevatedButton(
            onPressed: _signOut,
            child: Text('Sign Out of Facebook'),
          ),
          SizedBox(height: 20),
          Text('Access Token: $_accessToken', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

// this class contains all the data the user sets for the posting process
