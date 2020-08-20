import 'package:app/widgets/inicio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:date_format/date_format.dart';
import 'package:http/http.dart' as http;
import 'package:calendar_timeline/calendar_timeline.dart';
import 'dart:convert';
import 'dart:async';

class calendar extends StatefulWidget {
  calendar({Key key}) : super(key: key);

  @override
  _calendarState createState() => _calendarState();
}

Future<String> get task async {
  var response =
      await http.get("https://calendaliapi.herokuapp.com/api/findTarea/daphne");

  return response.body;
}

class _calendarState extends State<calendar> {
  var _initialDate = DateTime.now();
  Map<String, dynamic> data;
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: task,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView(children: [
          CalendarTimeline(
            initialDate: _initialDate,
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(Duration(days: 365)),
            onDateSelected: (date) {
              List dateUser = jsonDecode(snapshot.data);

              for (var i = 0; i < dateUser.length; i++) {
                if (new DateFormat('yyyy-MM-dd').format(date) ==
                    dateUser[i]["date"]) {
                  setState(() {
                    data = dateUser[i]["title"];
                    _initialDate = date;
                  });
                }
              }
            },
            leftMargin: 20,
            monthColor: Colors.pink.withOpacity(.7),
            dayColor: Colors.teal[200],
            dayNameColor: Color(0xFF333A47),
            activeDayColor: Colors.white,
            activeBackgroundDayColor: Colors.pink.withOpacity(.7),
            dotsColor: Color(0xFF333A47),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.all(12),
            width: double.infinity,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                Text("${data}"),
                Icon(Icons.edit),
              ],
            ),
          )
        ]);
      },
    );
  }
}

/* 
CalendarTimeline(
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(Duration(days: 365)),
          onDateSelected: (date) => print(date),
          leftMargin: 20,
          monthColor: Colors.pink.withOpacity(.7),
          dayColor: Colors.teal[200],
          dayNameColor: Color(0xFF333A47),
          activeDayColor: Colors.white,
          activeBackgroundDayColor: Colors.pink.withOpacity(.7),
          dotsColor: Color(0xFF333A47),
        );
 */
