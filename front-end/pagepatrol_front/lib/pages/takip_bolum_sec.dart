import 'package:flutter/material.dart';

//bool value = false;
//bool _value = false;

class SelectSection extends StatelessWidget {
  const SelectSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Seçim Yap"),
        ),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text("Takip etmek istediğiniz bölümü seçin"),

                /*Radio(
                  value: true,
                  groupValue: _value,
                  onChanged: (value) {
                    setState(() {
                      _value = value as bool;
                    });
                  },
                  activeColor: Colors.grey, // Seçildiğinde içi gri olacak
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),*/

                /*InkWell(
                  onTap: () {
                    setState(() {
                      _value = !_value;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.blue),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: _value
                          ? Icon(
                              Icons.check,
                              size: 30.0,
                              color: Colors.white,
                            )
                          : Icon(
                              Icons.check_box_outline_blank,
                              size: 30.0,
                              color: Colors.blue,
                            ),
                    ),
                  ),
                ), */
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Color(0xFF272932),
                    backgroundColor: Color(0xFFB6C2D9),
                  ),
                  child: const Text("Kaydet"),
                  onPressed: () {
                    // go to new page
                    Navigator.pushNamed(context, '/follow');
                  },
                ),
              ]),
        ));
  }

  void setState(Null Function() param0) {}
}

/*class CircularCheckbox extends StatelessWidget {
  final bool? value;
  final ValueChanged<bool?>? onChanged;
  const CircularCheckbox(
      {Key? key, required this.value, required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Transform.scale(
      scale: 1.3,
      child: Checkbox(
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}*/
