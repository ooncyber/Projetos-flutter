import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(MaterialApp(
      home: Home(),
      debugShowCheckedModeBanner: false,
    ));

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var txtAlgo = TextEditingController();
  var txtSobrenome = TextEditingController();
  var txtNome = TextEditingController();

  Future<File> _localFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }

  Future<File> _escrever() async {
    final file = await _localFile();
    return file.writeAsString("oi");
  }

  Future<String> _ler() async {
    try {
      final file = await _localFile();

      String conteudo = await file.readAsString();
      return conteudo;
    } catch (e) {
      return null;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _ler().then((dados) {
      txtAlgo.text = dados;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Local Storage"),
      ),
      body: Center(
        child: Container(
          child: Column(
            children: <Widget>[
              RaisedButton(
                child: Text("Salvar"),
                onPressed: () {
                  _escrever();
                },
              ),
              Row(
                children: <Widget>[
                  SizedBox(width: 30),
                  Expanded(
                    child: TextField(
                      controller: txtNome,
                      decoration: InputDecoration(labelText: "Nome"),
                    ),
                  ),
                  SizedBox(width: 30),
                  Expanded(
                    child: TextField(
                      controller: txtSobrenome,
                      decoration: InputDecoration(labelText: "Sobrenome"),
                    ),
                  ),
                  SizedBox(width: 30),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
