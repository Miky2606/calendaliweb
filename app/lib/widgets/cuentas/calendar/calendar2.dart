import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:date_format/date_format.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class calendar extends StatefulWidget {
  final cuenta;
  calendar({Key key, this.cuenta}) : super(key: key);

  @override
  _calendarState createState() => _calendarState();
}

class _calendarState extends State<calendar> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  var initializationSettingsAndroid;
  var initializationSettingsIOS;
  var initializationSettings;
  final scaffold = GlobalKey<ScaffoldState>();
  Map dayTask;
  List task;
  var _initialDate = DateTime.now();
  final newTask = TextEditingController();

  @override
  void initState() {
    initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    initializationSettingsIOS = new IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotifications);

    getUser(_initialDate);
    super.initState();
  }

  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<void> notifications() async {
    var android = AndroidNotificationDetails(
        'channel_ID', 'vhannel_name', 'channel_description',
        importance: Importance.Max, priority: Priority.High, ticker: "test");

    var ios = IOSNotificationDetails();
    var platform = NotificationDetails(android, ios);

    await flutterLocalNotificationsPlugin.show(0, "hello", "message", platform,
        payload: "test");
  }

  Future selectNotifications(String payload) async {
    if (payload != null) {
      print(payload);
    }
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          AlertDialog(
            title: Text(title),
            content: Text(body),
          );
        });
  }

  Future<String> getUser(date) async {
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
      notifications();

      setState(() {
        task = dayTask["profile"];
        _initialDate = date;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CalendarTimeline(
          initialDate: _initialDate,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(Duration(days: 365)),
          onDateSelected: (date) {
            getUser(date);
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
        RaisedButton(
            onPressed: () {
              notifications();
            },
            child: Icon(Icons.add)),
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
                                key: scaffold,
                                body: ListView(children: [
                                  Center(
                                      child: Text("Crear Tarea",
                                          style: TextStyle(
                                              fontFamily: "Indie",
                                              fontSize: 40))),
                                  TextField(
                                    controller: newTask,
                                    decoration:
                                        InputDecoration(labelText: "Task"),
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
            : Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: task.length,
                    itemBuilder: (BuildContext context, int index) {
                      final taskKey = task[index]["task"];
                      return Card(
                          child: Dismissible(
                              key: Key(taskKey),
                              onDismissed: (direction) {
                                deleteTarea(task[index]["id"]);
                              },
                              child: Container(
                                  padding: EdgeInsets.all(12),
                                  width: double.infinity,
                                  height: 80,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.pink.withOpacity(.7)),
                                  child: Stack(
                                    children: [
                                      Center(
                                          child:
                                              Text("${task[index]["task"]}")),
                                      InkWell(
                                          onTap: () {
                                            var datos = {
                                              "id": task[index]["id"],
                                              "task": task[index]["task"]
                                            };
                                            editTask(datos);
                                          },
                                          child: Align(
                                              alignment: Alignment.topRight,
                                              child: Icon(Icons.edit))),
                                    ],
                                  ))));
                    })),
      ],
    );
  }

  Future<String> deleteTarea(id) async {
    var response = await http
        .delete("https://calendaliapi.herokuapp.com/api/deleteTarea/${id}");

    if (response.body == "Eliminado") {
      getUser(_initialDate);
    }
  }

  Future<String> _crearTask(datos) async {
    var dateTask = new DateFormat('yyyy-MM-dd').format(datos["date"]);

    Map<String, dynamic> tarea = {
      "cuenta": widget.cuenta,
      "task": datos['tarea'],
      "fechaTask": dateTask,
    };
    var response = await http
        .post("https://calendaliapi.herokuapp.com/api/addTarea", body: tarea);
    if (response.body.length > 0) {
      getUser(_initialDate);
    }
  }

  Future<String> editTask(datos) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: Container(
                  width: 300.0,
                  height: 300,
                  child: Scaffold(
                      key: scaffold,
                      body: ListView(children: [
                        Center(
                            child: Text("Editar Tarea",
                                style: TextStyle(
                                    fontFamily: "Indie", fontSize: 40))),
                        TextField(
                          controller: newTask,
                          decoration: InputDecoration(
                              labelText: "Task", hintText: datos['task']),
                        ),
                        SizedBox(height: 30),
                        RaisedButton(
                          onPressed: () {
                            var datosTask = {
                              "id": datos['id'],
                              "tarea": newTask.text
                            };
                            _editarTask(datosTask);
                          },
                          child: Text("Enviar"),
                          color: Colors.pink.withOpacity(.7),
                        )
                      ]))));
        });
  }

  Future<String> _editarTask(datosTask) async {
    if (datosTask['tarea'] == "") {
      var snackbar = SnackBar(content: Text('Tarea no puede estar en blanco'));
      scaffold.currentState.showSnackBar(snackbar);
    } else {
      Map<String, dynamic> datos = {
        "id": datosTask["id"],
        "tarea": datosTask['tarea']
      };

      var jsons = json.encode(datos);

      var response = await http.put(
        "https://calendaliapi.herokuapp.com/api/cambiarTarea",
        body: jsons,
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
        },
      );

      if (response.body == "yes") {
        getUser(_initialDate);
      }
    }
  }
}
