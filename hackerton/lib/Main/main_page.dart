import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'main_auth.dart';
import 'main_feed.dart';
import 'main_guild.dart';
import 'main_home.dart';
import 'main_my.dart';

class MainNavigation extends StatefulWidget {
  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[
    MainHomePage(),
    MainFeedPage(),
    MainAuthPage(),
    MainGuildPage(),
    MainMyPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "메인 페이지",
        home: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Center(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.black,
            elevation: 0,

            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Image.asset("assets/png/home.png", height: 18.0, color: Colors.white),
                  label: "홈"),
              BottomNavigationBarItem(
                  icon: Image.asset("assets/png/feed.png", height: 18.0, color: Colors.white),
                  label: "피드"),
              BottomNavigationBarItem(
                  icon: Image.asset("assets/png/auth.png", height: 20.0, color: Colors.white),
                  label: "인증샷"),
              BottomNavigationBarItem(
                  icon: Image.asset("assets/png/guild.png", height: 23.0, color: Colors.white),
                  label: "길드",),
              BottomNavigationBarItem(
                  icon: Image.asset("assets/png/my.png", height: 18.0, color: Colors.white,),
                  label: "마이페이지"),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Color(0xFFA8A344),
            unselectedItemColor: Colors.white,
            onTap: _onItemTapped,
          ),
        ));
  }
}
