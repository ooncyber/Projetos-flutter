import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  double _preco = 0;

  void _recuperarPreco() async{
    String url = 'https://www.blockchain.com/ticker';

    http.Response resp = await http.get(url);
    Map<String,dynamic> retorno = json.decode(resp.body);

    setState(() {
     _preco = retorno['BRL']['buy']; 
    });
    
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(32),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset("imagens/bitcoin.png"),
              Padding(
                padding: EdgeInsets.only(top: 30, bottom: 30),
                child: Text("R\$ ${_preco}",
                style: TextStyle(
                  fontSize: 35
                ),),
              ),
              RaisedButton(
                child: Text("Atualizar", style: TextStyle(
                  fontSize: 20,
                  color: Colors.white
                ),),
                color: Colors.orange,
                padding: EdgeInsets.fromLTRB(30, 15, 30, 15),
                onPressed: _recuperarPreco,
              )
            ],
          ),
        ),
      ),
    );
  }
}