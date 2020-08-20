import 'package:flutter/material.dart';
import 'package:app/widgets/sign.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:app/widgets/page/page.dart';
import 'package:connectivity/connectivity.dart';

class inicio extends StatefulWidget {
  inicio({Key key}) : super(key: key);

  @override
  _inicioState createState() => _inicioState();
}

class _inicioState extends State<inicio> {
  final logForm = GlobalKey<FormState>();
  String _email, _password;
  bool isLoading;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    setState(() {
      isLoading = false;
    });

    if (isLoading == true) {
      return CircularProgressIndicator();
    }

    return Padding(
        padding: EdgeInsets.only(bottom: bottom),
        child: Form(
            key: logForm,
            child: Column(
              children: [
                Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                        width: 240,
                        child: TextFormField(
                          style: TextStyle(
                              fontFamily: 'Indie',
                              color: Colors.green,
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
                        ))),
                Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                        width: 240,
                        child: TextFormField(
                          obscureText: true,
                          style: TextStyle(
                              fontFamily: 'Indie',
                              color: Colors.green,
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
                        _submitLog();
                      },
                      child: Text("Login",
                          style: TextStyle(color: Colors.lightGreen[100])),
                      color: Colors.pink[400].withOpacity(.7),
                    )),
                SizedBox(width: 30),
                Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                        onTap: () {},
                        child: Text("Forgot Password?",
                            style: TextStyle(color: Colors.pink)))),
                Align(
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        Container(
                            width: size.width * 0.45,
                            child: Divider(
                              color: Colors.pink,
                              height: 62,
                              thickness: .5,
                              indent: 20,
                              endIndent: 0,
                            )),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "Or",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Container(
                            width: size.width * 0.45,
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
                          builder: (context) => sign(),
                        ));
                      },
                      child: Text("Sign",
                          style: TextStyle(color: Colors.lightGreen[100])),
                      color: Colors.pink[400].withOpacity(.7),
                    )),
              ],
            )));
  }

  void _submitLog() async {
    setState(() {
      isLoading = true;
    });

    if (logForm.currentState.validate()) {
      setState(() {
        isLoading = false;
      });
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
        logForm.currentState.save();
        var datos = {
          "email": _email,
          "password": _password,
        };
        var respuesta = await http.post(
            "https://calendaliapi.herokuapp.com/api/findUser",
            body: datos);

        if (respuesta.body == "errorPassword" ||
            respuesta.body == "errorUser") {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Error"),
                  content: Text(respuesta.body),
                );
              });
        } else {
          var data = json.decode(respuesta.body);
          var jwt = data["token2"];

          var storage = FlutterSecureStorage();

          storage.write(key: "token", value: data["token2"]);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => page.fromBase64(jwt)));
        }
      }
    }
  }
}
