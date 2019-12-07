import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    _readData().then((dados) {
      setState(() {
        _toDoList = json.decode(dados);
      });
    });
  }

  List _toDoList = [];

  void _addToDo() {
    setState(() {
      Map<String, dynamic> newToDo = Map();

      newToDo['title'] = c.text;
      newToDo['ok'] = false;

      c.text = "";

      _toDoList.add(newToDo);
      _saveData();
    });
  }

  TextEditingController c = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de tarefas"),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                Expanded(
                    child: TextField(
                  controller: c,
                  decoration: InputDecoration(
                    labelText: "Nova tarefa",
                  ),
                )),
                RaisedButton(
                  color: Colors.blueAccent,
                  child: Text("ADD"),
                  onPressed: _addToDo,
                )
              ],
            ),
          ),
          Expanded(
              child: RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              itemCount: _toDoList.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  onDismissed: (direction) {
                    showDialog(
                        context: context,
                        builder: (c) {
                          return AlertDialog(
                            title: Text(_toDoList[index]['title'].toString() +
                                " removida"),
                            actions: <Widget>[
                              RaisedButton(
                                  child: Text("Ok",
                                      style: TextStyle(color: Colors.white)),
                                  onPressed: () {
                                    _toDoList.removeAt(index);
                                    _saveData();
                                    Navigator.pop(c);
                                  }),
                              RaisedButton(
                                onPressed: () => Navigator.pop(c),
                                child: Text(
                                  "Cancelar",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          );
                        });
                  },
                  key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
                  direction: DismissDirection.startToEnd,
                  background: Container(
                    color: Colors.red,
                    child: Align(
                      alignment: Alignment(-0.9, 0),
                      child: Icon(Icons.restore_from_trash),
                    ),
                  ),
                  child: CheckboxListTile(
                    onChanged: (c) {
                      setState(() {
                        _toDoList[index]['ok'] = c;
                      });
                    },
                    title: Text(_toDoList[index]['title']),
                    value: _toDoList[index]['ok'],
                    secondary: CircleAvatar(
                        child: Icon(_toDoList[index]['ok']
                            ? Icons.check
                            : Icons.error)),
                  ),
                );
              },
            ),
          ))
        ],
      ),
    );
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }

  Future<File> _saveData() async {
    String data = json.encode(_toDoList);
    final file = await _getFile();
    return file.writeAsString(data);
  }

  Future<String> _readData() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (e) {
      print("ERRROROROROROOR DE LEITURA ARQUIVO");
      return null;
    }
  }

  Future<Null> _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _toDoList.sort((a, b) {
        if (a['ok'] && !b['ok'])
          return 1;
        else if (!a['ok'] && b['ok'])
          return -1;
        else
          return 0;
      });
    });

    return null;
  }
}
