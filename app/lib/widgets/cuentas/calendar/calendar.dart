import 'package:app/widgets/inicio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:date_format/date_format.dart';
import 'package:http/http.dart' as http;
import 'package:calendar_timeline/calendar_timeline.dart';
import 'dart:convert';
import 'dart:async';

class calendar extends StatefulWidget {
  final cuenta;
  calendar({Key key, this.cuenta}) : super(key: key);

  @override
  _calendarState createState() => _calendarState();
}

class _calendarState extends State<calendar> {
  var _initialDate = DateTime.now();
  final newTask = TextEditingController();

  Map dayTask;
  List task;

  Widget build(BuildContext context) {
    return ListView(shrinkWrap: true, children: [
      CalendarTimeline(
        initialDate: _initialDate,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 365)),
        onDateSelected: (date) async {
          var day = new DateFormat('yyyy-MM-dd').format(date);

          var response = await http.get(
              "https://calendaliapi.herokuapp.com/api/findDayTarea/${widget.cuenta}",
              headers: {"date": day});

          if (response.body == "no hay") {
            setState(() {
              task = null;
              _initialDate = date;
            });
          } else {
            dayTask = json.decode(response.body);

            setState(() {
              task = dayTask["profile"];
              _initialDate = date;
            });
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
      FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                      content: Container(
                          width: 300.0,
                          height: 300,
                          child: Scaffold(
                              body: ListView(children: [
                            Center(
                                child: Text("Crear Tarea",
                                    style: TextStyle(
                                        fontFamily: "Indie", fontSize: 40))),
                            TextField(
                              controller: newTask,
                              decoration: InputDecoration(labelText: "Task"),
                            ),
                            SizedBox(height: 30),
                            RaisedButton(
                              onPressed: () {
                                var datosTask = {
                                  "date": _initialDate,
                                  "tarea": newTask.text
                                };
                                _crearTask(datosTask);
                              },
                              child: Text("Enviar"),
                              color: Colors.pink.withOpacity(.7),
                            )
                          ]))));
                });
          },
          child: Icon(Icons.add)),
      SizedBox(
        height: 20,
      ),
      task == null
          ? Center(child: Text("no hay ${this.widget.cuenta}"))
          : ListView.builder(
              shrinkWrap: true,
              itemCount: task.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                    child: Container(
                        padding: EdgeInsets.all(12),
                        width: double.infinity,
                        height: 80,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.pink.withOpacity(.7)),
                        child: Stack(
                          children: [
                            Center(child: Text("${task[index]["task"]}")),
                            InkWell(
                                onTap: () {
                                  deleteTarea(task[index]["id"]);
                                },
                                child: Icon(Icons.delete)),
                          ],
                        )));
              }),
    ]);
  }

  Future<String> _crearTask(datos) async {
    var dateTask = new DateFormat('yyyy-MM-dd').format(datos["date"]);

    Map<String, dynamic> tarea = {
      "cuenta": widget.cuenta,
      "task": datos['tarea'],
      "fechaTask": dateTask,
    };

    var response =
        await http.post("http://10.0.0.114:3000/api/addTarea", body: tarea);

    if (response.body.length > 0) {
      var respuesta = await http.get(
          "https://calendaliapi.herokuapp.com/api/findDayTarea/${widget.cuenta}",
          headers: {"date": dateTask});
      dayTask = json.decode(respuesta.body);
      setState(() {
        task = dayTask["profile"];
      });
    }
  }

  Future<String> deleteTarea(id) async {
    var dateTask = new DateFormat('yyyy-MM-dd').format(_initialDate);

    var response =
        await http.delete("http://10.0.0.114:3000/api/deleteTarea/${id}");
    if (response.body == "Eliminado") {
      var respuesta = await http.get(
          "https://calendaliapi.herokuapp.com/api/findDayTarea/${widget.cuenta}",
          headers: {"date": dateTask});
      if (respuesta.body == "no hay") {
        setState(() {
          task = null;
        });
      } else {
        dayTask = json.decode(respuesta.body);
        setState(() {
          task = dayTask["profile"];
        });
      }
    }
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
/* */
