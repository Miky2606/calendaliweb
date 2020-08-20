import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:app/widgets/sign/inputSign.dart';

class sign extends StatefulWidget {
  sign({Key key}) : super(key: key);

  @override
  _signState createState() => _signState();
}

class _signState extends State<sign> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        Container(
          width: double.infinity,
          height: 280,
          decoration: BoxDecoration(
              color: Colors.pink.withOpacity(.7),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                    width: 200,
                    child: SvgPicture.asset("assets/images/hola.svg")),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Text("Sign",
                        style: TextStyle(fontSize: 35, fontFamily: 'Indie'))),
              ),
            ],
          ),
        ),
        inputSign(),
      ],
    ));
  }
}
