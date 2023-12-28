import 'package:flutter/material.dart';
import 'package:pagepatrol_front/pages/account_settings.dart';
import 'package:pagepatrol_front/pages/add_site.dart';
import 'package:pagepatrol_front/pages/kayit.dart';
import 'package:pagepatrol_front/pages/duzenleme.dart';
import 'package:pagepatrol_front/pages/home_page.dart';
import 'package:pagepatrol_front/pages/notification_settings.dart';
import 'package:pagepatrol_front/pages/takip_bolum_sec.dart';
import 'package:pagepatrol_front/pages/takip_edilenler.dart';
import 'package:pagepatrol_front/pages/user.dart';
import 'package:pagepatrol_front/pages/server_deneme.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      title: "PagePatrol",
      home: const HomePage(),
      routes: {
        '/homepage': (context) => const HomePage(),
        '/addsite': (context) => AddSite(),
        '/select': (context) => SelectSection(),
        '/follow': (context) => Follow(),
        '/edit': (context) => const Edit(),
        '/user': (context) => const User(),
        '/notification_settings': (context) => Notifications(),
        '/account_settings': (context) => const Account(),
        '/kayit': (context) => Register(),
        '/server': (context) => Server(),
      },
    );
  }
}
