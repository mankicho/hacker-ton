import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hackerton/Email/email_login_page.dart';
import 'package:hackerton/State/register_state.dart';
import 'package:hackerton/Todo/todo_register.dart';
import 'package:hackerton/Todo/validate_nickname.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Register3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "회원가입 페이지 3",
        home: RegisterPage3());
  }
}

class RegisterPage3 extends StatefulWidget {
  @override
  State createState() {
    return RegisterPageState3();
  }
}

class RegisterPageState3 extends State<RegisterPage3> {
  final TextEditingController _nicknameController = new TextEditingController();
  ValidateNickname validateNickname = new ValidateNickname();

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
          leading: IconButton(
              icon: Icon(Icons.keyboard_arrow_left, color: Colors.black),
              onPressed: () => Navigator.pop(context)),
          backgroundColor: Colors.white,
        ),
        body: Container(
          decoration: BoxDecoration(color: Colors.white),
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Column(children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 4,
              decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Color(0xFF8D92A3)),
                    top: BorderSide(color: Color(0xFF8D92A3)),
                    left: BorderSide(color: Color(0xFF8D92A3)),
                    right: BorderSide(color: Color(0xFF8D92A3))),
              ),
              child: CircleAvatar(
                backgroundImage: AssetImage("assets/gifs/snoopy-dancing.gif"),
              ),
            ),
            SizedBox(height: 15.0),
            Text("앞으로 여러분을 대신할 캐릭터의 이름을 지어주세요",
                style: TextStyle(
                  fontSize: 13.0,
                )),
            SizedBox(height: 10.0),
            TextField(
                keyboardType: TextInputType.text,
                onChanged: (String value) {
                  _nicknameDupCheck(value);
                  print(validateNickname.getIsCorrected());
                  if (validateNickname.checkPassword(value).getIsCorrected()) {
                    setState(() {
                      _isNicknameCorrect = true;
                    });
                  }
                  else {
                    setState(() {
                      _isNicknameCorrect = false;
                    });
                  }
                },
                controller: _nicknameController,
                decoration: InputDecoration(
                    suffixIcon: !_isNicknameDuplicated&&_isNicknameCorrect ? Icon(Icons.check, color: Colors.green):null,
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF6830F7))),
                    hintText: "닉네임을 입력하세요")),
            SizedBox(height: 5.0),
            Text(_isNicknameCorrect?(_isNicknameDuplicated?"이미 사용중인 닉네임입니다":""):"한글, 영문, 숫자만 사용하여 2~8자리를 입력해주세요",
              style: TextStyle(color: Colors.red, fontSize: 12.0),
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
                        color: (!_isNicknameDuplicated && _isNicknameCorrect)?Color(0xFF6830F7):Color(0xFF8D92A3),
                        child:
                        Text("완료", style: TextStyle(color: Colors.white)),
                        onPressed: () => _register()),
                  )
                ],
              ),
            )
          ]),
        ));
  }

  bool _isNicknameCorrect;
  bool _isNicknameDuplicated;

  @override
  void initState() {
    super.initState();
    _isNicknameCorrect = false;
    _isNicknameDuplicated = false;
  }

  void _nicknameDupCheck(String nickname) async {
    TodoRegister todoRegister = new TodoRegister();
    bool result = false;
    Future<bool> future = todoRegister.isNicknameDuplicated(nickname);
    await future.then((value) => result = value, onError: (e) => print(e));
    if (result) {
      setState(() {
        _isNicknameDuplicated = true;
      });
    } else {
      // 중복아님
      setState(() {
        _isNicknameDuplicated = false;
      });
    }
    print(_isNicknameDuplicated);
  }

  void _register() async {
    if (_nicknameController.text.isNotEmpty) {
      if (!_isNicknameDuplicated) {
        WidgetsFlutterBinding.ensureInitialized();
        TodoRegister todoRegister = new TodoRegister();
        String result;
        RegisterState registerState =
        Provider.of<RegisterState>(context, listen: false);
        String email = registerState.getEmail();
        String pw = registerState.getPassword();
        String phoneNumber = registerState.getPhoneNumber();
        String nickname = _nicknameController.text;
        print(nickname);
        String sex = registerState.getSex();
        String bornTime = registerState.getBirthday();
        Future<String> future =
        todoRegister.register(email, pw, phoneNumber, nickname, sex, bornTime);
        await future.then((value) => result = value, onError: (e) => print(e));
        print(result);
        if (result == "100") {
          print("가입성공");
          DateTime now = new DateTime.now();
          DateTime date = new DateTime(now.year, now.month, now.day);
          String today = date.toString().substring(2,4) + "." + date.toString().substring(5, 7) + "." +date.toString().substring(8,10);
          SharedPreferences sp = await SharedPreferences.getInstance();
          sp.setString("registerDate", today);
          Fluttertoast.showToast(
              msg: "가입완료!",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              fontSize: 15.0,
              backgroundColor: Color(0xFF404040));
          Navigator.push(context, MaterialPageRoute(builder: (context) => EmailLoginPage()));
        } else {
          print("가입실패");
        }
      }
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
                              child: Text("중복된 닉네임입니다",
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
                            child: Text("닉네임을 입력하세요",
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
