import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import "package:blend/global_provider.dart";
import "package:provider/provider.dart";
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WebViewContainer extends StatelessWidget {
  // Initialize webview controller
  final WebViewController controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.disabled)
    ..loadRequest(Uri.parse(dotenv.env['linkedin_auth_link']!));

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GlobalProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("WebView Container"),
        actions: [
          IconButton(
              onPressed: () async {
                // String? curURL = await controller.currentUrl();
                // String? finalCode = Uri.parse(curURL!).queryParameters['code'];
                // print(finalCode);
                // dotenv.env['linkedin_api_token'] = finalCode!;
                Navigator.pop(context);
              },
              icon: Icon(Icons.done))
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
