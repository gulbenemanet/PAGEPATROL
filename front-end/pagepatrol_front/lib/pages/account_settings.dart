import 'package:flutter/material.dart';

class Account extends StatelessWidget {
  const Account({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Hesap Ayarları"),
        ),
        body: Center(
            child: Column(
          children: [
            Image.asset('assets/indir.jpeg'),
            Row(
children: [
  Text("isim")
],
            ),
            ],
        )));
  }
}