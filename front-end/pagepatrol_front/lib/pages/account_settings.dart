import 'package:flutter/material.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final _controller = TextEditingController();
  final _controller2 = TextEditingController();
  final _controller3 = TextEditingController();
  final _controller4 = TextEditingController();
  String name = "İsim Giriniz";
  String surname = "Soyisim Giriniz";
  String mail = "Mail Giriniz";
  String tno = "000 - 000 - 00 - 00";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Hesap Ayarları"),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/indir.jpeg'),
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
                  },
                ),
              ],
            ),
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
                  },
                ),
              ],
            ),
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
                  },
                ),
              ],
            ),
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
                  },
                ),
              ],
            ),
          ],
        )));
  }
}
