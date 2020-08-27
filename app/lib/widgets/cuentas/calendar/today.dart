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

        return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  child: Stack(
                children: [
                  Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Center(
                          child: InkWell(
                        child: Container(
                            width: 30.0,
                            height: 30.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  spreadRadius: 3,
                                  blurRadius: 3,
                                  offset: Offset(
                                      0, 2), // changes position of shadow
                                ),
                              ],
                              color: Colors.grey,
                            ),
                            child: Center(child: Icon(Icons.settings))),
                        onTap: () {
                          showModalBottomSheet(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(25),
                                      topRight: Radius.circular(25))),
                              backgroundColor: Colors.pink.withOpacity(.8),
                              context: context,
                              builder: (BuildContext context) {
                                return new Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20)),
                                    ),
                                    width: double.infinity,
                                    height: 600.0,
                                    child: Center(
                                      child: Text("hola"),
                                    ));
                              });
                        },
                      )))
                ],
              )),
              Text("Perfiles"),
              Expanded(
                  child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    child: Card(
                        child: Stack(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              child: Image.network(
                                  "https://calendaliweb.com/img/profile/${data[index]["imagen"]}"),
                            ),
                            Text("${data[index]['nombre']}"),
                            Spacer(),
                            Icon(Icons.edit)
                          ],
                        ),
                      ],
                    )),
                  );
                },
              )),
            ]);
      },
    );
  }
}
