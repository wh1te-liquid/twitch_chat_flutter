// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:webview_flutter/webview_flutter.dart';

class TwitchAuthWebViewScreen extends StatelessWidget {
  final String _initialUrl;

  const TwitchAuthWebViewScreen(this._initialUrl, {Key? key}) : super(key: key);

  static Route<String> route(String url) {
    return MaterialPageRoute(builder: (_) => TwitchAuthWebViewScreen(url));
  }

  NavigationDecision processNavigation(BuildContext context, String url) {
    if (url.startsWith("http://localhost")) {
      final code = Uri.parse(url).queryParameters['code'];
      Navigator.pop(context, code);
      return NavigationDecision.prevent;
    } else {
      return NavigationDecision.navigate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebView(
        initialUrl: _initialUrl,
        javascriptMode: JavascriptMode.unrestricted,
        navigationDelegate: (action) => processNavigation(context, action.url),
      ),
    );
  }
}
