import 'package:flutter/material.dart';
import 'package:hackerton/Email/email_login_page.dart';
import 'package:hackerton/Home/home_login_page.dart';
import 'package:hackerton/Register/register_page2.dart';
import 'package:hackerton/State/page_navi_state.dart';
import 'package:hackerton/State/register_state.dart';
import 'package:hackerton/Todo/todo_register.dart';
import 'package:hackerton/Todo/validate_password.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterPage1 extends StatefulWidget {
  @override
  State createState() => RegisterPageState1();
}

class RegisterPageState1 extends State<RegisterPage1> {
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  final TextEditingController _passwordController2 =
  new TextEditingController();
  ValidatePassword validatePassword = new ValidatePassword();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text("회원가입",
            style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
        leading: Consumer<PageNaviState>(
          builder: (context, pns, child) {
            return IconButton(
                icon: Icon(Icons.keyboard_arrow_left, color: Colors.black),
                onPressed: (pns.getStart() == "home")
                    ? () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomeLoginPage()))
                    : () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EmailLoginPage())));
          },
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              child: Text("이메일",
                  style:
                  TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: 250.0,
                  child: TextField(
                    focusNode: _emailFocus,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10.0),
                        hintText: "이메일 주소",
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF6830F7))),
                        suffixIcon: _isDuplicate
                            ? null
                            : Icon(Icons.check, color: Colors.green)),
                    onChanged: (String value) {
                      setState(() {
                        _isDuplicate = true;
                      });
                    },
                  ),
                ),
                Container(
                  height: 48.0,
                  child: RaisedButton(
                    child: Text("중복 확인",
                        style: TextStyle(color: Color(0xFF6830F7))),
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        side: BorderSide(color: Color(0xFF6830F7))),
                    elevation: 0,
                    onPressed: () => pressEmailDuplicationCheck(),
                  ),
                )
              ],
            ),
            SizedBox(height: 20.0),
            Container(
              alignment: Alignment.centerLeft,
              child: Text("비밀번호",
                  style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 13.0)),
            ),
            SizedBox(height: 10.0),
            TextField(
              focusNode: _pwFocus1,
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                  suffixIcon: _isPwEmpty1
                      ? null
                      : (_isPwCorrect1
                      ? Icon(Icons.check, color: Colors.green)
                      : Icon(Icons.warning_amber_sharp, color: Colors.red)),
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                  hintText: "비밀번호(영문, 숫자 포함 8자 이상)",
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF6830F7)))),
              onChanged: (String value) {
                if (value.isEmpty) {
                  setState(() {
                    _isPwEmpty1 = true;
                  });
                } else {
                  setState(() {
                    _isPwEmpty1 = false;
                  });
                }
                if (validatePassword.checkPassword(value).getIsCorrected()) {
                  setState(() {
                    _isPwCorrect1 = true;
                  });
                } else {
                  setState(() {
                    _isPwCorrect1 = false;
                  });
                }
              },
            ),
            SizedBox(height: 10.0),
            TextField(
              focusNode: _pwFocus2,
              controller: _passwordController2,
              obscureText: true,
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 10.0),
                  hintText: "비밀번호 확인",
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF6830F7))),
                  suffixIcon: _isPwEmpty2
                      ? null
                      : (_isPwCorrect2 &
                  (_passwordController.text ==
                      _passwordController2.text)
                      ? Icon(Icons.check, color: Colors.green)
                      : Icon(Icons.warning_amber_sharp,
                      color: Colors.red))),
              onChanged: (String value) {
                if (value.isEmpty) {
                  setState(() {
                    _isPwEmpty2 = true;
                  });
                } else {
                  setState(() {
                    _isPwEmpty2 = false;
                  });
                }
                if ((validatePassword.checkPassword(value).getIsCorrected()) &&
                    (value == _passwordController.text)) {
                  setState(() {
                    _isPwCorrect2 = true;
                  });
                } else {
                  setState(() {
                    _isPwCorrect2 = false;
                  });
                }
              },
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 48.0,
                    child: RaisedButton(
                        child:
                        Text("다음", style: TextStyle(color: Colors.white)),
                        color: (!_isDuplicate && _isPwCorrect1 && _isPwCorrect2)
                            ? Color(0xFF6830F7)
                            : Color(0xFF8D92A3),
                        onPressed: () => _pressNext1(context)),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  bool _isDuplicate; // 중복확인 여부
  bool _isPwCorrect1; // 비밀번호 형식 올바른지 여부
  bool _isPwCorrect2; // 비밀번호 확인 여부
  bool _isPwEmpty1;
  bool _isPwEmpty2;
  FocusNode _emailFocus;
  FocusNode _pwFocus1;
  FocusNode _pwFocus2;

  @override
  void initState() {
    super.initState();
    _isDuplicate = true;
    _isPwCorrect1 = false;
    _isPwCorrect2 = false;
    _emailFocus = new FocusNode();
    _pwFocus1 = new FocusNode();
    _pwFocus2 = new FocusNode();
    _isPwEmpty1 = true;
    _isPwEmpty2 = true;
  }

  @override
  void dispose() {
    super.dispose();
    _emailFocus.dispose();
    _pwFocus1.dispose();
    _pwFocus2.dispose();
  }

  // 이메일 중복확인
  void pressEmailDuplicationCheck() async {
    TodoRegister todoRegister = new TodoRegister();
    bool result = false;
    String email = _emailController.text;

    // 이메일 형식이 올바르지 않으면
    // todo 특수문자, 한글추가
    if ((!email.contains("@")) ||
        (!email.contains(".")) ||
        (((email.substring(email.length - 3, email.length - 2) != ".") &&
            (email.substring(email.length - 4, email.length - 3) != ".")))) {
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
                            child: Text("올바르지 않은 형식의 이메일입니다",
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
      Future<bool> future = todoRegister.isIdDuplicated(email);
      await future.then((value) => result = value, onError: (e) => print(e));
      print(result);
      // true 면 중복
      if (result) {
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
                              child: Text("이미 가입되어 있는 이메일입니다",
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
        setState(() {
          _isDuplicate = true;
        });
      }
      // false 면 사용할 수 있는 이메일
      else {
        Fluttertoast.showToast(
            msg: "사용가능!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            fontSize: 15.0,
            backgroundColor: Color(0xFF404040));
        FocusScope.of(context).unfocus();
        setState(() {
          _isDuplicate = false;
        });
      }
    }
  }

  void _pressNext1(BuildContext context) {
    print(_isDuplicate);
    print(_isPwCorrect1);
    print(_isPwCorrect2);
    // 다음으로 넘어가도 되는 상태면
    if (!_isDuplicate && _isPwCorrect1 && _isPwCorrect2) {
      RegisterState registerState1 =
      Provider.of<RegisterState>(context, listen: false);
      registerState1.setEmail(_emailController.text);
      registerState1.setPassword(_passwordController.text);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => RegisterPage2()));
    } else if (_isDuplicate) {
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
                            child: Text("이메일 중복을 확인하세요",
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
      FocusScope.of(context).requestFocus(_emailFocus);
    } else if (!_isPwCorrect1) {
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
                            child: Text("비밀번호를 확인해주세요",
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
      FocusScope.of(context).requestFocus(_pwFocus1);
    } else if (!_isPwCorrect2) {
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
                            child: Text("비밀번호를 동일하게 입력해주세요",
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
      FocusScope.of(context).requestFocus(_pwFocus2);
    }
  }
}
