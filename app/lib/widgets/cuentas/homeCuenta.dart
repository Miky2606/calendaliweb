import 'package:flutter/material.dart';
import 'calendar/calendar.dart';
import 'calendar/today.dart';

class homeCuenta extends StatefulWidget {
  final cuenta;
  homeCuenta({Key key, this.cuenta}) : super(key: key);

  @override
  _homeCuentaState createState() => _homeCuentaState();
}

class _homeCuentaState extends State<homeCuenta> {
  int _currentIndex = 0;
  final tabs = [today(), calendar()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${this.widget.cuenta}")),
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.today), title: Text("Home")),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), title: Text("Home"))
        ],
      ),
    );
  }
}
