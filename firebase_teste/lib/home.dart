import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


initState(){
  Firestore.instance.collection("Teste").add({"nome":"Gabs"});
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.network(
              "https://miro.medium.com/max/1024/1*HFlYgB6gVLc4Su9HsB9MZg.png",
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 13,
                itemBuilder: (context, index) {
                  return ListTile(
                    
                    onLongPress: (){
                      showDialog(
                        context: context,
                        builder: (c){
                          return AlertDialog(
                            title: Text("Aviso"),
                            content: Text("Deseja selecionar essa mensagem?"),
                            actions: <Widget>[
                              FlatButton(
                                child: Text("Sim"),
                                onPressed: (){},
                              ),
                              FlatButton(
                                child: Text("Não"),
                                onPressed: (){},
                              )
                            ],
                          );
                        }
                      );
                    },
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Usuário"),
                        Icon(Icons.verified_user),                        
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
