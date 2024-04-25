import 'package:blend/components/appBars/basic_app_bar.dart';
import 'package:blend/pages/workspace/settings/web_view_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:provider/provider.dart';
import 'package:blend/global_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
// ^ Webview will be on this page for now, I have a feeling
// that we will need to move this page to another page in the future but for now having it here should work

class WorkspaceAccountLinkingPage extends StatefulWidget {
  const WorkspaceAccountLinkingPage({super.key});
  @override
  State<WorkspaceAccountLinkingPage> createState() =>
      _WorkspaceAccountLinkingPageState();
}

class _WorkspaceAccountLinkingPageState
    extends State<WorkspaceAccountLinkingPage> {
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
    return Scaffold(
      appBar: BasicAppBar(title: "Account Linking").build(context),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              Text("Facebook: "),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WebViewContainer()));
                  // Unsure if the line above works, should send the user to the web_view_container page
                  // _loginWithFacebook();
                },
                child: Text('Login with Facebook'),
              ),
              // Sign out button
              ElevatedButton(
                onPressed: _signOut,
                child: Text('Sign Out of Facebook'),
              ),
              SizedBox(height: 20),
              // Text('Access Token: $_accessToken',
              //     style: TextStyle(color: Colors.white)),
              Text("LinkedIn: "),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WebViewContainer()));
                },
                child: Text('Login with LinkedIn'),
              ),
              // Sign out button
              ElevatedButton(
                onPressed: _signOut,
                child: Text('Sign Out of LinkedIn'),
              ),
              SizedBox(height: 20),
              // Text('Access Token: $_accessToken',
              //     style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
