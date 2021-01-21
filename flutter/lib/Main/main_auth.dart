import 'package:flutter/material.dart';

class MainAuthPage extends StatefulWidget {
  @override
  _MainAuthPageState createState() => _MainAuthPageState();
}

class _MainAuthPageState extends State<MainAuthPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "인증 페이지",
      home: Scaffold(
        body: Center(
          child: Text("인증"),
        ),
      ),
    );
  }
}
