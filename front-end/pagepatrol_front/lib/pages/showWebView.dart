import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(
    const MaterialApp(
      // theme: ThemeData(useMaterial3: true),
      home: ShowWebView(),
    ),
  );
}

class ShowWebView extends StatefulWidget {
  const ShowWebView({Key? key}) : super(key: key);

  @override
  State<ShowWebView> createState() => _ShowWebViewState();
}

class _ShowWebViewState extends State<ShowWebView> {
  late WebViewController controller;
  late String link;

  Future<String?> getUserLinkFromSF() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? linkValue = await prefs.getString('userSiteLink');
    // print(linkValue);
    String cleanedObjectIdString = linkValue!.replaceAll("\"\"", "");
    return cleanedObjectIdString;
  }

  @override
  void initState() {
    super.initState();
    controller = WebViewController();
    _initWebView();
  }

  void _initWebView() async {
    link = (await getUserLinkFromSF())!;
    if (link.isNotEmpty) {
      print(link);
      controller
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadRequest(
          Uri.parse(link),
        );
    } else {
      print("HATA" + link);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter WebView'),
      ),
      body: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              Container(
                width: 400,
                height: 650,
                child: WebViewWidget(
                  controller: controller,
                ),
                padding: EdgeInsets.only(bottom: 25),
              ),
            ],
          )),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
