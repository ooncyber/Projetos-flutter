import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(MaterialApp(home: MyApp()));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _c = TextEditingController();
  List _editing = [];

  List _lista = List();

  Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File("${dir.path}/dados.json");
  }

  _salvarArquivo() async {
    var arq = await _getFile();
    arq.writeAsStringSync(json.encode(_lista));
  }

  void _salvarDados() async {
    //se for modo editing apenas atualiza
    if (_editing.contains(true)) {
      setState(() {
        _lista[_editing[1]]['titulo'] = _c.text;
      });
      _salvarArquivo();
      _c.clear();
      _editing = [];
      return;
    }
    //cria lista
    Map<String, dynamic> tarefa = Map();
    tarefa['titulo'] = _c.text;
    tarefa['realizada'] = false;
    setState(() {
      _lista.add(tarefa);
      _c.clear();
    });
    _salvarArquivo();
  }

  _ler() async {
    try {
      final arq = await _getFile();
      return arq.readAsString();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  @override
  void initState() {
    _ler().then((dados) {
      setState(() {
        _lista = json.decode(dados);
        print(_lista);
      });
    });
  }

  Widget criaDismiss(context, index) {
    Map<String, dynamic> _ultimoItem = Map();

    //snackbar
    final snackbar = SnackBar(
      content: Text("Tarefa removida"),
      duration: Duration(seconds: 5),
      action: SnackBarAction(
          label: "Desfazer",
          onPressed: () {
            setState(() {
              _lista.insert(index, _ultimoItem);
            });
            _salvarArquivo();
          }),
    );
    // Scaffold.of(context).showSnackBar(snackbar);

    return Slidable(
      actionPane: SlidableBehindActionPane(),
      actionExtentRatio: 0.25,
      child: Container(
        color: Colors.white,
        child: CheckboxListTile(
          title: Text(_lista[index]['titulo']),
          value: _lista[index]['realizada'],
          onChanged: (value) {
            setState(() {
              _lista[index]['realizada'] = value;
            });
            _salvarArquivo();
          },
        ),
      ),
      actions: <Widget>[
        IconSlideAction(
          caption: 'Deletar',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () {
            _ultimoItem = _lista[index];
            setState(() {
              _lista.removeAt(index);
            });
            _salvarArquivo();
            Scaffold.of(context).showSnackBar(snackbar);
          },
        ),
        IconSlideAction(
          caption: 'Editar',
          color: Colors.green,
          icon: Icons.edit,
          onTap: () {
            _c.text = _lista[index]['titulo'];
            _editing = [true, index];
          },
        ),
      ],
    );

    // return Slidable(
    //   actionPane: SlidableDrawerActionPane(),
    //   actionExtentRatio: 0.25,
    //   child: Container(
    //     child: ListTile(
    //       title: Text("teste"),
    //       subtitle: Text("sub"),
    //     ),
    //   ),
    //   actions: <Widget>[
    //     IconSlideAction(
    //       caption: 'Deletar',
    //       color: Colors.red,
    //       icon: Icons.delete,
    //       onTap: () {},
    //     ),
    //     IconSlideAction(
    //       caption: 'Editar',
    //       color: Colors.green,
    //       icon: Icons.edit,
    //       onTap: () {},
    //     ),
    //   ],
    // );
    // return Dismissible(
    //   direction: DismissDirection.horizontal,
    //   background: Container(
    //     color: Colors.red,
    //     child: Icon(
    //       Icons.delete,
    //       color: Colors.white,
    //     ),
    //     alignment: AlignmentDirectional.centerStart,
    //     padding: EdgeInsets.only(left: 20),
    //   ),
    //   secondaryBackground: Container(
    //     color: Colors.green,
    //     child: Icon(
    //       Icons.edit,
    //       color: Colors.white,
    //     ),
    //     alignment: AlignmentDirectional.centerEnd,
    //     padding: EdgeInsets.only(right: 20),
    //   ),
    //   onDismissed: (direction) {
    //     if (direction == DismissDirection.startToEnd) {
    //       _ultimoItem = _lista[index];

    //       _lista.removeAt(index);
    //       _salvarArquivo();

    //       //snackbar
    //       final snackbar = SnackBar(
    //         content: Text("Tarefa removida"),
    //         duration: Duration(seconds: 5),
    //         action: SnackBarAction(
    //             label: "Desfazer",
    //             onPressed: () {
    //               setState(() {
    //                 _lista.insert(index, _ultimoItem);
    //               });
    //               _salvarArquivo();
    //             }),
    //       );
    //       Scaffold.of(context).showSnackBar(snackbar);
    //     } else
    //       //todo edit
    //       print('');
    //   },
    //   key: Key(_lista[index]['titulo'] +
    //       DateTime.now().millisecondsSinceEpoch.toString()),
    //   child: CheckboxListTile(
    //     title: Text(_lista[index]['titulo']),
    //     value: _lista[index]['realizada'],
    //     onChanged: (value) {
    //       setState(() {
    //         _lista[index]['realizada'] = value;
    //       });
    //       _salvarArquivo();
    //     },
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Armazenagem de dados')),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  decoration: InputDecoration(labelText: "Digite a tarefa"),
                  controller: _c,
                ),
              ),
              RaisedButton(
                onPressed: _salvarDados,
                child: Text("Salvar"),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
                itemCount: _lista.length, itemBuilder: criaDismiss),
          )
        ],
      ),
    );
  }
}
