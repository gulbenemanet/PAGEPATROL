import 'package:flutter/material.dart';

class AddSite extends StatelessWidget {
  const AddSite({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Site Ekleme"),
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              Text("Takip etmek istediğiniz sitenin linkini yapıştırın:"),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Eklenecek Site',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Color(0xFF272932),
                      backgroundColor: Color(0xFFB6C2D9),
                    ),
                    child: const Text("Kaydet"),
                    onPressed: () {
                      // go to new page
                      Navigator.pushNamed(context, '/select');
                    },
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Color(0xFF272932),
                      backgroundColor: Color(0xFFB6C2D9),
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
