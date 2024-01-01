import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddSite extends StatelessWidget {
  // const AddSite({super.key});
  final TextEditingController _siteLinkController = TextEditingController();
  final TextEditingController _siteNameController = TextEditingController();

  Future<void> _addSite(BuildContext context) async {
    final String apiUrl = 'http://10.0.2.2:3000/userId';
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
        String user_id = await jsonDecode(response.body);
        // print('Profile: $user_id');
        // Profil verilerini kullanabilirsiniz.
        final String apiUrl = 'http://10.0.2.2:3000/followLink';

        final Map<String, dynamic> requestData = {
          "site": {
            "name": _siteNameController.text,
            "link": _siteLinkController.text,
            "htmlPart": '',
          },
          "id": user_id
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
            // print(responseData);
            // print(_siteLinkController.text);
            await addLinkToSF(_siteLinkController.text);
            await addLinkIdToSF(responseData);
            Navigator.pushReplacementNamed(context, '/select');
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

  Future<void> addLinkToSF(String link) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('siteLink', link);
  }

  Future<void> addLinkIdToSF(String siteId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('siteId', siteId);
  }

  Future<String?> getTokenFromSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tokenValue = prefs.getString('token');
    return tokenValue;
  }

  // Future<void> _addSite(BuildContext context) async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF242038),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              Text(
                "Takip etmek istediğiniz sitenin linkini yapıştırın:",
                style: TextStyle(color: Color(0xFFCAC4CE)),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _siteLinkController,
                style: TextStyle(color: Color(0xFFF7ECE1)),
                decoration: InputDecoration(
                  labelText: 'Eklenecek Site',
                  labelStyle: TextStyle(color: Color(0xFFF7ECE1)),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFCAC4CE)),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Siteniz için isim girin:",
                style: TextStyle(color: Color(0xFFCAC4CE)),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _siteNameController,
                style: TextStyle(color: Color(0xFFF7ECE1)),
                decoration: InputDecoration(
                  labelText: 'Site İsmi',
                  labelStyle: TextStyle(color: Color(0xFFF7ECE1)),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFCAC4CE)),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Color(0xFFF7ECE1),
                      backgroundColor: Color(0xFF8D86C9),
                    ),
                    child: const Text("Kaydet"),
                    onPressed: () => _addSite(context),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Color(0xFFF7ECE1),
                      backgroundColor: Color(0xFF8D86C9),
                    ),
                    child: const Text("Geç"),
                    onPressed: () {
                      // go to new page
                      Navigator.pushNamed(context, '/follow');
                    },
                  ),
                ],
              ),
            ])));
  }
}
