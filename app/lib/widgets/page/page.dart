import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:app/widgets/home.dart';

import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';
import 'package:app/widgets/page/user.dart';

class page extends StatelessWidget {
  page(this.jwt);
  factory page.fromBase64(String jwt) => (page(jwt));
  final jwt;

  Future<String> get user async {
    var response = await http.get(
        "https://calendaliapi.herokuapp.com/api/initialize",
        headers: {"x-auth": jwt});

    return response.body;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: user,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          Map user = jsonDecode(snapshot.data);
          List data = user["user"];

          String email = data[0]["email"];

          return Scaffold(
              appBar: AppBar(title: Text("hola")),
              drawer: Drawer(
                  child: ListView(
                children: [
                  DrawerHeader(
                      decoration: BoxDecoration(
                        color: Colors.pink.withOpacity(.5),
                      ),
                      child: Center(
                          child: Text(
                        data[0]["nombre"],
                        style: TextStyle(fontFamily: "Indie", fontSize: 40),
                      ))),
                  ListTile(
                    title: Text("Email: ${email}"),
                  ),
                  ListTile(
                    title: Text("Creacion: ${data[0]['fecha']}"),
                  ),
                  RaisedButton(
                    onPressed: () {
                      http.get("https://calendaliapi.herokuapp.com/api");
                      var storage = FlutterSecureStorage();
                      storage.delete(key: "token");

                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => home()));
                    },
                    color: Colors.pink[400].withOpacity(.7),
                    child: Text("Logout"),
                  )
                ],
              )),
              body: Column(children: [
                Text("hola"),
                Align(
                    alignment: Alignment.center,
                    child:
                        SizedBox(height: 240.0, child: usuario(email: email))),
              ]));
        },
      ),
    );
  }
}
