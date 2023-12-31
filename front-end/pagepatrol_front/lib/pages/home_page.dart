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
    final String apiUrl = 'http://localhost:3000/profile';
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
      } else if (response.statusCode != 401) {
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
    final String apiUrl = 'http://localhost:3000/signIn';

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
        showDialog(
          context: context,
          builder: (BuildContext context) {
            final Map<String, dynamic> responseData = jsonDecode(response.body);
            final String message = responseData['message'];
            return AlertDialog(
              backgroundColor: Color(0xFF9067C6),
              content: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Hata: $message',
                  style: TextStyle(
                    color: Color(0xFFF7ECE1),
                    fontSize: 18.0,
                  ),
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            );
          },
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
      backgroundColor: Color(0xFF242038),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Text(
                "PAGEPATROL",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFCAC4CE),
                ),
              ),
            ),
            SizedBox(height: 75),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: TextField(
                controller: _usernameController,
                style: TextStyle(color: Color(0xFFF7ECE1)),
                decoration: InputDecoration(
                  labelText: 'Username or email',
                  labelStyle: TextStyle(color: Color(0xFFF7ECE1)),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFCAC4CE)),
                  ),
                ),
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: TextField(
                obscureText: true,
                style: TextStyle(color: Color(0xFFF7ECE1)),
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Color(0xFFF7ECE1)),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFCAC4CE)),
                  ),
                ),
                controller: _passwordController,
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
                  child: const Text("Login"),
                  onPressed: _login,
                ),
                SizedBox(width: 20),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Color(0xFFF7ECE1),
                      backgroundColor: Color(0xFF8D86C9),
                    ),
                    child: const Text("Kayıt Ol"),
                    onPressed: () {
                      // go to new page
                      Navigator.pushNamed(context, '/kayit');
                    }),
                /*ElevatedButton(
                    child: const Text("Server"),
                    onPressed: () {
                      // go to new page
                      Navigator.pushNamed(context, '/server');
                    }),*/
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "OR",
                  style: TextStyle(color: Color(0xFFCAC4CE)),
                ),
              ],
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Color(0xFFF7ECE1),
                backgroundColor: Color(0xFF8D86C9),
              ),
              child: const Text(
                "LOGIN WITH GOOGLE",
              ),
              onPressed: () => {},
            ),
          ],
        ),
      ),
    );
  }
}
