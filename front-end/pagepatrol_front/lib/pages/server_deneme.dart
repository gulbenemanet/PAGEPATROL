import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

void main() {
  runApp(Server());
}

class Server extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Kullanıcılar'),
        ),
        body: FutureBuilder(
          // Burada servisten veri çekme işlemleri yapılabilir.
          // Şu an için veriyi doğrudan koda ekliyorum.
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Hata: ${snapshot.error}'),
              );
            } else {
              List<dynamic> users = snapshot.data?['data'];
              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  var user = users[index];
                  return ListTile(
                    title: Text('${user['name']} ${user['lastName']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Email: ${user['email']}'),
                        Text('Phone: ${user['phoneNumber']}'),
                        Text('Username: ${user['userName']}'),
                        Text('Followed Sites: ${getFollowedSites(user)}'),
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  String getFollowedSites(Map<String, dynamic> user) {
    List<dynamic> followedSites = user['followedSites'];
    if (followedSites.isEmpty) {
      return 'Takip edilen Site Yok';
    } else {
      return followedSites.map((site) => site['name']).join(', ');
    }
  }

  // Veriyi burada döndüğümüzü düşünelim.
  Future<Map<String, dynamic>> fetchData() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:3000/users'));
    return json.decode(response.body);
  }
}
