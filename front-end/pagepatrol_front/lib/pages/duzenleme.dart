import 'package:flutter/material.dart';

class Edit extends StatelessWidget {
  const Edit({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Takip Edilen Siteleri Düzenle"),
        ),
        body: Center(
            child: Column(children: <Widget>[
          Text("Takip Edilen Siteler"),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("A sitesi"),
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
                    // Kaldırma
                    // Navigator.pushNamed(context, '/delete');
                  },
                ),
              ]),
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
          
        ])));
  }
}
