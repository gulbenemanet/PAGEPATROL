import 'package:flutter/material.dart';

class User extends StatelessWidget {
  const User({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Kullanıcı Ayarları"),
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
        )));
  }
}
