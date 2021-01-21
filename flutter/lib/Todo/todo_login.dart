import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class TodoLogin {
// todo 로그인하면 서버로부터 토큰을 받아와서 SharedPreference 로 저장
  Future<bool> confirmInfo(String email, String pw) async {
    const String url = "http://studyplanet.kr/member/login.do";
    String body = "email=$email&pw=$pw";
    Map<String, String> header = {"Content-Type":"application/x-www-form-urlencoded"};
    var response = await http.post(url, body: body, headers: header);
    String token = response.body;
    if (token != "\"fail\"") {
      SharedPreferences sf = await SharedPreferences.getInstance();
      sf.setString("token", token);
      return new Future(() => true);
    }
    return new Future(() => false);
  }
}
