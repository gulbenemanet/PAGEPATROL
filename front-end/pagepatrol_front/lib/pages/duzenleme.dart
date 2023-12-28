import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Edit extends StatefulWidget {
  const Edit({super.key});
  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  List<Map<String, dynamic>> userSites = [];

  @override
  void initState() {
    super.initState();
    _getUserSites();
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

  Future<void> _deleteSite(BuildContext context, String siteId) async {
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
        final String apiUrl = 'http://10.0.2.2:3000/unFollowLink';

        final Map<String, dynamic> requestData = {
          "siteId": siteId,
          "id": user_id,
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
            final Map<String, dynamic> responseData = jsonDecode(response.body);
            print(responseData);
            Navigator.pushReplacementNamed(context, '/edit');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Takip Edilen Siteleri Düzenle"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text("Takip Edilen Siteler"),
            Column(
              children: userSites.map((site) {
                // print(site['name']);
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(site['link'] ?? "Bilgi Yok"),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Color(0xFF272932),
                        backgroundColor: Color(0xFFB6C2D9),
                      ),
                      child: const Text("Düzenle"),
                      onPressed: () {
                        // Düzenleme
                        // Navigator.pushNamed(context, '/düzenle');
                      },
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Color(0xFF272932),
                        backgroundColor: Color(0xFFB6C2D9),
                      ),
                      child: const Text("Kaldır"),
                      onPressed: () {
                        _deleteSite(context, site['_id']);
                      },
                    ),
                  ],
                );
              }).toList(),
            ),
            SizedBox(height: 100),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Color(0xFF272932),
                backgroundColor: Color(0xFFB6C2D9),
              ),
              child: const Text("Yeni Site Ekle"),
              onPressed: () {
                // Ekleme
                Navigator.pushNamed(context, '/addsite');
              },
            ),
            Container(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Color(0xFF272932),
                  backgroundColor: Color(0xFFB6C2D9),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/follow');
                },
                child: const Text("Ana Sayfaya Dön"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
