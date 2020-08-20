import 'package:flutter/material.dart';

class today extends StatefulWidget {
  today({Key key}) : super(key: key);

  @override
  _todayState createState() => _todayState();
}

class _todayState extends State<today> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Center(child: Text("Today")));
  }
}
