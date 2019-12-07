import 'dart:async';

import 'package:flutter/material.dart';

import 'Home.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    Timer(Duration(seconds: 2), (){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> Home()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xff0066cc),
        padding: EdgeInsets.all(60),
        child: Center(
          child: Image.asset("imagens/logo.png"),
        ),
      ),
    );
  }
}
