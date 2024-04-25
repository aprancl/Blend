import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewContainer extends StatelessWidget {
  // Initialize webview controller
  final WebViewController controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.disabled)
    ..loadRequest(Uri.parse(
        'https://www.linkedin.com/uas/login?session_redirect=%2Foauth%2Fv2%2Flogin-success%3Fapp_id%3D216614661%26auth_type%3DAC%26flow%3D%257B%2522authorizationType%2522%253A%2522OAUTH2_AUTHORIZATION_CODE%2522%252C%2522redirectUri%2522%253A%2522https%253A%252F%252Fwww.google.com%252F%2522%252C%2522scope%2522%253A%2522w_member_social%2522%252C%2522appId%2522%253A216614661%252C%2522authFlowName%2522%253A%2522generic-permission-list%2522%252C%2522currentSubStage%2522%253A0%252C%2522creationTime%2522%253A1714016869614%252C%2522currentStage%2522%253A%2522LOGIN_SUCCESS%2522%257D&fromSignIn=1&trk=oauth&cancel_redirect=%2Foauth%2Fv2%2Flogin-cancel%3Fapp_id%3D216614661%26auth_type%3DAC%26flow%3D%257B%2522authorizationType%2522%253A%2522OAUTH2_AUTHORIZATION_CODE%2522%252C%2522redirectUri%2522%253A%2522https%253A%252F%252Fwww.google.com%252F%2522%252C%2522scope%2522%253A%2522w_member_social%2522%252C%2522appId%2522%253A216614661%252C%2522authFlowName%2522%253A%2522generic-permission-list%2522%252C%2522currentSubStage%2522%253A0%252C%2522creationTime%2522%253A1714016869614%252C%2522currentStage%2522%253A%2522LOGIN_SUCCESS%2522%257D'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WebView Container"),
        actions: [
          IconButton(
              onPressed: () {
                print(controller.currentUrl().toString());
                // print(Uri.parse(controller.currentUrl().toString()));
              },
              icon: Icon(Icons.refresh))
        ],
      ),
      body: Container(
        child: WebViewWidget(controller: controller),
      ),
    );
  }
}
// class WebViewContainerLi extends StatefulWidget {
//   final String initialUrl;

//   const WebViewContainerLi({Key? key, required this.initialUrl})
//       : super(key: key);

//   @override
//   State<WebViewContainerLi> createState() => _WebViewContainerStateLi();
// }

// class _WebViewContainerStateLi extends State<WebViewContainerLi> {
//   late WebViewController controller;

//   @override
//   void initState() {
//     super.initState();
//     controller = WebViewController(initialUrl: widget.initialUrl);
//     controller.setJavaScriptMode(JavaScriptMode.disabled);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("WebView Container"),
//       ),
//       body: WebView(
//         controller: controller,
//       ),
//     );
//   }
// }
