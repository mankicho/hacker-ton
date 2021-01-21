import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home:MyApp()));

class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Text('test'),
      ),
    );
  }

  onClick(){
    print('핵심 서비스');
  }
}