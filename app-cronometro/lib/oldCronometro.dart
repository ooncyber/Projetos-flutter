import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String timerProcrastinacao = "00:00:00";
  String timerEstudo = "00:00:00";
  String timerOutro = "00:00:00";
  String timerGeral = "00:00:00";
  var outroIniciado = false;
  var corGeral = Colors.white;

  var swatch1 = Stopwatch();
  var swatch2 = Stopwatch();
  var swatch3 = Stopwatch();
  var swatch4 = Stopwatch();
  final dur = const Duration(seconds: 1);

  void starttimer1() {
    Timer(dur, () {
      if (swatch1.isRunning) starttimer1();

      setState(() {
        timerProcrastinacao =
            swatch1.elapsed.inHours.toString().padLeft(2, "0") +
                ":" +
                (swatch1.elapsed.inMinutes % 60).toString().padLeft(2, "0") +
                ":" +
                (swatch1.elapsed.inSeconds % 60).toString().padLeft(2, "0");
      });
    });
  }

  void starttimer2() {
    Timer(dur, () {
      if (swatch2.isRunning) starttimer2();

      setState(() {
        timerEstudo = swatch2.elapsed.inHours.toString().padLeft(2, "0") +
            ":" +
            (swatch2.elapsed.inMinutes % 60).toString().padLeft(2, "0") +
            ":" +
            (swatch2.elapsed.inSeconds % 60).toString().padLeft(2, "0");
      });
    });
  }

  void starttimer3() {
    Timer(dur, () {
      if (swatch3.isRunning) starttimer3();

      setState(() {
        timerOutro = swatch3.elapsed.inHours.toString().padLeft(2, "0") +
            ":" +
            (swatch3.elapsed.inMinutes % 60).toString().padLeft(2, "0") +
            ":" +
            (swatch3.elapsed.inSeconds % 60).toString().padLeft(2, "0");
      });
    });
  }

  void starttimer4() {
    Timer(dur, () {
      if (swatch4.isRunning) starttimer4();
      setState(() {
        timerGeral = swatch4.elapsed.inHours.toString().padLeft(2, "0") +
            ":" +
            (swatch4.elapsed.inMinutes % 60).toString().padLeft(2, "0") +
            ":" +
            (swatch4.elapsed.inSeconds % 60).toString().padLeft(2, "0");
      });
    });
  }

  void iniciarProcrastinacao() {
    swatch1.start();
    starttimer1();
    iniciarGeral();
  }

  void pararProcrastinacao() {
    swatch1.stop();
    starttimer1();
  }

  void iniciarEstudo() {
    swatch2.start();
    starttimer2();
    iniciarGeral();
  }

  void pararEstudo() {
    swatch2.stop();
    starttimer2();
  }

  void iniciarOutro() {
    swatch3.start();
    starttimer3();
    iniciarGeral();
  }

  void pararOutro() {
    swatch3.stop();
    starttimer3();
  }

  void iniciarGeral() {
    corGeral = Colors.green;
    swatch4.start();
    starttimer4();
    outroIniciado = true;
  }

  void pararGeral() {
    swatch4.stop();
    starttimer4();
    outroIniciado = false;
  }

  String data(int day) {
    String msg = "";
    switch (day) {
      case 1:
        msg = "Segunda-feira";
        break;
      case 2:
        msg = "Terça-feira";
        break;
      case 3:
        msg = "Quarta-feira";
        break;
      case 4:
        msg = "Quinta-feira";
        break;
      case 5:
        msg = "Sexta-feira";
        break;
      case 6:
        msg = "Sábado";
        break;
      case 7:
        msg = "Domingo";
        break;
    }
    return msg;
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initSetttings = new InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) {
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text('Nova notificação!'),
        content: new Text('$payload'),
      ),
    );
  }

  showNotification() async {
    var android = new AndroidNotificationDetails(
      'channel id',
      'channel NAME',
      'CHANNEL DESCRIPTION',
      channelShowBadge: false,
      priority: Priority.High,
      importance: Importance.Max,
      indeterminate: false,
      onlyAlertOnce: true,
      showProgress: true,
    );
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show(
        0, 'Timer brabo',timerGeral, platform,
        payload: 'Nitish Kumar Singh is part time Youtuber');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff006DC1),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
                // MediaQuery.of(context).size.height
                child: Container(
              margin: EdgeInsets.only(
                top: 70,
              ),
              child: RaisedButton(
                onPressed: () {
                  outroIniciado ? pararGeral() : iniciarGeral();
                  showNotification();
                },
                child: Text(
                  timerGeral,
                  style: TextStyle(color: corGeral, fontSize: 80),
                ),
              ),
            )),
            Container(
              child: Column(
                children: <Widget>[
                  Text(
                      "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}"),
                  Text(data(DateTime.now().weekday))
                ],
              ),
              margin: EdgeInsets.only(bottom: 100, top: 10),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              width: MediaQuery.of(context).size.width - 70,
              height: 40,
              child: DecoratedBox(
                  child: Center(
                      child: Row(
                    children: <Widget>[
                      Container(
                        child: Text(
                          timerProcrastinacao,
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                        margin: EdgeInsets.only(right: 20, left: 5),
                      ),
                      Expanded(
                        child: Text("Procrastinação",
                            style:
                                TextStyle(color: Colors.black, fontSize: 15)),
                      ),
                      IconButton(
                        icon: Icon(Icons.pause),
                        onPressed: pararProcrastinacao,
                      ),
                      IconButton(
                        icon: Icon(Icons.play_arrow),
                        onPressed: iniciarProcrastinacao,
                      ),
                    ],
                  )),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30))),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              width: MediaQuery.of(context).size.width - 70,
              height: 40,
              child: DecoratedBox(
                  child: Center(
                      child: Row(
                    children: <Widget>[
                      Container(
                        child: Text(
                          timerEstudo,
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                        margin: EdgeInsets.only(right: 20, left: 5),
                      ),
                      Expanded(
                        child: Text("Estudo",
                            style:
                                TextStyle(color: Colors.black, fontSize: 15)),
                      ),
                      IconButton(
                        icon: Icon(Icons.pause),
                        onPressed: pararEstudo,
                      ),
                      IconButton(
                        icon: Icon(Icons.play_arrow),
                        onPressed: iniciarEstudo,
                      ),
                    ],
                  )),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30))),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              width: MediaQuery.of(context).size.width - 70,
              height: 40,
              child: DecoratedBox(
                  child: Center(
                      child: Row(
                    children: <Widget>[
                      Container(
                        child: Text(
                          timerOutro,
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                        margin: EdgeInsets.only(right: 20, left: 5),
                      ),
                      Expanded(
                        child: Text("Outro",
                            style:
                                TextStyle(color: Colors.black, fontSize: 15)),
                      ),
                      IconButton(
                        icon: Icon(Icons.pause),
                        onPressed: pararOutro,
                      ),
                      IconButton(
                        icon: Icon(Icons.play_arrow),
                        onPressed: iniciarOutro,
                      ),
                    ],
                  )),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30))),
            ),
          ],
        ),
      ),
    );
  }
}
