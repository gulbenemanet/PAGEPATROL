import 'package:flutter/material.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  // final _controller = TextEditingController();
  // final _controller2 = TextEditingController();
  // final _controller3 = TextEditingController();
  // final _controller4 = TextEditingController();
  String name = "";
  String editedName = '';
  String surname = "Soy isim Giriniz";
  String editedSurname = '';
  String mail = "";
  String editedMail = '';
  String tno = "Telefon Numarası Giriniz";
  String editedTno = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF242038),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/indir.jpeg',
                width: 170, height: 170, fit: BoxFit.cover),
            SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 50.0), // Sağa boşluk ekler
                    child: Text(
                      editedName.isEmpty ? name : editedName,
                      style: TextStyle(color: Color(0xFFF7ECE1), fontSize: 18),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Color(0xFFF7ECE1), // İkon rengi
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('Yeni Kullanıcı Adı'),
                        content: TextField(
                          controller: TextEditingController(text: name),
                          onChanged: (value) {
                            editedName = value;
                          },
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                name = editedName;
                                editedName = '';
                              });
                              Navigator.pop(context);
                            },
                            child: Text('Onayla'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(width: 50),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                SizedBox(width: 20),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 50.0),
                    child: Text(
                      editedName.isEmpty ? name : editedName,
                      style: TextStyle(color: Color(0xFFF7ECE1), fontSize: 18),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Color(0xFFF7ECE1),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('Yeni Soyisim'),
                        content: TextField(
                          controller: TextEditingController(text: surname),
                          onChanged: (value) {
                            editedSurname = value;
                          },
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                surname = editedSurname;
                                editedSurname = '';
                              });
                              Navigator.pop(context);
                            },
                            child: Text('Onayla'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(width: 50),
              ],
            ),

            
            SizedBox(height: 20),
            Row(
              children: [
                SizedBox(width: 20),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 50.0),
                    child: Text(
                      editedMail.isEmpty ? mail : editedMail,
                      style: TextStyle(color: Color(0xFFF7ECE1), fontSize: 18),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Color(0xFFF7ECE1),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('Yeni Mail Adresi'),
                        content: TextField(
                          controller: TextEditingController(text: mail),
                          onChanged: (value) {
                            editedMail = value;
                          },
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                mail = editedMail;
                                editedMail = '';
                              });
                              Navigator.pop(context);
                            },
                            child: Text('Onayla'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(width: 50),
              ],
            ),
            
            SizedBox(height: 20),
            Row(
              children: [
                SizedBox(width: 20),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 50.0),
                    child: Text(
                      editedTno.isEmpty ? tno : editedTno,
                      style: TextStyle(color: Color(0xFFF7ECE1), fontSize: 18),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Color(0xFFF7ECE1),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('Yeni TNO'),
                        content: TextField(
                          controller: TextEditingController(text: tno),
                          onChanged: (value) {
                            editedTno = value;
                          },
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                tno = editedTno;
                                editedTno = '';
                              });
                              Navigator.pop(context);
                            },
                            child: Text('Onayla'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(width: 50),
              ],
            ),

            // Row(
            //   children: [
            //     SizedBox(width: 20),
            //     Expanded(
            //       child: TextField(
            //         controller: _controller4,
            //         style: TextStyle(color: Color(0xFFF7ECE1)),
            //         decoration: InputDecoration(
            //           labelText: tno,
            //           labelStyle: TextStyle(color: Color(0xFFF7ECE1)),
            //           border: OutlineInputBorder(
            //             borderSide: BorderSide(color: Color(0xFFCAC4CE)),
            //           ),
            //         ),
            //       ),
            //     ),
            //     SizedBox(width: 10),
            //     ElevatedButton.icon(
            //       icon: Icon(Icons.edit),
            //       label: Text("Düzenle"),
            //       style: ElevatedButton.styleFrom(
            //         foregroundColor: Color(0xFFF7ECE1),
            //         backgroundColor: Color(0xFF8D86C9),
            //       ),
            //       onPressed: () {
            //         setState(() {
            //           tno = _controller4.text;
            //         });
            //       },
            //     ),
            //     SizedBox(width: 10),
            //   ],
            // ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Color(0xFFF7ECE1),
                backgroundColor: Color(0xFF8D86C9),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/user');
              },
              child: const Text("Geri Dön"),
            ),
          ],
        )));
  }
}
