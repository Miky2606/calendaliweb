import 'package:flutter/material.dart';
import 'package:app/widgets/inicio.dart';
import 'package:flutter_svg/flutter_svg.dart';

class home extends StatefulWidget {
  home({Key key}) : super(key: key);

  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        body: Container(
            child: ListView(
          children: [
            fondo(),
            inicio(),
          ],
        )));
  }
}

class fondo extends StatelessWidget {
  const fondo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
                width: 200, child: SvgPicture.asset("assets/images/hola.svg")),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
                padding: EdgeInsets.all(5),
                child: Text("Login",
                    style: TextStyle(fontSize: 35, fontFamily: 'Indie'))),
          )
        ],
      ),
    );
  }
}
