import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class User extends StatelessWidget {
  const User({Key? key});

  @override
  Widget build(BuildContext context) {
    return ProfilePage();
  }
}

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = '';
  String surname = '';
  String mail = '';
  String tno = '';
  String id = '';
  @override
  void initState() {
    super.initState();
    _getProfile(context);
  }

  Future<void> _getProfile(BuildContext context) async {
    final String apiUrl = 'http://10.0.2.2:3000/profile';
    String? token = await getTokenFromSF();
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
        // Profil verilerini kullanabilirsiniz.
        setState(() {
          name = responseData['data']['name'];
          surname = responseData['data']['lastName'];
          mail = responseData['data']['email'];
          tno = responseData['data']['phoneNumber'];
          id = responseData['data']['_id'];
        });
        print('Profile: $responseData');
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

  Future<String?> getTokenFromSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tokenValue = prefs.getString('token');
    return tokenValue;
  }

  Future<void> addTokenToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', "");
  }

  Future<void> updateUserProfile() async {
    // Profil güncelleme işlemleri burada gerçekleştirilecek
    // Örnek bir HTTP isteği:
    final String apiUrl = 'http://10.0.2.2:3000/update_profile';
    final response = await http.put(
      Uri.parse(apiUrl),
      body: {
        '_id': id,
        'name': editedName.isEmpty ? name : editedName,
        'lastName': editedName.isEmpty ? surname : editedSurname,
        'email': editedMail.isEmpty ? mail : editedMail,
        'phoneNumber': editedTno.isEmpty ? tno : editedTno,
      },
    );

    // Güncelleme başarılı ise ekrana mesaj göstermek için:
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profil güncellendi'),
        ),
      );
    }
  }

  // String name = "";
  String editedName = '';
  // String surname = "Soy isim Giriniz";
  String editedSurname = '';
  // String mail = "";
  String editedMail = '';
  // String tno = "Telefon Numarası Giriniz";
  String editedTno = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF242038),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Color(0xFFF7ECE1),
                      backgroundColor: Color(0xFF9067C6),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/follow');
                    },
                    child: const Text("Ana Sayfaya Dön"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Color(0xFFF7ECE1),
                      backgroundColor: Color(0xFF9067C6),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/notification_settings');
                    },
                    child: const Text("Bildirim Ayarları"),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Image(image: AssetImage('assets/indir.jpeg')),
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
                    color: Color(0xFFF7ECE1),
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
                              updateUserProfile();
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
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 50.0),
                    child: Text(
                      editedSurname.isEmpty ? surname : editedSurname,
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
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 50.0),
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
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 50.0),
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
                        title: Text('Yeni Telefon Numarası'),
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
            SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(Icons.exit_to_app),
              label: Text("Çıkış"),
              style: ElevatedButton.styleFrom(
                foregroundColor: Color(0xFFF7ECE1),
                backgroundColor: Color(0xFF9067C6),
              ),
              onPressed: () {
                addTokenToSF();
                Navigator.pushNamed(context, '/homepage');
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Center(
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                          margin: EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            color: Color(0xFF9067C6),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'Çıkış Başarılı',
                              style: TextStyle(
                                  color: Color(0xFFF7ECE1), fontSize: 18.0),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
