import 'dart:async';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

// import 'oldCronometro.dart';

main() async {
  runApp(MaterialApp(
    home: Home(),
    debugShowCheckedModeBanner: false,
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List tarefas = [];

  String _hora = "00:00:00";
  String _pause = "00:00:00.00";
  String _micro = "00";

  var stopwatch = Stopwatch();
  var stopwatch2 = Stopwatch();

  String data = "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";
  String horas = "${DateTime.now().hour}:${DateTime.now().minute}";

  FlutterLocalNotificationsPlugin f = new FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    var android = AndroidInitializationSettings('@mipmap/ic_launcher');
    var settings = InitializationSettings(android, null);
    f.initialize(settings, onSelectNotification: (_) {
      print(_);
    });
  }

  _notificar() async {
    var a = AndroidNotificationDetails("1", "Gab", "Canal",
        indeterminate: true, onlyAlertOnce: false);
    var p = NotificationDetails(a, null);
    await f.show(0, "Tempo atingido!", _hora, p);
    Timer(Duration(milliseconds: 100), () async {
      await f.show(0, "Tempo atingido!", "$_hora", p);
    });
  }

  TextEditingController txtTarefa = new TextEditingController();
  TextEditingController txtAlterarHora = new TextEditingController();
  var maskFormatter = MaskTextInputFormatter(mask: "##:##:##");

  @override
  Widget build(BuildContext context) {
    var telaLargura = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 1));
        },
        child: SingleChildScrollView(
            child: Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.05),
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Text("$data - $horas"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          InkWell(
                            onLongPress: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text("Alteração de hora"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text("Digite o valor que queria alterar"),
                                      TextField(
                                        inputFormatters: [maskFormatter],
                                        controller: txtAlterarHora,
                                        keyboardType: TextInputType.datetime,
                                        decoration:
                                            InputDecoration(labelText: _hora),
                                      )
                                    ],
                                  ),
                                  actions: <Widget>[
                                    RaisedButton(
                                      child: Text(
                                        "Alterar",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      onPressed: () {
                                        _hora = txtAlterarHora.text;
                                        Navigator.pop(context);
                                      },
                                    ),
                                    RaisedButton(
                                      color: Colors.white,
                                      child: Text(
                                        "Cancelar",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Text(
                              _hora,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.2),
                            ),
                          ),
                          Text(_micro, style: TextStyle(color: Colors.white)),
                        ],
                      ),
                      Text(
                        _pause,
                        style: TextStyle(color: Colors.grey),
                      ),

                      Container(
                          child: Row(
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                                controller: txtTarefa,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: telaLargura * 0.1),
                                decoration: InputDecoration(
                                  labelText: "Tarefa",
                                  labelStyle: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.07,
                                      color: Colors.white),
                                )),
                          ),
                          IconButton(
                            icon: Icon(Icons.check_box),
                            iconSize: telaLargura * 0.14,
                            onPressed: () {
                              return showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text("Deseja salvar?"),
                                      actions: <Widget>[
                                        RaisedButton(
                                          child: Text(
                                            "Sim",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          onPressed: () {
                                            _salvar();
                                            Navigator.pop(context);
                                          },
                                        ),
                                        RaisedButton(
                                          child: Text(
                                            "Não",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          color: Colors.white,
                                        ),
                                      ],
                                    );
                                  });
                            },
                            color: Colors.white,
                            tooltip: "Confirmar ação",
                          ),
                        ],
                      )),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.pause_circle_filled),
                            iconSize: telaLargura * 0.14,
                            onPressed: () {
                              _parar();
                              _iniciarPause();
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.play_circle_filled),
                            iconSize: telaLargura * 0.2,
                            onPressed: () {
                              _iniciar();
                              _resetarPause();
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.stop),
                            iconSize: telaLargura * 0.14,
                            onPressed: () {
                              _resetarPergunta();
                            },
                          ),
                        ],
                      ),

                      //TODO tarefas
                      Container(
                        child: Text(
                          "Tarefas",
                          style: TextStyle(fontSize: telaLargura * 0.06),
                        ),
                      ),
                      Container(
                        height: telaLargura,
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: tarefas.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onDoubleTap: () {
                                setState(() {
                                  tarefas.removeAt(index);
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.only(bottom: 10, top: 10),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Text(tarefas[index]['titulo'],
                                          style: TextStyle(
                                              fontSize: telaLargura * 0.05)),
                                      Text(tarefas[index]['tempo'],
                                          style: TextStyle(
                                              fontSize: telaLargura * 0.05)),
                                    ]),
                              ),
                              onTap: () {},
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ))),
      ),
    );
  }

  void _iniciar() {
    stopwatch.start();
    Timer(Duration(milliseconds: 50), () {
      if (stopwatch.isRunning) {
        _atualizar();
        _iniciar();
      }
    });
  }

  void _parar() {
    stopwatch.stop();
  }

  Future<Widget> _resetarPergunta() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Resetar cronometro de ${_hora}?"),
            actions: <Widget>[
              RaisedButton(
                child: Text(
                  "Sim",
                  style: TextStyle(color: Colors.black),
                ),
                color: Colors.white,
                onPressed: () {
                  _resetar();
                  Navigator.pop(context);
                },
              ),
              RaisedButton(
                child: Text(
                  "Não",
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  void _resetar() {
    stopwatch.reset();
    _atualizar();
    stopwatch.stop();
  }

  void _atualizar() {
    var hora = (stopwatch.elapsed.inHours % 60).toString().padLeft(2, "0");
    var minuto = (stopwatch.elapsed.inMinutes % 60).toString().padLeft(2, "0");
    var segundo = (stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, "0");
    var micro = (stopwatch.elapsed.inMilliseconds % 1000)
        .toString()
        .padLeft(3, "0")
        .substring(0, 2);
    setState(() {
      if (stopwatch.elapsed.inMinutes % 60 == 25) _notificar();

      _hora = "${hora}:${minuto}:${segundo}";
      _micro = micro;
    });
  }

  void _salvar() {
    var tempo = _hora;
    var tarefa = txtTarefa.text;

    Map<String, dynamic> map = Map();
    map['titulo'] = tarefa;
    map['tempo'] = tempo;
    stopwatch.reset();
    txtTarefa.text = "";
    _iniciar();
    setState(() {
      tarefas.add(map);
    });
  }

  void _resetarPause() {
    stopwatch2.stop();
  }

  void _iniciarPause() {
    stopwatch2.start();
    Timer(Duration(milliseconds: 1), () {
      if (stopwatch2.isRunning) _iniciarPause();
      setState(() {
        var m = (stopwatch2.elapsed.inMinutes % 60).toString().padLeft(2, "0");
        var h = (stopwatch2.elapsed.inHours % 60).toString().padLeft(2, "0");
        var s = (stopwatch2.elapsed.inSeconds % 60).toString().padLeft(2, "0");
        var ms = (stopwatch2.elapsed.inMilliseconds % 1000)
            .toString()
            .padLeft(3, "0")
            .substring(0, 2);

        setState(() {
          _pause = "$h:$m:$s.$ms";
        });
      });
    });
  }
}
