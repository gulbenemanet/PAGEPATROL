import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  //const Notifications({super.key});
  int deger = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF242038),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Bildirim Kanalları",
                style: TextStyle(fontSize: 20, color: Color(0xFFF7ECE1))),
            Container(
              child: Column(
                children: <Widget>[
                  Row(
                    children: [
                      Expanded(
                          child: Container(
                        width: double.infinity,
                        child: RadioListTile(
                            title: Text("SMS",
                                style: TextStyle(color: Color(0xFFF7ECE1))),
                            value: 1,
                            activeColor: Color(0xFFF7ECE1),
                            groupValue: deger,
                            onChanged: (int? gelen) {
                              setState(() {
                                deger = gelen!;
                              });
                              print("SMS seçildi");
                            }),
                      ))
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Container(
                        width: double.infinity,
                        child: RadioListTile(
                            title: Text("Bildirim",
                                style: TextStyle(color: Color(0xFFF7ECE1))),
                            value: 2,
                            activeColor: Color(0xFFF7ECE1),
                            groupValue: deger,
                            onChanged: (int? gelen) {
                              setState(() {
                                deger = gelen!;
                              });
                              print("Bildirim seçildi");
                            }),
                      ))
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Container(
                        width: double.infinity,
                        child: RadioListTile(
                            title: Text("Mail",
                                style: TextStyle(color: Color(0xFFF7ECE1))),
                            value: 3,
                            activeColor: Color(0xFFF7ECE1),
                            groupValue: deger,
                            onChanged: (int? gelen) {
                              setState(() {
                                deger = gelen!;
                              });
                              print("Mail seçildi");
                            }),
                      ))
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              child: Column(
                children: <Widget>[
                  Text("Bildirim Ses Tonu",
                      style: TextStyle(fontSize: 20, color: Color(0xFFF7ECE1))),
                  Row(
                    children: [
                      Expanded(
                          child: Container(
                        width: double.infinity,
                        child: RadioListTile(
                            title: Text("Ses1",
                                style: TextStyle(color: Color(0xFFF7ECE1))),
                            value: 4,
                            activeColor: Color(0xFFF7ECE1),
                            groupValue: deger,
                            onChanged: (int? gelen) {
                              setState(() {
                                deger = gelen!;
                              });
                              print("Ses1 seçildi");
                            }),
                      ))
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Container(
                        width: double.infinity,
                        child: RadioListTile(
                            title: Text("Ses2",
                                style: TextStyle(color: Color(0xFFF7ECE1))),
                            value: 5,
                            activeColor: Color(0xFFF7ECE1),
                            groupValue: deger,
                            onChanged: (int? gelen) {
                              setState(() {
                                deger = gelen!;
                              });
                              print("Ses2 seçildi");
                            }),
                      ))
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Container(
                        width: double.infinity,
                        child: RadioListTile(
                            title: Text("Ses3",
                                style: TextStyle(color: Color(0xFFF7ECE1))),
                            value: 6,
                            activeColor: Color(0xFFF7ECE1),
                            groupValue: deger,
                            onChanged: (int? gelen) {
                              setState(() {
                                deger = gelen!;
                              });
                              print("Ses3 seçildi");
                            }),
                      ))
                    ],
                  ),
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
              ),
            ),
          ],
        )));
  }
}

/*class Notification extends StatefulWidget {
  //const rad({?Key key}) : super(key: key);
  const Notification({super.key});
  @override
  State<Notification> createState() => _radState();
}
class _radState extends State<Notification>{
  int deger =0;
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
RadioListTile(title: Text("Cigar"), value: 1, groupValue: deger, 
onChanged: (int? gelen){setState(() {
  deger = gelen!;
});
print("cigar seçildi");
})
          ],
        ),
      ),
    );
  }
}*/