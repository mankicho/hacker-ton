import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hackerton/Register/register_page3.dart';
import 'package:hackerton/State/register_state.dart';
import 'package:hackerton/Todo/todo_register.dart';
import 'package:provider/provider.dart';
import "package:customtogglebuttons/customtogglebuttons.dart";

class Register2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "이메일 회원가입 페이지 2",
      home: RegisterPage2(),
    );
  }
}

class RegisterPage2 extends StatefulWidget {
  @override
  State createState() => RegisterPageState2();
}

class RegisterPageState2 extends State<RegisterPage2> {
  final TextEditingController _pNumController = new TextEditingController();
  final TextEditingController _authNumController = new TextEditingController();
  final TextEditingController _birthDayController = new TextEditingController();
  List<Widget> widgets = <Widget>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        title: Text("회원가입",
            style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
        backgroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              child: Text("전화번호",
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
                      enabled: _isAuthenticated ? false : true,
                      keyboardType: TextInputType.phone,
                      focusNode: _pNumFocus,
                      controller: _pNumController,
                      decoration: InputDecoration(
                        suffix: _isRequested
                            ? InkWell(
                          child: Text("재전송",
                              style: TextStyle(
                                  color: Colors.red, fontSize: 12.0)),
                          onTap: () => _requestAuth(),
                        )
                            : null,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10.0),
                        hintText: "- 없이 숫자만 입력",
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF6830F7))),
                      )),
                ),
                Container(
                    height: 48.0,
                    child: RaisedButton(
                        elevation: 0,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            side: BorderSide(color: Color(0xFF6830F7))),
                        child:
                        (!_isRegistered&_pNumController.text.isNotEmpty)
                            ? CountdownTimer(
                          controller: _countDownTimerController,
                          widgetBuilder: (BuildContext context,
                              CurrentRemainingTime time) {
                            if (time == null) {
                              return Text("인증요청",
                                  style: TextStyle(
                                      color: Color(0xFF6830F7)));
                            }
                            return Text("${time.min} : ${time.sec}", style: TextStyle(color: Color(0xFF6830F7)));
                          },
                        )
                            : Text("인증요청",
                            style: TextStyle(color: Color(0xFF6830F7))),
                        onPressed: () {_requestAuth();
                        _countDownTimerController.start();} ))
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: widgets.length,
              itemBuilder: (BuildContext context, int index) {
                return widgets[index];
              },
            ),
            SizedBox(height: 15.0),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                      alignment: Alignment.centerLeft,
                      width: MediaQuery.of(context).size.width / 2.3,
                      child: Text("성별(선택)",
                          style: TextStyle(
                              fontSize: 13.0, fontWeight: FontWeight.bold))),
                  Container(
                      alignment: Alignment.centerLeft,
                      width: MediaQuery.of(context).size.width / 2.3,
                      child: Text("생년월일(선택)",
                          style: TextStyle(
                              fontSize: 13.0, fontWeight: FontWeight.bold)))
                ],
              ),
            ),
            SizedBox(height: 10.0),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    width: MediaQuery.of(context).size.width / 2.3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                            width: MediaQuery.of(context).size.width / 2.3,
                            child: CustomToggleButtons(
                              isSelected: _isSelected,
                              direction: Axis.horizontal,
                              constraints: BoxConstraints(
                                  minWidth: 72.0, minHeight: 48.0),
                              selectedBorderColor: Color(0xFF6830F7),
                              spacing: 10.0,
                              children: <Widget>[Text("남자"), Text("여자")],
                              onPressed: (index) {
                                if (index == 0) {
                                  if (!_isSelected[0]) {
                                    _isSelected[0] = !_isSelected[0];
                                    _isSelected[1] = !_isSelected[0];
                                    setState(() {
                                      _sex = "M";
                                      print(_sex);
                                    });
                                  } else {
                                    _isSelected[0] = !_isSelected[0];
                                    _isSelected[1] = _isSelected[0];
                                    setState(() {
                                      _sex = null;
                                    });
                                    print(_sex);
                                  }
                                } else {
                                  if (!_isSelected[1]) {
                                    _isSelected[1] = !_isSelected[1];
                                    _isSelected[0] = !_isSelected[1];
                                    setState(() {
                                      _sex = "W";
                                    });
                                    print(_sex);
                                  } else {
                                    _isSelected[1] = !_isSelected[1];
                                    _isSelected[0] = _isSelected[1];
                                    setState(() {
                                      _sex = null;
                                    });
                                    print(_sex);
                                  }
                                }
                              },
                            )),
                      ],
                    ),
                  ),
                  Container(
                      alignment: Alignment.centerLeft,
                      width: MediaQuery.of(context).size.width / 2.18,
                      height: 48.0,
                      child: TextField(
                        onChanged: (String value) {},
                        keyboardType: TextInputType.number,
                        controller: _birthDayController,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10.0),
                            hintText: "예) 2000.01.01",
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Color(0xFF6830F7)))),
                      ))
                ]),
            SizedBox(height: 15.0),
            Container(
              alignment: Alignment.centerLeft,
              child: Text("약관동의",
                  style:
                  TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 10.0),
            Container(
                padding: EdgeInsets.only(right: 15.0),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 4,
                decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Color(0xFF8D92A3)),
                      top: BorderSide(color: Color(0xFF8D92A3)),
                      left: BorderSide(color: Color(0xFF8D92A3)),
                      right: BorderSide(color: Color(0xFF8D92A3))),
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Checkbox(value: false, onChanged: null),
                              Text("모두 동의",
                                  style: TextStyle(
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.bold)),
                            ],
                          )),
                      Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Checkbox(value: false, onChanged: null),
                              Text("이용약관 동의",
                                  style: TextStyle(
                                      fontSize: 13.0,
                                      decoration: TextDecoration.underline)),
                              SizedBox(width: 5.0),
                              Text("(필수)", style: TextStyle(fontSize: 13.0)),
                              Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      InkWell(
                                          child: Text("보기",
                                              style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: Color(0xFF8D92A3))),
                                          onTap: null),
                                    ],
                                  ))
                            ],
                          )),
                      Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Checkbox(value: false, onChanged: null),
                              Text("개인정보 수집 및 이용동의",
                                  style: TextStyle(
                                      fontSize: 13.0,
                                      decoration: TextDecoration.underline)),
                              SizedBox(width: 5.0),
                              Text("(필수)", style: TextStyle(fontSize: 13.0)),
                              Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      InkWell(
                                          child: Text("보기",
                                              style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: Color(0xFF8D92A3))),
                                          onTap: null),
                                    ],
                                  ))
                            ],
                          )),
                      Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Checkbox(value: false, onChanged: null),
                              Text("개인정보 수집 및 이용동의",
                                  style: TextStyle(
                                      fontSize: 13.0,
                                      decoration: TextDecoration.underline)),
                              SizedBox(width: 5.0),
                              Text("(선택)", style: TextStyle(fontSize: 13.0)),
                              Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      InkWell(
                                          child: Text("보기",
                                              style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: Color(0xFF8D92A3))),
                                          onTap: null),
                                    ],
                                  ))
                            ],
                          )),
                      Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Checkbox(value: false, onChanged: null),
                              Text("이벤트 정보 수신 동의",
                                  style: TextStyle(
                                      fontSize: 13.0,
                                      decoration: TextDecoration.underline)),
                              SizedBox(width: 5.0),
                              Text("(선택)", style: TextStyle(fontSize: 13.0)),
                            ],
                          )),
                    ])),
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
                        color: (_isAuthenticated && _isAgreed)
                            ? Color(0xFF6830F7)
                            : Color(0xFF8D92A3),
                        onPressed: () => _pressNext2()),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  List<bool> _isSelected;
  bool _isAuthenticated;
  bool _isRegistered;
  bool _isAgreed;
  bool _isRequested;
  bool _requestButtonPressed;
  String _authNum = "";
  String _sex;
  List<bool> _isChecked;
  FocusNode _authNumFocus;
  FocusNode _pNumFocus;
  CountdownTimerController _countDownTimerController;
  int _endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 180;

  @override
  void initState() {
    super.initState();
    _isAuthenticated = false;
    _isRegistered = false;
    _isAgreed = false;
    _isRequested = false;
    _sex = null;
    _isSelected = [false, false];
    _isChecked = [false, false, false, false, false];
    _authNumFocus = new FocusNode();
    _pNumFocus = new FocusNode();
    _countDownTimerController =
        CountdownTimerController(endTime: _endTime, onEnd: _onEnd);
  }

  @override
  void dispose() {
    super.dispose();
    _authNumFocus.dispose();
    _pNumFocus.dispose();
    _countDownTimerController.dispose();
  }

  void _onEnd() {
    print("end");
    setState(() {
      _isRegistered = false;
    });

  }

  void _authentication() {
    if (_authNumController.text.isNotEmpty) {
      if (_authNumController.text == _authNum) {
        setState(() {
          _isAuthenticated = true;
        });
        print(_isAuthenticated);
        FocusScope.of(context).unfocus();
        Fluttertoast.showToast(
            msg: "인증성공!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            fontSize: 15.0,
            backgroundColor: Color(0xFF404040));
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
                              child: Text("인증번호가 일치하지 않습니다",
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
  }

  void _insertWidget(List<Widget> widgets) {
    if (widgets.length == 0) {
      setState(() {
        widgets.insert(0, SizedBox(height: 10.0));
        widgets.insert(
            1,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: 250.0,
                  child: TextField(
                      enabled: _isAuthenticated ? false : true,
                      keyboardType: TextInputType.number,
                      focusNode: _authNumFocus,
                      controller: _authNumController,
                      decoration: InputDecoration(
                        suffixIcon: _isAuthenticated
                            ? Icon(Icons.check, color: Colors.green)
                            : null,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10.0),
                        hintText: "인증번호",
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF6830F7))),
                      )),
                ),
                Container(
                    height: 48.0,
                    child: RaisedButton(
                      elevation: 0,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          side: BorderSide(color: Color(0xFF6830F7))),
                      child: Text("인증확인",
                          style: TextStyle(color: Color(0xFF6830F7))),
                      onPressed: () => _authentication(),
                    ))
              ],
            ));
      });
    }
  }

  void _requestAuth() async {
    TodoRegister todoRegister = new TodoRegister();
    String phoneNumber = _pNumController.text;
    Future<bool> future = todoRegister.isRegistered(phoneNumber);
    await future.then((value) => setState(() => _isRegistered = value),
        onError: (e) => print(e));
    if (_pNumController.text.isEmpty) {
      showDialog(
          context: context,
          barrierDismissible: true,
          barrierColor: Color(0xFF707070),
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
      if (_isRegistered) {
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
                              child: Text("이미 가입되어 있는 전화번호입니다",
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
        setState(() {
          _isRequested = true;
        });
        _insertWidget(widgets);
        FocusScope.of(context).requestFocus(_authNumFocus);
        Future<String> future = todoRegister.getAuthNumber(phoneNumber);
        await future.then((value) => _authNum = value,
            onError: (e) => print(e));
      }
    }
  }

  void _pressNext2() {
    // 휴대폰 인증, 필수 사항 동의했으면 다음페이지로
    if (_isAuthenticated) {
      RegisterState registerState =
      Provider.of<RegisterState>(context, listen: false);
      String pNum = _pNumController.text;
      String birthday = (_birthDayController.text.isEmpty)
          ? "N"
          : _birthDayController.text
          .substring(2, _birthDayController.text.length);
      String sex = _sex ?? "N";
      print(birthday);
      registerState.setPhoneNumber(pNum);
      registerState.setBirthday(birthday);
      registerState.setSex(sex);
      print(registerState.getSex());
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => RegisterPage3()));
    }
    // 휴대폰 인증 안했으면
    else if (!_isAuthenticated) {
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
                            child: Text("휴대폰 인증이 필요합니다",
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
      if (!_isRequested) {
        FocusScope.of(context).requestFocus(_pNumFocus);
      } else {
        FocusScope.of(context).requestFocus(_authNumFocus);
      }
    }
  }
}
