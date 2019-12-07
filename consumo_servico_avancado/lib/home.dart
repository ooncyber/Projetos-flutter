import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'Post.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  String _url = 'http://jsonplaceholder.typicode.com/posts';
  List<Post> postagens = List();

  Future<List<Post>> _recuperarPostagens() async {
    http.Response resp = await http.get(_url);

    var dados = json.decode(resp.body);

    for (var post in dados) {
      Post p = Post(post['userId'], post['id'], post['title'], post['body']);
      postagens.add(p);
    }
    return postagens;
  }

  _post() async{
    var corpo = json.encode({
      "title": 'foo',
      "body": 'bar',
      "userId": 1,
      "id": 1
    });

    http.Response resp = await http.post(_url,
    headers: {"Content-type": "application/json; charset=UTF-8"},
    body: corpo
    );

    print(resp.statusCode);
    print(resp.body);
  }
  _patch() async{

  }
  _put() async{

  }
  _delete() async{

  }

  @override
  Widget build(BuildContext context) {
    _post();
    return Scaffold(
      appBar: AppBar(
        title: Text("Consumo de serviços"),
      ),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                child: Text("Salvar"),
                onPressed: (){},
              ),
              RaisedButton(
                child: Text("Atualizar"),
                onPressed: (){},
              ),
              RaisedButton(
                child: Text("Remover"),
                onPressed: (){},
              ),
              
            ],
          ),
          Expanded(
            child: FutureBuilder<List<Post>>(
      future: _recuperarPostagens(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          return Center(child: CircularProgressIndicator(),);
            break;
          case ConnectionState.done:
            if(snapshot.hasError){
              print("Erro ao carregar");
            }else{
              print("Lista carregou");
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context,indice){
                  Post post = postagens[indice];
                  return ListTile(
                    title: Text(post.title == null ? "" : post.title),
                    subtitle: Text(post.id.toString()),
                  );
                },
              );
            }
            break;
          default:
          break;
        }

        return Center(
          child: Text("_res"),
        );
      },
    ),
          )
        ],
      )
    );
  }
}
