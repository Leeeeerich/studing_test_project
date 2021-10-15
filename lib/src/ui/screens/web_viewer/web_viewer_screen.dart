import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewerScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WebViewerScreen();
}

class _WebViewerScreen extends State<WebViewerScreen> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context)?.settings.arguments as Map;
    String link = arguments["link"];
    print("Link = $link");
    return SafeArea(
      child: WebView(
        initialUrl: link,
        // javascriptMode: JavascriptMode.unrestricted,
        // onWebViewCreated: (WebViewController webViewController) {
        //   _controller.complete(webViewController);
        // },
        // gestureNavigationEnabled: true,
      ),
    );
  }
}
