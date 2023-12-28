// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, avoid_print
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return LoginPage();
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    isLog();
  }

  Future<void> isLog() async {
    String? token = await getTokenFromSF();
    final String apiUrl = 'http://10.0.2.2:3000/profile';
    // print(token);
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
        Navigator.pushReplacementNamed(context, '/follow');
      } else {
        // Hata durumunda hata mesajını gösteriyorum.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hata: ${response.statusCode} - ${response.body}'),
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
  }

  Future<String?> getTokenFromSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tokenValue = prefs.getString('token');
    return tokenValue;
  }

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    final String apiUrl = 'http://10.0.2.2:3000/signIn';

    final Map<String, dynamic> requestData = {
      "userName": _usernameController.text,
      "password": _passwordController.text,
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
        final String token = responseData['data']['token'];
        await addTokenToSF(token);
        Navigator.pushReplacementNamed(context, '/addsite');
      } else {
        // Hata durumunda hata mesajını gösteriyorum.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hata: ${response.statusCode} - ${response.body}'),
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
  }

  Future<void> addTokenToSF(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }

  // Future<void> _loginWGoogle() async {
  //   GoogleSignInAccount
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PAGEPATROL"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username or email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              controller: _passwordController,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(child: const Text("Login"), onPressed: _login),
                SizedBox(width: 20),
                ElevatedButton(
                    child: const Text("Kayıt Ol"),
                    onPressed: () {
                      // go to new page
                      Navigator.pushNamed(context, '/kayit');
                    }),
                ElevatedButton(
                    child: const Text("Server"),
                    onPressed: () {
                      // go to new page
                      Navigator.pushNamed(context, '/server');
                    }),
                const Text("OR"),
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Color(0xFF272932),
                backgroundColor: Color(0xFFB6C2D9),
              ),
              child: const Text("LOGIN WITH GOOGLE"),
              onPressed: () => {},
            ),
          ],
        ),
      ),
    );
  }
}
