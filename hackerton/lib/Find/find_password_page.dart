import 'package:flutter/material.dart';
import 'package:hackerton/Email/email_login_page.dart';
import 'package:hackerton/State/find_state.dart';
import 'package:hackerton/Todo/todo_register.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'find_password_result.dart';

class FindPasswordPage extends StatefulWidget {
  @override
  State createState() => FindPasswordPageState();
}

class FindPasswordPageState extends State<FindPasswordPage> {
  final TextEditingController _emailController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text("비밀번호 찾기",
            style: TextStyle(fontSize: 15.0, color: Colors.black)),
        leading: IconButton(
            icon: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => EmailLoginPage()))),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                  hintText: "이메일",
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF6830F7)))),
              onChanged: (String value) {
                if (value.length > 0) {
                  setState(() {
                    _isEmailEmpty = false;
                  });
                } else {
                  setState(() {
                    _isEmailEmpty = true;
                  });
                }
              },
            ),
            SizedBox(height: 25.0),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 48.0,
              child: RaisedButton(
                color: (!_isEmailEmpty) ? Color(0xFF6830F7) : Color(0xFF8D92A3),
                onPressed: () {
                  receivePassword();
                  //print(emptyOrNot.getIsEmpty());
                },
                child: Text("다음", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isEmailEmpty;

  @override
  void initState() {
    super.initState();
    _isEmailEmpty = true;
  }

  void receivePassword() async {
    TodoRegister todoRegister = new TodoRegister();
    String email = _emailController.text;
    bool isRegistered = false;
    Future<bool> future = todoRegister.isIdDuplicated(email);
    await future.then((value) => isRegistered = value,
        onError: (e) => print(e));

    if (_emailController.text.isNotEmpty) {
      if (isRegistered) {
        String url = "http://studyplanet.kr/member/gen/tmp/pw";
        String body = "email=$email";
        Map<String, String> header = {
          "Content-Type": "application/x-www-form-urlencoded"
        };
        FindState findState = Provider.of<FindState>(context, listen: false);
        findState.setInfo(email);
        SharedPreferences sp = await SharedPreferences.getInstance();
        print(sp.getString("registerDate"));
        findState.setRegisterDate(sp.getString("registerDate"));
        await http.post(url, headers: header, body: body);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => FindPasswordResultPage()));
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
                              child: Text("등록되지 않은 이메일입니다",
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
                            child: Text("이메일을 입력해주세요",
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
