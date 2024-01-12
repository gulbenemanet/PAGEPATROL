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
      backgroundColor: Color(0xFF242038),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(25),
                  child: Text("Takip Edilen Siteler",
                      style: TextStyle(fontSize: 24, color: Color(0xFFF7ECE1))),
                ),
                Container(
                  width: 300,
                  height: 400,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: userSites.map((site) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceBetween, // Sütunların arasında eşit boşluk bırakır
                        children: [
                          SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              constraints: BoxConstraints(
                                  maxWidth: 100), // İstenilen maksimum genişlik
                              child: Text(site['name'] ?? "Bilgi Yok",
                                  style: TextStyle(
                                    color: Color(0xFFF7ECE1),
                                    fontSize: 18,
                                  )),
                            ),
                          ),
                          SizedBox(width: 8), // İstenilen boşluk
                          Column(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Color(0xFFCAC4CE),
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/select');
                                },
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Color(0xFFCAC4CE),
                                ),
                                onPressed: () {
                                  _deleteSite(context, site['_id']);
                                },
                              ),
                            ],
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 100),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: 150,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Color(0xFFF7ECE1),
                          backgroundColor: Color(0xFF8D86C9),
                        ),
                        child: const Text("Yeni Site Ekle"),
                        onPressed: () {
                          // Ekleme
                          Navigator.pushNamed(context, '/addsite');
                        },
                      ),
                    ),
                    Container(
                      width: 150,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Color(0xFFF7ECE1),
                          backgroundColor: Color(0xFF8D86C9),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/follow');
                        },
                        child: const Text("Ana Sayfaya Dön"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
