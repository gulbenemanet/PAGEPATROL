import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Register> {
  int deger = 0;
  final _controller = TextEditingController();
  final _controller2 = TextEditingController();
  final _controller3 = TextEditingController();
  final _controller4 = TextEditingController();
  String name ="İsim Giriniz";
  String surname ="Soy isim Giriniz";
  String mail ="Mail Giriniz";
  String tno ="Telefon Numarası Giriniz";
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
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller2,
                    decoration: InputDecoration(
                labelText: surname,
                border: OutlineInputBorder(),
              ),
                  ),
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.edit),
                  label: Text("Düzenle"),
                  onPressed: () {
                    setState(() {
                      surname = _controller2.text;
                    });
                    //print("bruh2");
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller3,
                    decoration: InputDecoration(
                labelText: mail,
                border: OutlineInputBorder(),
              ),
                  ),
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.edit),
                  label: Text("Düzenle"),
                  onPressed: () {
                    setState(() {
                      mail = _controller3.text;
                    });
                    //print("bruh2");
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller4,
                    decoration: InputDecoration(
                labelText: tno,
                border: OutlineInputBorder(),
              ),
                  ),
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.edit),
                  label: Text("Düzenle"),
                  onPressed: () {
                    setState(() {
                      tno = _controller4.text;
                    });
                    //print("bruh2");
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Color(0xFF272932),
                  backgroundColor: Color(0xFFB6C2D9),
                ),
                child: const Text("Kaydet"),
                onPressed: () {
                  // go to new page
                  Navigator.pushNamed(context, '/homepage');
                },
              ),
          ],
        )));
  }
}
