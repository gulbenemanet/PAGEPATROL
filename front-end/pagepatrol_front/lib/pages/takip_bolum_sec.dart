import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:objectid/objectid.dart';

void main() {
  runApp(
    const MaterialApp(
      // theme: ThemeData(useMaterial3: true),
      home: SelectSection(),
    ),
  );
}

class SelectSection extends StatefulWidget {
  const SelectSection({Key? key}) : super(key: key);

  @override
  State<SelectSection> createState() => _SelectSectionState();
}

class _SelectSectionState extends State<SelectSection> {
  late WebViewController controller;
  late String link;

  Future<void> _addHTML(BuildContext context) async {
    final String apiUrl = 'http://10.0.2.2:3000/userId';
    String? token = await getTokenFromSF();
    String? siteId = await getLinkIdFromSF();
    Array? htmlPart;

    String cleanedObjectIdString = await siteId!.replaceAll("\"", "");
    // print("dfmkdfm" + cleanedObjectIdString);
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        String user_id = await jsonDecode(response.body);

        final String apiUrl = 'http://10.0.2.2:3000/updateLink';
        final Map<String, dynamic> requestData = {
          "id": user_id,
          "siteId": cleanedObjectIdString,
          "htmlPart": htmlPart
        };

        try {
          final response = await http.post(
            Uri.parse(apiUrl),
            headers: <String, String>{
              'Content-Type': 'application/json',
            },
            body: jsonEncode(requestData),
          );

          if (response.statusCode == 200) {
            final String responseData = response.body;
            print(responseData);
            // print(_siteLinkController.text);
            // Navigator.pushReplacementNamed(context, '/select');
          } else {
            // Hata durumunda hata mesajını gösteriyorum.
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text('Hata: ${response.statusCode} - ${response.body}'),
              ),
            );
          }
        } catch (e) {
          print(e);
          // Genel hata durumunda hata mesajını gösteriyorum.
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Bir hata oluştu: $e'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hata: ${response.statusCode} - ${response.body}'),
          ),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bir hata oluştu: $e'),
        ),
      );
    }
  }

  Future<String?> getTokenFromSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tokenValue = prefs.getString('token');
    return tokenValue;
  }

  Future<String?> getLinkFromSF() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? linkValue = await prefs.getString('siteLink');
    // print(linkValue);
    String cleanedObjectIdString = linkValue!.replaceAll("\"\"", "");
    // var objectId = ObjectId.parse(cleanedObjectIdString);

    return cleanedObjectIdString;
  }

  Future<String?> getLinkIdFromSF() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? linkId = await prefs.getString('siteId');
    // print(linkId);
    return linkId;
  }

  @override
  void initState() {
    super.initState();
    controller = WebViewController();
    _initWebView();
  }

  void _initWebView() async {
    link = (await getLinkFromSF())!;
    if (link.isNotEmpty) {
      print(link);
      controller
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadRequest(
          Uri.parse(link),
        )
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageFinished: (String url) {
              injectJavascript(controller);
            },
          ),
        );
    } else {
      print("HATAAA" + link);
    }
  }

  injectJavascript(WebViewController controller) async {
    controller.runJavaScript(
        '''console.log('deneme'); window.onclick = (event) => {console.log("fkdjnk" + event.target.outerHTML);''');
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
                height: 600,
                child: WebViewWidget(
                  controller: controller,
                ),
                padding: EdgeInsets.only(bottom: 25),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 100.0, // FAB genişliği
                    height: 40.0,
                    child: ElevatedButton(
                      onPressed: () {
                        controller.runJavaScript('''
                          // console.log('FAB clicked');
                          let htmlPart = []; 
                          let counter = 0;
                          document.body.style.touchAction = 'none';
                          document.body.style.overflow = 'hidden';
                          var links = document.getElementsByTagName('a');
                          for (var i = 0; i < links.length; i++) {
                            links[i].addEventListener('click', function(event) {
                              event.preventDefault(); // Lİnkleri kapa
                            });
                          }
                          let isBorderRed = false;

                          window.onclick = (event) => {
                            if(isBorderRed) {
                              event.target.style.border = "none";
                            } else {
                              event.target.style.borderStyle = "solid"; 
                              event.target.style.borderWidth = "4px";
                              event.target.style.borderColor = "red";
                              htmlPart.push(event.target.outerHTML);                          
                            }
                            isBorderRed = !isBorderRed;
                            counter++;
                          }                      
                        ''');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 8.0),
                          Text('Kilitle'),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 100.0, // FAB genişliği
                    height: 40.0,
                    child: ElevatedButton(
                      onPressed: () {
                        controller.runJavaScript('''
                          document.body.style.touchAction = 'auto';
                          document.body.style.overflow = 'visible';
                        ''');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 8.0),
                          Text('Aç'),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 100.0, // FAB genişliği
                    height: 40.0,
                    child: ElevatedButton(
                      onPressed: () {
                        controller.runJavaScript('''
                          // document.body.style.touchAction = 'auto';
                          // document.body.style.overflow = 'visible';

                        ''');
                        _addHTML(context);
                        Navigator.pushNamed(context, '/follow');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 8.0),
                          Text('Tamamla'),
                        ],
                      ),
                    ),
                  )
                ],
              )
            ],
          )),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
