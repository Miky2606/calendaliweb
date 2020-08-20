import 'package:flutter/material.dart';
import 'package:app/main.dart';
import 'package:app/widgets/page/page.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:connectivity/connectivity.dart';

class inputSign extends StatefulWidget {
  inputSign({Key key}) : super(key: key);

  @override
  _inputSignState createState() => _inputSignState();
}

class _inputSignState extends State<inputSign> {
  final signForm = GlobalKey<FormState>();
  String _email, _password, _nombre;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: Form(
            key: signForm,
            child: Column(
              children: [
                Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                      width: 240,
                      child: TextFormField(
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Indie',
                            fontSize: 19),
                        decoration: InputDecoration(
                          suffixIcon: Icon(Icons.email),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.pink, width: 1)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.pink, width: 1)),
                          labelText: "User",
                        ),
                        validator: (value) => value.length < 6
                            ? "User must be at least 6 characteres"
                            : null,
                        onSaved: (value) => _nombre = value,
                      ),
                    )),
                Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                      width: 240,
                      child: TextFormField(
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Indie',
                            fontSize: 19),
                        decoration: InputDecoration(
                          suffixIcon: Icon(Icons.email),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.pink, width: 1)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.pink, width: 1)),
                          labelText: "Email",
                        ),
                        validator: (value) =>
                            !value.contains('@') ? "Email incorrect" : null,
                        onSaved: (value) => _email = value,
                      ),
                    )),
                Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                        width: 240,
                        child: TextFormField(
                          obscureText: true,
                          style: TextStyle(
                              fontFamily: 'Indie',
                              color: Colors.black,
                              fontSize: 19),
                          decoration: InputDecoration(
                            suffixIcon: Icon(Icons.lock),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    BorderSide(color: Colors.pink, width: 1)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    BorderSide(color: Colors.pink, width: 1)),
                            labelText: "Password",
                          ),
                          validator: (value) => value.length < 6
                              ? "Password must be at least 6 characteres"
                              : null,
                          onSaved: (value) => _password = value,
                        ))),
                SizedBox(width: 40),
                Padding(
                    padding: EdgeInsets.all(25),
                    child: RaisedButton(
                      onPressed: () {
                        _sign();
                      },
                      child: Text("Create",
                          style: TextStyle(color: Colors.lightGreen[100])),
                      color: Colors.pink[400].withOpacity(.7),
                    )),
                SizedBox(width: 30),
                Align(
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        Container(
                            width: 180,
                            child: Divider(
                              color: Colors.pink,
                              height: 62,
                              thickness: .5,
                              indent: 20,
                              endIndent: 0,
                            )),
                        Padding(
                          padding: EdgeInsets.all(12),
                          child: Text(
                            "Or",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Container(
                            width: 180,
                            child: Divider(
                              color: Colors.pink,
                              height: 62,
                              thickness: .5,
                              indent: 20,
                              endIndent: 0,
                            )),
                      ],
                    )),
                SizedBox(width: 40),
                Padding(
                    padding: EdgeInsets.all(5),
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => MyApp(),
                        ));
                      },
                      child: Text("Login",
                          style: TextStyle(color: Colors.lightGreen[100])),
                      color: Colors.pink[400].withOpacity(.7),
                    )),
              ],
            )));
  }

  void _sign() async {
    if (signForm.currentState.validate()) {
      var connectivity = await Connectivity().checkConnectivity();
      if (connectivity == ConnectivityResult.none) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Error"),
                content: Text("No Internet"),
              );
            });
      } else {
        signForm.currentState.save();

        var datos = {"email": _email, "password": _password, "nombre": _nombre};

        var respuesta = await http
            .post("https://calendaliapi.herokuapp.com/api", body: datos);

        var response = json.decode(respuesta.body);

        if (response.length == 1) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Error"),
                  content: Text("User Exist"),
                );
              });
        } else {
          var jwt = "hjhjghj";
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => page(jwt)));
        }
      }
    }
  }
}
