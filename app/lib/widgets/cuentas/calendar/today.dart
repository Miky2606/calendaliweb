import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class today extends StatefulWidget {
  final email;
  today({Key key, this.email}) : super(key: key);

  @override
  _todayState createState() => _todayState();
}

class _todayState extends State<today> {
  Future user;

  @override
  Future<String> findUser(email) async {
    var response =
        await http.get("https://calendaliapi.herokuapp.com/api/${email}");

    return response.body;
  }

  void initState() {
    user = findUser(widget.email);
    super.initState();
  }

  Widget build(BuildContext context) {
    return FutureBuilder(
      future: user,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        List data = jsonDecode(snapshot.data);

        print(data);
        return Center(child: Text(widget.email));
      },
    );
  }
}
