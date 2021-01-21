import 'package:flutter/material.dart';
import 'package:hackerton/Home/home_login_page.dart';
import 'package:hackerton/State/find_state.dart';
import 'package:hackerton/State/page_navi_state.dart';
import 'package:hackerton/State/register_state.dart';
import 'package:hackerton/Time/stopwatch.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => PageNaviState()),
      ChangeNotifierProvider(create: (context) => FindState()),
      ChangeNotifierProvider(create: (context) => RegisterState()),
      ChangeNotifierProvider(create: (context) => AboutTime())
    ],
    child: FirstPage(),
  ));
}

class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "홈 로그인 화면",
      home: HomeLoginPage(),
    );
  }
}
