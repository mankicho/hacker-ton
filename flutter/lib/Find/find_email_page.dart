import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hackerton/Email/email_login_page.dart';
import 'package:hackerton/State/find_state.dart';
import 'package:hackerton/Todo/todo_register.dart';
import 'package:provider/provider.dart';
import "package:http/http.dart" as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'find_email_result.dart';

class FindEmailPage extends StatefulWidget {
  @override
  State createState() => FindEmailPageState();
}

class FindEmailPageState extends State<FindEmailPage> {
  final TextEditingController _pNumController = new TextEditingController();
  final TextEditingController _authNumController = new TextEditingController();

  List<Widget> widgets = <Widget>[];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "이메일 찾기 페이지",
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text("이메일 찾기",
              style: TextStyle(fontSize: 15.0, color: Colors.black)),
          leading: IconButton(
              icon: Icon(Icons.keyboard_arrow_left, color: Colors.black),
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EmailLoginPage()))),
        ),
        body: Container(
          decoration: BoxDecoration(color: Colors.white),
          padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
          child: Column(children: <Widget>[
            TextField(
                enabled: _buttonChange ? false : true,
                controller: _pNumController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    suffix: (_isRequested&_buttonChange)
                        ? InkWell(
                      child: Text("재전송",
                          style: TextStyle(
                              color: Colors.red, fontSize: 12.0)),
                      onTap: () => _receiveAuthNum(),
                    )
                        : null,
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                    hintText: "전화번호",
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF6830F7)))),
                onChanged: (String value) {
                  if (value.length > 0) {
                    print(_isPhoneNumberEmpty);
                    setState(() {
                      _isPhoneNumberEmpty = false;
                    });
                  } else {
                    setState(() {
                      _isPhoneNumberEmpty = true;
                    });
                  }
                }),
            ListView.builder(
              shrinkWrap: true,
              itemCount: widgets.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(child: widgets[index]);
              },
            ),
            SizedBox(height: 20.0),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 48.0,
              child: RaisedButton(
                color: (!_isPhoneNumberEmpty)
                    ? (_isRequested&&_isAuthNumberEmpty?Color(0xFF8D92A3):Color(0xFF6830F7))
                    : Color(0xFF8D92A3),
                onPressed: _buttonChange?() => _receiveEmail() : () => _receiveAuthNum(),
                child: Text(_buttonChange ? "확인" : "인증번호 받기",
                    style: TextStyle(color: Colors.white)),
              ),
            )
          ]),
        ),
      ),
    );
  }

  bool _isPhoneNumberEmpty;
  bool isRegistered;
  bool _isAuthNumberEmpty;
  bool _buttonChange;
  bool _isRequested;
  String _authNum;

  @override
  void initState() {
    super.initState();
    isRegistered = false;
    _isPhoneNumberEmpty = true;
    _isAuthNumberEmpty = true;
    _buttonChange = false;
    _isRequested = false;
  }

  void _changeWidget(List<Widget> widgets) {
    setState(() {
      if (widgets.length == 0) {
        if (isRegistered) {
          print("hi");
          widgets.insert(0, SizedBox(height: 10.0));
          widgets.insert(
              1,
              TextField(
                onChanged: (String value) {
                  print(_isAuthNumberEmpty);
                  if (value.length > 0) {
                    setState(() {
                      _isAuthNumberEmpty = false;
                    });
                  }
                  else {
                    setState(() {
                      _isAuthNumberEmpty = true;
                    });
                  }
                },
                controller: _authNumController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                    hintText: "인증번호",
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF6830F7)))),
              ));
          setState(() {
            _buttonChange = true;
          });
        }
      }
    });
  }

  void _receiveAuthNum() async {
    TodoRegister todoRegister = new TodoRegister();
    String pNum = _pNumController.text;
    // 등록된 번호인지 확인
    Future<bool> future1 = todoRegister.isRegistered(pNum);
    await future1.then((value) => isRegistered = value,
        onError: (e) => print(e));
    print(isRegistered);
    if (_pNumController.text.isEmpty) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                content: Container(
                  height: MediaQuery.of(context).size.height * 0.12,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Container(
                            padding: EdgeInsets.only(top: 15.0),
                            child: Text("휴대폰번호를 입력해주세요",
                                style: TextStyle(
                                    fontSize: 15.0, color: Colors.black))),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.only(top: 10.0),
                          child: InkWell(
                            child: Text(
                              "확인",
                              style: TextStyle(
                                  fontSize: 15.0, color: Color(0xFF6830F7)),
                            ),
                            onTap: () => Navigator.pop(context),
                          ),
                        ),
                      )
                    ],
                  ),
                ));
          });
    } else {
      // 등록된 번호이면
      if (isRegistered) {
        // 인증번호 발송
        setState(() {
          _isRequested = true;
        });
        Future<String> future = todoRegister.getAuthNumber(pNum);
        await future.then((value) => _authNum = value,
            onError: (e) => print(e));
        _changeWidget(widgets);
      }
      // 아니면 다이얼로그
      else {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  content: Container(
                    height: MediaQuery.of(context).size.height * 0.12,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Container(
                              padding: EdgeInsets.only(top: 15.0),
                              child: Text("등록되지 않은 번호입니다",
                                  style: TextStyle(
                                      fontSize: 15.0, color: Colors.black))),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.only(top: 10.0),
                            child: InkWell(
                              child: Text(
                                "확인",
                                style: TextStyle(
                                    fontSize: 15.0, color: Color(0xFF6830F7)),
                              ),
                              onTap: () => Navigator.pop(context),
                            ),
                          ),
                        )
                      ],
                    ),
                  ));
            });
        return null;
      }
    }
  }

  void _receiveEmail() async {
    if (_isAuthNumberEmpty) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                content: Container(
                  height: MediaQuery.of(context).size.height * 0.12,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Container(
                            padding: EdgeInsets.only(top: 15.0),
                            child: Text("인증번호를 입력해주세요",
                                style: TextStyle(
                                    fontSize: 15.0, color: Colors.black))),

                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.only(top: 10.0),
                          child: InkWell(
                            child: Text(
                              "확인",
                              style: TextStyle(
                                  fontSize: 15.0, color: Color(0xFF6830F7)),
                            ),
                            onTap: () => Navigator.pop(context),
                          ),
                        ),
                      )
                    ],
                  ),
                ));
          });
    }
    else {
      // 인증번호가 맞으면
      if (_authNumController.text == _authNum) {
        String url = "http://studyplanet.kr/member/find/email";
        String body = "pNum=${_pNumController.text}";
        Map<String, String> header = {
          "Content-Type": "application/x-www-form-urlencoded"
        };
        var response = await http.post(url, headers: header, body: body);
        String result = response.body;
        var json = jsonDecode(result);
        FindState state = Provider.of<FindState>(context, listen: false);
        state.setInfo(json["email"]);
        print(state.getInfo());
        SharedPreferences sf = await SharedPreferences.getInstance();
        state.setRegisterDate(sf.getString("registerDate"));
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => FindEmailResultPage()));
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  content: Container(
                    height: MediaQuery.of(context).size.height * 0.12,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Container(
                              padding: EdgeInsets.only(top: 15.0),
                              child: Text("인증번호가 틀렸습니다",
                                  style: TextStyle(
                                      fontSize: 15.0, color: Colors.black))),

                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.only(top: 10.0),
                            child: InkWell(
                              child: Text(
                                "확인",
                                style: TextStyle(
                                    fontSize: 15.0, color: Color(0xFF6830F7)),
                              ),
                              onTap: () => Navigator.pop(context),
                            ),
                          ),
                        )
                      ],
                    ),
                  ));
            });
      }
    }
  }
}
