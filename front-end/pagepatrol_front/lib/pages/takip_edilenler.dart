import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

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
  // final client = MqttServerClient('localhost', '1883');

  // MqttServerClient? client;
  // @override
  // void initState() {
  //   super.initState();

  //   // MQTT client oluştur
  //   final client = MqttServerClient.withPort('192.168.177.4', '', 1883);

  //   // MQTT olayları dinle
  //   client.onConnected = _onConnected;
  //   client.onDisconnected = _onDisconnected;
  //   client.onSubscribed = _onSubscribed;
  //   client.onSubscribeFail = _onSubscribeFail;

  //   // MQTT broker'ına bağlan
  //   client.connect();
  // }

  // @override
  // void dispose() {
  //   client?.disconnect();
  //   super.dispose();
  // }

  // void _onConnected() {
  //   print('MQTT broker ile bağlantı kuruldu');

  //   // Belirli bir konuyu dinlemeye başla
  //   client?.subscribe('notification', MqttQos.exactlyOnce);
  //   client!.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
  //     final MqttPublishMessage message = c[0].payload as MqttPublishMessage;
  //     final String payload =
  //         MqttPublishPayload.bytesToStringAsString(message.payload.message);

  //     print('Received message on topic ${c[0].topic}: $payload');
  //   });
  // }

  // void _onDisconnected() {
  //   print('MQTT broker ile bağlantı kesildi');
  // }

  // void _onSubscribed(String topic) {
  //   print('Konu dinlemeye başlandı: $topic');
  // }

  // void _onSubscribeFail(String topic) {
  //   print('Konu dinleme başarısız: $topic');
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Takip Edilenler"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                width: 300,
                height: 250,
                color: Color(0xFF9E90A2),
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Takip Edilen 1",
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Color(0xFF272932),
                        backgroundColor: Color(0xFFB6C2D9),
                      ),
                      onPressed: () {
                        //Navigator.pushNamed(context, '/');
                      },
                      child: const Text("Siteye Git"),
                    ),
                    // ElevatedButton(
                    //   onPressed: _onConnected,
                    //   // () {
                    //   //   final builder = MqttClientPayloadBuilder();
                    //   //   builder.addString('Merhaba from Flutter');
                    //   //   client.publishMessage('notification',
                    //   //       MqttQos.exactlyOnce, builder.payload!);
                    //   // },
                    //   child: Text('Bildirim Gönder'),
                    // ),
                    Container(
                      color: Color(0xFFB6C2D9),
                      child: Text("Siteden Gelen Veriler"),
                    ),
                  ],
                )),
            SizedBox(height: 20),
            Container(
                width: 300,
                height: 250,
                color: Color(0xFF9E90A2),
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Takip Edilen 2",
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Color(0xFF272932),
                        backgroundColor: Color(0xFFB6C2D9),
                      ),
                      onPressed: () {
                        //Navigator.pushNamed(context, '/');
                      },
                      child: const Text("Siteye Git"),
                    ),
                    Container(
                      color: Color(0xFFB6C2D9),
                      child: Text("Siteden Gelen Veriler"),
                    ),
                  ],
                )),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.pushNamed(context, '/edit');
              },
            ),
            IconButton(
              icon: const Icon(Icons.people),
              onPressed: () {
                Navigator.pushNamed(context, '/user');
              },
            ),
          ],
        ),
      ),
    );
  }
}
