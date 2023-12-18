// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, avoid_print
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("PAGEPATROL"),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                labelText: 'Username or email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    child: const Text("Login"),
                    onPressed: () {
                      // go to new page
                      Navigator.pushNamed(context, '/addsite');
                    }),
                SizedBox(width: 20),
                ElevatedButton(
                    child: const Text("Kayıt Ol"),
                    onPressed: () {
                      // go to new page
                      Navigator.pushNamed(context, '/kayit');
                    }),
              ],
            ),
            const Text("OR"),
            /*
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Color(0xFF272932),
                backgroundColor: Color(0xFFB6C2D9),
              ),
              child: const Text("LOGIN WITH FACEBOOK"),
              onPressed: () {
                // go to new page
                //Navigator.pushNamed(context, '/select');
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Color(0xFF272932),
                backgroundColor: Color(0xFFB6C2D9),
              ),
              child: const Text("LOGIN WITH TWITTER"),
              onPressed: () {
                // go to new page
                //Navigator.pushNamed(context, '/select');
              },
            ),
            */
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Color(0xFF272932),
                backgroundColor: Color(0xFFB6C2D9),
              ),
              child: const Text("LOGIN WITH GOOGLE"),
              onPressed: () {
                // go to new page
                //Navigator.pushNamed(context, '/select');
              },
            ),
          ],
        )));
  }
}
