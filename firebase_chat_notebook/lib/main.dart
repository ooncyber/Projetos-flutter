import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main(){
  Firestore.instance.collection("teste").document("Teste").setData({"Nome":"Gabriel"});
  runApp(MaterialApp(home: App(), debugShowCheckedModeBanner: false,));
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}