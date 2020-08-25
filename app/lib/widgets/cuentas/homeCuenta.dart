import 'package:flutter/material.dart';
import 'calendar/calendar2.dart';
import 'calendar/today.dart';

class homeCuenta extends StatefulWidget {
  final String cuenta;
  final email;
  homeCuenta({Key key, this.cuenta, this.email}) : super(key: key);

  @override
  _homeCuentaState createState() => _homeCuentaState();
}

class _homeCuentaState extends State<homeCuenta> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final tabs = [calendar(cuenta: widget.cuenta), today(email: widget.email)];

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
          BottomNavigationBarItem(
            icon: Icon(Icons.today),
            title: Text("Calendar"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text("Settings"),
          ),
        ],
      ),
    );
  }
}
