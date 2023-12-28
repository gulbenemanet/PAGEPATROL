import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class User extends StatelessWidget {
  const User({Key? key});

  @override
  Widget build(BuildContext context) {
    return ProfilePage();
  }
}

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    _getProfile(context);
  }

  Future<void> _getProfile(BuildContext context) async {
    final String apiUrl = 'http://10.0.2.2:3000/profile';
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
        // Profil verilerini kullanabilirsiniz.
        print('Profile: $responseData');
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
        title: const Text("Kullanıcı Sayfası"),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Color(0xFF272932),
                backgroundColor: Color(0xFFB6C2D9),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/follow');
              },
              child: const Text("Ana Sayfaya Dön"),
            ),
            Image(image: AssetImage('assets/indir.jpeg')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Color(0xFF272932),
                backgroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/notification_settings');
              },
              child: const Text("Bildirim Ayarları"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Color(0xFF272932),
                backgroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/account_settings');
              },
              child: const Text("Hesap Ayarları"),
            ),
          ],
        ),
      ),
    );
  }
}
