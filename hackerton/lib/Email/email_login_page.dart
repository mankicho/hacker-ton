import 'package:flutter/material.dart';
import 'package:hackerton/Find/find_password_page.dart';
import 'package:hackerton/Home/home_login_page.dart';
import 'package:hackerton/Main/main_page.dart';
import 'package:hackerton/Register/register_page1.dart';
import 'package:hackerton/State/page_navi_state.dart';
import 'package:hackerton/Todo/todo_login.dart';
import 'package:provider/provider.dart';
import '../Find/find_email_page.dart';
import 'package:flushbar/flushbar.dart';

class EmailLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "이메일 로그인 페이지",
      home: EmailLoginPage(),
    );
  }
}

class EmailLoginPage extends StatefulWidget {
  @override
  State createState() {
    return EmailLoginPageState();
  }
}

class EmailLoginPageState extends State<EmailLoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.keyboard_arrow_left, color: Colors.black),
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomeLoginPage()))),
          elevation: 0,
          centerTitle: true,
          title: Text("이메일로 로그인",
              style: TextStyle(color: Colors.black, fontSize: 15.0)),
          backgroundColor: Color(0xFFFFFFFF),
        ),
        body: Container(
          decoration: BoxDecoration(color: Colors.white),
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Column(
            children: <Widget>[
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10.0),
                    hintText: "이메일",
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF6830F7)))),
                focusNode: _emailFocus,
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
              SizedBox(height: 10.0),
              TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 10.0),
                      hintText: "비밀번호",
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF6830F7)))),
                  focusNode: _passwordFocus,
                  onChanged: (String value) {
                    if (value.length > 0) {
                      setState(() {
                        _isPasswordEmpty = false;
                      });
                    } else {
                      setState(() {
                        _isPasswordEmpty = true;
                      });
                    }
                  }),
              SizedBox(height: 15.0),
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50.0,
                  child: RaisedButton(
                    color: (!_isEmailEmpty && !_isPasswordEmpty)
                        ? Color(0xFF6830F7)
                        : Color(0xFF8D92A3),
                    child: Text("로그인", style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      pressLogin();
                    },
                  )),
              SizedBox(height: 15.0),
              Container(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        child: Text("이메일 찾기",
                            style: TextStyle(fontSize: 13.0),
                            textAlign: TextAlign.center),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FindEmailPage())),
                      ),
                    ),
                    SizedBox(width: 40.0),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        child: Text("비밀번호 찾기",
                            style: TextStyle(fontSize: 13.0),
                            textAlign: TextAlign.center),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FindPasswordPage())),
                      ),
                    ),
                    SizedBox(width: 40.0),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        child: Text("회원가입",
                            style: TextStyle(fontSize: 13.0),
                            textAlign: TextAlign.center),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterPage1()));
                          PageNaviState pns = Provider.of<PageNaviState>(context, listen: false);
                          pns.setStart("emailLogin");
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  FocusNode _emailFocus;
  FocusNode _passwordFocus;
  bool _isEmailEmpty;
  bool _isPasswordEmpty;


  @override
  void initState() {
    super.initState();
    _emailFocus = new FocusNode();
    _passwordFocus = new FocusNode();
    _isEmailEmpty = true;
    _isPasswordEmpty = true;
  }



  @override
  void dispose() {
    super.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
  }

  void pressLogin() async {
    WidgetsFlutterBinding.ensureInitialized();
    String email = _emailController.text;
    String pw = _passwordController.text;

    bool result = false;
    TodoLogin todoLogin = TodoLogin();

    if (email.isEmpty) {
      // 커서가 아이디 텍스트 필드로 올라간 후
      FocusScope.of(context).requestFocus(_emailFocus);
      // 플러시바 띄워줌
      Flushbar(
        maxWidth: MediaQuery.of(context).size.width * 0.97,
        backgroundColor: Color(0xFFEF4B5F),
        flushbarPosition: FlushbarPosition.TOP,
        duration: Duration(seconds: 2),
        messageText: Text("이메일을 입력해주세요.",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        borderRadius: 5,
      ).show(context);
    } else if (pw.isEmpty) {
      // 커서가 비밀번호 텍스트 필드로 올라간 후
      FocusScope.of(context).requestFocus(_passwordFocus);
      Flushbar(
        maxWidth: MediaQuery.of(context).size.width * 0.97,
        backgroundColor: Color(0xFFEF4B5F),
        flushbarPosition: FlushbarPosition.TOP,
        duration: Duration(seconds: 2),
        messageText: Text("비밀번호을 입력해주세요.",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        borderRadius: 5,
      ).show(context);
    } else {
      Future<bool> future = todoLogin.confirmInfo(email, pw);
      await future.then((value) => result = value, onError: (e) => print(e));
      // result 가 true 면 로그인 성공
      if (result) {
        print(result);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MainNavigation()));
      }
      // 실패면 이메일, 비밀번호 확인해달라는 알림
      else {
        // 포커스를 떼고
        FocusScope.of(context).unfocus();
        Flushbar(
          maxWidth: MediaQuery.of(context).size.width * 0.97,
          backgroundColor: Color(0xFFEF4B5F),
          flushbarPosition: FlushbarPosition.TOP,
          duration: Duration(seconds: 2),
          messageText: Text("이메일, 비밀번호을 확인해주세요.",
              style:
              TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          borderRadius: 5,
        ).show(context);
      }
    }
  }
}
