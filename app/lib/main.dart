import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:app/widgets/home.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:app/widgets/page/page.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

void main() {
  initializeDateFormatting('fr_FR', null).then((_) => runApp(MyApp()));
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map data;
  Future<String> get jwt async {
    var storage = FlutterSecureStorage();
    var jwt = await storage.read(key: "token");

    return jwt;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'App',
        debugShowCheckedModeBanner: false,
        home: FutureBuilder(
            future: jwt,
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                var str = snapshot.data;
                var jwt = str;

                return page(jwt);
              } else {
                return home();
              }
            }));
  }
}
