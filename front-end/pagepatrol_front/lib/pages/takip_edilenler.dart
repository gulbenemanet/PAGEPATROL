import 'package:flutter/material.dart';

class Follow extends StatelessWidget {
  const Follow({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Takip Edilenler"),
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              Container(
                  width: 300,
                  height: 250,
                  color: Color(0xFF9E90A2),
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Takip Edilen 1",
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Color(0xFF272932),
                          backgroundColor: Color(0xFFB6C2D9),
                        ),
                        onPressed: () {
                          //Navigator.pushNamed(context, '/');
                        },
                        child: const Text("Siteye Git"),
                      ),
                      Container(
                        color: Color(0xFFB6C2D9),
                        child: Text("Siteden Gelen Veriler"),
                      ),
                    ],
                  )),
              SizedBox(height: 20),
              Container(
                  width: 300,
                  height: 250,
                  color: Color(0xFF9E90A2),
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Takip Edilen 2",
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Color(0xFF272932),
                          backgroundColor: Color(0xFFB6C2D9),
                        ),
                        onPressed: () {
                          //Navigator.pushNamed(context, '/');
                        },
                        child: const Text("Siteye Git"),
                      ),
                      Container(
                        color: Color(0xFFB6C2D9),
                        child: Text("Siteden Gelen Veriler"),
                      ),
                    ],
                  )),
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {
                  Navigator.pushNamed(context, '/edit');
                },
              ),
              IconButton(
                icon: const Icon(Icons.verified_user),
                onPressed: () {
                  Navigator.pushNamed(context, '/user');
                },
              ),
            ])));
  }
}
