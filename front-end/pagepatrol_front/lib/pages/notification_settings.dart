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
        appBar: AppBar(
          title: const Text("Bildirim Ayarları"),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Bildirim Kanalları", style: TextStyle(fontSize: 20)),
            Container(
              child: Column(
                children: <Widget>[
                  Row(
                    children: [
                      Expanded(
                          child: Container(
                        width: double.infinity,
                        child: RadioListTile(
                            title: Text("SMS"),
                            value: 1,
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
                            title: Text("Bildirim"),
                            value: 2,
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
                            title: Text("Mail"),
                            value: 3,
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
                  Text("Bildirim Ses Tonu", style: TextStyle(fontSize: 20)),
                  Row(
                    children: [
                      Expanded(
                          child: Container(
                        width: double.infinity,
                        child: RadioListTile(
                            title: Text("Ses1"),
                            value: 4,
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
                            title: Text("Ses2"),
                            value: 5,
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
                            title: Text("Ses3"),
                            value: 6,
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