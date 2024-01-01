import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Register> {
  int deger = 0;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  String name = "İsim Giriniz";
  String surname = "Soy isim Giriniz";
  String mail = "Mail Giriniz";
  String tno = "Telefon Numarası Giriniz";
  String userName = "Kullanıcı Adı Giriniz";
  String password = "Şifre Giriniz";

  Future<void> _signUp() async {
    final String apiUrl = 'http://10.0.2.2:3000/signUp';

    final Map<String, dynamic> requestData = {
      "name": _nameController.text,
      "lastName": _lastNameController.text,
      "email": _mailController.text,
      "phoneNumber": _phoneNumberController.text,
      "userName": _userNameController.text,
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

  Future<void> addTokenToSF(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Kayıt Ol"),
        ),
        body: Center(
            child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: name,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                /*ElevatedButton.icon(
                  icon: Icon(Icons.edit),
                  label: Text("Düzenle"),
                  onPressed: () {
                    setState(() {
                      name = _nameController.text;
                    });
                    //print("bruh2");
                  },
                ),*/
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _lastNameController,
                    decoration: InputDecoration(
                      labelText: surname,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
               /* ElevatedButton.icon(
                  icon: Icon(Icons.edit),
                  label: Text("Düzenle"),
                  onPressed: () {
                    setState(() {
                      surname = _lastNameController.text;
                    });
                    //print("bruh2");
                  },
                ),*/
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _mailController,
                    decoration: InputDecoration(
                      labelText: mail,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
               /* ElevatedButton.icon(
                  icon: Icon(Icons.edit),
                  label: Text("Düzenle"),
                  onPressed: () {
                    setState(() {
                      mail = _mailController.text;
                    });
                    //print("bruh2");
                  },
                ),*/
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _phoneNumberController,
                    decoration: InputDecoration(
                      labelText: tno,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
               /* ElevatedButton.icon(
                  icon: Icon(Icons.edit),
                  label: Text("Düzenle"),
                  onPressed: () {
                    setState(() {
                      tno = _phoneNumberController.text;
                    });
                    //print("bruh2");
                  },
                ),*/
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _userNameController,
                    decoration: InputDecoration(
                      labelText: userName,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                /*ElevatedButton.icon(
                  icon: Icon(Icons.edit),
                  label: Text("Düzenle"),
                  onPressed: () {
                    setState(() {
                      userName = _userNameController.text;
                    });
                    //print("bruh2");
                  },
                ),*/
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    obscureText: true,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: password,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                /*ElevatedButton.icon(
                  icon: Icon(Icons.edit),
                  label: Text("Düzenle"),
                  onPressed: () {
                    setState(() {
                      password = _passwordController.text;
                    });
                    //print("bruh2");
                  },
                ),*/
              ],
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Color(0xFF272932),
                backgroundColor: Color(0xFFB6C2D9),
              ),
              child: const Text("Kayıt Ol"),
              onPressed: _signUp,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Color(0xFF272932),
                backgroundColor: Color(0xFFB6C2D9),
              ),
              child: const Text("Giriş Yap"),
              onPressed: () {
                // go to new page
                Navigator.pushNamed(context, '/homepage');
              },
            ),
          ],
        )));
  }
}
