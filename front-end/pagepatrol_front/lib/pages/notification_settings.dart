import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Notifications extends StatefulWidget {
  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  List<int> selectedValues = [];
  bool mail = false;
  bool sms = false;

  @override
  void initState() {
    super.initState();
    _getUserNotificaiton();
  }

  Future<String?> getTokenFromSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tokenValue = prefs.getString('token');
    return tokenValue;
  }

  Future<void> _getUserNotificaiton() async {
    final String apiUrl = 'http://10.0.2.2:3000/userNotification';
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
        // print(responseData['sms']);
        if (responseData['sms']) {
          selectedValues.add(1);
        }

        if (responseData['mail']) {
          selectedValues.add(3);
        }
        setState(() {
          sms = responseData['sms'] ?? false;
          mail = responseData['mail'] ?? false;
        });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF242038),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Bildirim Kanalları",
                style: TextStyle(fontSize: 20, color: Color(0xFFF7ECE1))),
            Container(
              child: Column(
                children: <Widget>[
                  buildCheckboxListTile(1, "SMS"),
                  buildCheckboxListTile(2, "Bildirim"),
                  buildCheckboxListTile(3, "Mail"),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              child: Column(
                children: <Widget>[
                  Text("Bildirim Ses Tonu",
                      style: TextStyle(fontSize: 20, color: Color(0xFFF7ECE1))),
                  buildCheckboxListTile(4, "Ses1"),
                  buildCheckboxListTile(5, "Ses2"),
                  buildCheckboxListTile(6, "Ses3"),
                  SizedBox(height: 20),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Color(0xFFF7ECE1),
                            backgroundColor: Color(0xFF8D86C9),
                          ),
                          onPressed: () {
                            saveSelectedValues();
                            // Navigator.pushNamed(context, '/user');
                          },
                          child: const Text("Kaydet"),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Color(0xFFF7ECE1),
                            backgroundColor: Color(0xFF8D86C9),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/user');
                          },
                          child: const Text("Geri Dön"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  CheckboxListTile buildCheckboxListTile(int value, String title) {
    return CheckboxListTile(
      title: Text(
        title,
        style: TextStyle(color: Color(0xFFF7ECE1)),
      ),
      value: selectedValues.contains(value),
      activeColor: Color(0xFFF7ECE1),
      onChanged: (bool? isChecked) {
        setState(() {
          if (isChecked!) {
            selectedValues.add(value);
          } else {
            selectedValues.remove(value);
          }
        });
      },
    );
  }

  void saveSelectedValues() async {
    final String apiUrlId = 'http://10.0.2.2:3000/userId';
    print("Seçilen Değerler: $selectedValues");
    sms = await selectedValues.contains(1);
    mail = await selectedValues.contains(3);
    print(sms);
    final String apiUrl = 'http://10.0.2.2:3000/notification';
    String? token = await getTokenFromSF();

    try {
      final response = await http.get(
        Uri.parse(apiUrlId),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        String id = await jsonDecode(response.body);
        try {
          final Map<String, dynamic> requestData = {
            "id": id,
            "sms": sms,
            "mail": mail,
          };
          final response = await http.put(
            Uri.parse(apiUrl),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(requestData),
          );
          if (response.statusCode == 200) {
            print("Veri başarıyla güncellendi");
            Navigator.pushNamed(context, '/user');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text('Hata: ${response.statusCode} - ${response.body}'),
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
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bir hata oluştu: $e'),
        ),
      );
    }
  }
}
