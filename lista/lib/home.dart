import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _lista = [];

  void _carregaItens() {
    for (int i = 0; i < 5; i++) {
      Map<String, dynamic> item = Map();
      item['titulo'] = "Titulo do item ${i}";
      item['subtitulo'] = "Subtitulo do item ${i}";
      _lista.add(item);
    }
  }

  @override
  Widget build(BuildContext context) {
    _carregaItens();
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView.builder(
          itemCount: _lista.length,
          itemBuilder: (context, indice) {
            return ListTile(
              title: Text(_lista[indice]['titulo']),
              subtitle: Text(_lista[indice]['subtitulo']),
              onTap: () {},
              onLongPress: () {
                showDialog(
                  context: context,
                  builder: (c){
                    return AlertDialog(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Aviso"),
                          Icon(Icons.help)
                        ],
                      ),
                      content: Text("Deseja mesmo excluir?"),
                      actions: <Widget>[
                        FlatButton(
                          child: Text("Sim!"),
                          onPressed: (){},
                        ),
                        FlatButton(
                          child: Text("Não!"),
                          onPressed: (){},
                        )
                      ],
                    );
                  }
                );
              },
            );
          },
        ),
      ),
    );
  }
}
