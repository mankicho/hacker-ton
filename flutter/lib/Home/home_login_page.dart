import 'package:flutter/material.dart';
import 'package:hackerton/Email/email_login_page.dart';
import 'package:hackerton/Register/register_page1.dart';
import 'package:hackerton/State/page_navi_state.dart';
import "package:http/http.dart" as http;
import 'package:provider/provider.dart';

class HomeLoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(20, 200, 20, 120),
        child: Center(
          child: Column(
            children: <Widget>[
              Text("간편하게 로그인하고", style: TextStyle(fontSize: 20.0)),
              Text("다양한 서비스를 이용하세요.",
                  style:
                  TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
              SizedBox(height: 20.0),
              SizedBox(height: 15.0),
              Container(
                padding: EdgeInsets.only(left: 55.0, right: 55.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    InkWell(
                      child: Text("이메일로 로그인",
                          style: TextStyle(fontSize: 13.0),
                          textAlign: TextAlign.center),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EmailLoginPage())),
                    ),
                    SizedBox(width: 20.0),
                    InkWell(
                      child: Text("회원가입",
                          style: TextStyle(fontSize: 13.0),
                          textAlign: TextAlign.center),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterPage1()));
                        PageNaviState pns = Provider.of<PageNaviState>(context, listen: false);
                        pns.setStart("home");
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
