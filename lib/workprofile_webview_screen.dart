import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'Config/enums.dart';

class WorkProfileWebviewScreen extends StatefulWidget {
  String user_id;
  final UserType type;
  WorkProfileWebviewScreen({Key? key, required this.type, this.user_id = ""})
      : super(key: key);

  @override
  _WorkProfileWebviewScreenState createState() =>
      _WorkProfileWebviewScreenState();
}

class _WorkProfileWebviewScreenState extends State<WorkProfileWebviewScreen> {
  InAppWebViewController? _webViewController;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (await _webViewController!.canGoBack()) {
            _webViewController!.goBack();
            return false;
          } else {
            return true;
          }
        },
        child: SafeArea(
            child: Scaffold(
          appBar: null,
          body: InAppWebView(
              initialUrlRequest: URLRequest(
                  url: Uri.parse('https://shreespace.com/Work_profile/prof/' +
                      widget.user_id +
                      '?red=1')),
              onLoadStart: (controller, url) async {
                // Handle URL changes here
                print("Current URL: ${url.toString()}");

                // Check if the URL indicates a logout
                /*if (url.toString().contains("logout")) {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                              (route) => false);
                      await ShareManager.logout(context);
                    }*/
              },
              initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
                  mediaPlaybackRequiresUserGesture: false,
                  //debuggingEnabled: true,
                ),
              ),
              onWebViewCreated: (InAppWebViewController controller) {
                _webViewController = controller;
              },
              androidOnPermissionRequest: (InAppWebViewController controller,
                  String origin, List<String> resources) async {
                return PermissionRequestResponse(
                    resources: resources,
                    action: PermissionRequestResponseAction.GRANT);
              }),
        )));
  }
}
