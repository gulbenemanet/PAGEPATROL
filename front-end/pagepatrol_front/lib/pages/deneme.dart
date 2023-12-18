import 'package:flutter/material.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  int deger = 0;
  final _controller = TextEditingController();
  String name ="İsim Giriniz";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Deneme Sayfası"),
        ),
        body: Center(
            child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                labelText: name,
                border: OutlineInputBorder(),
              ),
                  ),
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.edit),
                  label: Text("Düzenle"),
                  onPressed: () {
                    setState(() {
                      name = _controller.text;
                    });
                    //print("bruh2");
                  },
                ),
              ],
            ),
          ],
        )));
  }
}
