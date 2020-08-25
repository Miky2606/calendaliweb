import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:app/widgets/home.dart';
import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:app/widgets/page/user.dart';

class page extends StatefulWidget {
  page(this.jwt);
  factory page.fromBase64(String jwt) => (page(jwt));
  final jwt;

  @override
  _pageState createState() => _pageState();
}

class _pageState extends State<page> {
  final scaffold = GlobalKey<ScaffoldState>();

  Future<String> get user async {
    var response = await http.get(
        "https://calendaliapi.herokuapp.com/api/initialize",
        headers: {"x-auth": widget.jwt});
    return response.body;
  }

  @override
  Widget build(BuildContext context) {
    final _controllerText = TextEditingController();

    return Scaffold(
      body: FutureBuilder(
        future: user,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.data == "expired") {
            return home();
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
                Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                      height: 10,
                    )),
                Align(
                    alignment: Alignment.center,
                    child:
                        SizedBox(height: 240.0, child: usuario(email: email))),
              ]),
              floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              content: Container(
                                  width: 300.0,
                                  height: 300,
                                  child: Scaffold(
                                      key: scaffold,
                                      body: ListView(children: [
                                        Center(
                                            child: Text("Crear User",
                                                style: TextStyle(
                                                    fontFamily: "Indie",
                                                    fontSize: 40))),
                                        TextField(
                                          controller: _controllerText,
                                          decoration: InputDecoration(
                                              labelText: "user"),
                                        ),
                                        SizedBox(height: 30),
                                        RaisedButton(
                                          onPressed: () {
                                            var datos = {
                                              "nombre": _controllerText.text,
                                              "cuenta": email,
                                              "id_user": data[0]["id"],
                                              "imagen": "telefono.jpg"
                                            };
                                            _crearUser(datos);
                                          },
                                          child: Text("Enviar"),
                                          color: Colors.pink.withOpacity(.7),
                                        )
                                      ]))));
                        });
                  },
                  child: Icon(Icons.add)));
        },
      ),
    );
  }

  Future<String> _crearUser(datos) async {
    if (datos["nombre"] == "") {
      final snackbar = SnackBar(
        content: Text('User no puede estar en blanco'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // Some code to undo the change.
          },
        ),
      );
      scaffold.currentState.showSnackBar(snackbar);
    } else {
      var profile = json.encode(datos);

      var respuesta = await http.post(
        "https://calendaliapi.herokuapp.com/api/createProfile",
        body: profile,
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
        },
      );
    }
  }
}
