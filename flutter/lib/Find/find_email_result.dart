import 'package:flutter/material.dart';
import 'package:hackerton/Email/email_login_page.dart';
import 'package:hackerton/State/find_state.dart';
import 'package:provider/provider.dart';

class FindEmailResultPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "이메일 찾기 결과 페이지",
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text("이메일 찾기 결과",
              style: TextStyle(fontSize: 15.0, color: Colors.black)),
          leading: IconButton(
              icon: Icon(Icons.keyboard_arrow_left, color: Colors.black),
              onPressed: () => Navigator.pop(context)),
        ),
        body: Container(
            padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: MediaQuery.of(context).size.height / 3.5),
                  Text("회원님의 이메일로", style: TextStyle(fontSize: 20.0)),
                  Text("임시 비밀번호를 발송했습니다.", style: TextStyle(fontSize: 20.0)),
                  SizedBox(height: 20.0),
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    height: 48.0,
                    padding: EdgeInsets.only(left: 20.0, right: 20.0),
                    color: Color(0xFF8D92A3),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Consumer<FindState>(
                            builder: (context, state, child) {
                              return Text("${state.getInfo()}",
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold));
                            },
                          ),
                          Consumer<FindState>(
                            builder: (context, state, child) {
                              return Text("본인인증 ${state.getRegisterDate()} 가입", style: TextStyle(fontSize: 12.0));
                            },
                          )
                        ]),
                  ),
                  Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 48.0,
                            child: RaisedButton(
                              color: Color(0xFF6830F7),
                              child: Text("로그인 창으로 돌아가기",
                                  style: TextStyle(color: Colors.white)),
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EmailLoginPage())),
                            ),
                          )
                        ],
                      ))
                ])),
      ),
    );
  }
}
