import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SelectSection(),
    );
  }
}

class SelectSection extends StatefulWidget {
  @override
  _SelectSectionState createState() => _SelectSectionState();
}

class _SelectSectionState extends State<SelectSection> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  late String htmlContent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WebView in Flutter'),
      ),
      body: WebView(
        initialUrl:
            'https://blog.logrocket.com', // İstediğiniz linki buraya koyun
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
        javascriptChannels: <JavascriptChannel>[
          JavascriptChannel(
            name: 'elementClick',
            onMessageReceived: (JavascriptMessage message) {
              print('Clicked element tag name: ${message.message}');
            },
          ),
        ].toSet(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final WebViewController controller = await _controller.future;
          // Webview'de tıklanan elementin tag adını almak için JavaScript kodu
          String script = '''
            document.addEventListener('click', function(event) {
              var clickedElement = event.target;
              window.elementClick.postMessage(clickedElement);
            });
          ''';
          // print('HTML Content: $htmlContent');
          await controller.runJavascriptReturningResult(script);
        },
        child: Icon(Icons.send),
      ),
    );
  }
}
