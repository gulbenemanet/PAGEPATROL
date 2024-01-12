import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Follow(),
    );
  }
}

class Follow extends StatefulWidget {
  @override
  _FollowState createState() => _FollowState();
}

class _FollowState extends State<Follow> {
  MqttServerClient? client;
  List<Map<String, dynamic>> userSites = [];
  bool _hasCallSupport = false;
  bool _isLoadingPage = false;
  Future<void>? _launched;
  @override
  void initState() {
    super.initState();
    _getUserSites();
    connectToMqttBroker();
  }

  Future<String?> getLink() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? linkValue = await prefs.getString('siteLink');
    // print(linkValue);
    String cleanedObjectIdString = linkValue!.replaceAll("\"\"", "");
    // var objectId = ObjectId.parse(cleanedObjectIdString);

    return cleanedObjectIdString;
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  Future<String?> getTokenFromSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tokenValue = prefs.getString('token');
    return tokenValue;
  }

  Future<void> addLinkToSF(String link) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userSiteLink', link);
  }

  Future<void> _getUserSites() async {
    final String apiUrl = 'http://10.0.2.2:3000/usersSites';
    String? token = await getTokenFromSF();

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        // print(responseData);
        if (responseData['success']) {
          setState(() {
            userSites = List.from(responseData['data']);
            // print(userSites);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Hata: ${responseData['message']}'),
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

  void connectToMqttBroker() async {
    // Set up the MQTT client
    client = MqttServerClient.withPort('10.0.2.2', 'flutter_client', 1883);

    // Set up event listeners
    client!.onConnected = _onConnected;
    client!.onDisconnected = _onDisconnected;
    client!.onSubscribed = _onSubscribed;
    client!.onSubscribeFail = _onSubscribeFail;

    try {
      // Connect to the MQTT broker
      await client!.connect();
    } catch (e) {
      print('Exception while connecting: $e');
    }
  }

  void _onConnected() {
    print('Connected to MQTT broker');

    // Subscribe to the 'notification' topic
    client?.subscribe('notification', MqttQos.atLeastOnce);

    // Listen for incoming messages
    client!.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage message = c[0].payload as MqttPublishMessage;
      final String payload =
          MqttPublishPayload.bytesToStringAsString(message.payload.message);

      print('Received message on topic ${c[0].topic}: $payload');
    });
  }

  void _onDisconnected() {
    print('Disconnected from MQTT broker');
  }

  void _onSubscribed(String topic) {
    print('Subscribed to topic: $topic');
  }

  void _onSubscribeFail(String topic) {
    print('Failed to subscribe to topic: $topic');
  }

  @override
  void dispose() {
    client?.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF242038),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 3),
                  color: Color(0xFF8D86C9),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.edit,
                          color: Color(0xFFCAC4CE),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/edit');
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.people,
                          color: Color(0xFFCAC4CE),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/user');
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  child: Text(
                    "Takip Edilenler",
                    style: TextStyle(color: Color(0xFFF7ECE1), fontSize: 24),
                  ),
                ),
                SizedBox(height: 50),
                Column(
                  children: userSites.map((site) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceBetween, // Sütunların arasında eşit boşluk bırakır
                      children: [
                        SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            // width: 100,
                            // height: 100,
                            // color: Color(0xFF8D86C9),
                            padding: EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              // mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  site['name'] ?? "Bilgi Yok",
                                  style: TextStyle(
                                      fontSize: 18, color: Color(0xFFF7ECE1)),
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Color(0xFFF7ECE1),
                                        backgroundColor: Color(0xFF9067C6),
                                      ),
                                      onPressed: () async {
                                        setState(() {
                                          _launched = _launchInBrowser(
                                              Uri.parse(site['link']));
                                        });
                                      },
                                      child: const Text("Siteye Git"),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Color(0xFFF7ECE1),
                                        backgroundColor: Color(0xFF9067C6),
                                      ),
                                      onPressed: () {
                                        addLinkToSF(site['link']);
                                        Navigator.pushNamed(
                                            context, '/showWebView');
                                      },
                                      child: Text('Göster'),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                              ],
                            ),
                            constraints: BoxConstraints(
                                maxWidth: 100), // İstenilen maksimum genişlik
                          ),
                        ),
                        SizedBox(width: 8), // İstenilen boşluk
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchURL(url) async {
    if (!await launchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
