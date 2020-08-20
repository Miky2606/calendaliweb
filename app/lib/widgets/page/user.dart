import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:app/widgets/cuentas/homeCuenta.dart';

class usuario extends StatelessWidget {
  final email;
  const usuario({Key key, this.email}) : super(key: key);

  Future<String> get cuenta async {
    var response =
        await http.get("https://calendaliapi.herokuapp.com/api/${this.email}");

    return response.body;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: cuenta,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        List user = jsonDecode(snapshot.data);

        return ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: user.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.pink.withOpacity(.8),
                          borderRadius: BorderRadius.circular(12)),
                      width: 170,
                      child: Stack(
                        children: [
                          InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => homeCuenta(
                                        cuenta: user[index]["nombre"])));
                              },
                              child: SizedBox(
                                  height: 200,
                                  child: SvgPicture.asset(
                                      "assets/images/hola.svg"))),
                          Align(
                              alignment: Alignment.bottomCenter,
                              child: Text(
                                user[index]["nombre"],
                                style: TextStyle(
                                    fontFamily: "Indie",
                                    fontSize: 35,
                                    color: Colors.pink[100]),
                              ))
                        ],
                      )));
            });
      },
    );
  }
}
