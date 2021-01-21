import 'package:http/http.dart' as http;

class TodoRegister {
  //todo.1 아이디 중복확인 가입된 이메일이 있는지 확인하는 거로 메서드 이름 바꾸기
  Future<bool> isIdDuplicated(String email) async {
    const String url = "http://studyplanet.kr/member/email/get.do";
    String body = "email=$email";
    Map<String, String> header = {
      "Content-Type": "application/x-www-form-urlencoded"
    };
    var response = await http.post(url, body: body, headers: header);
    String result = response.body;
    // 서버에서 받아온 값과 입력한 값이 같으면 true 리턴
    if ("\"" + email + "\"" == result) {
      return new Future(() => true);
    }
    // 서버에서 받아온 값과 입력한 값이 다르면 false 리턴
    return new Future(() => false);
  }

// todo.4 네이버 클라우드 인증번호 보내기
  Future<String> getAuthNumber(String phoneNumber) async {
    const String url = "http://studyplanet.kr/sms/upt/receive.do";
    String pNum = phoneNumber;
    var response = await http.post(url,
        body: "pNum=$pNum",
        headers: {"Content-Type": "application/x-www-form-urlencoded"});
    String authNumber = response.body;
    return Future(() {
      return authNumber;
    });
  }

// todo.6 해당번호로 이미 가입된 유저인지 확인
  Future<bool> isRegistered(String phoneNumber) async {
    const String url = "http://studyplanet.kr/member/pNum/get.do";
    String body = "pNum=$phoneNumber";
    Map<String, String> header = {
      "Content-Type": "application/x-www-form-urlencoded"
    };
    var response = await http.post(url, body: body, headers: header);
    String result = response.body;
    // 폰번호가 존재하면 true 리턴
    if ("\"" + phoneNumber + "\"" == result) {
      return new Future(() => true);
    }
    // 존재하지 않으면 false 리턴
    return new Future(() => false);
  }

// todo.7 닉네임 중복확인
  Future<bool> isNicknameDuplicated(String nickname) async {
    const String url = "http://studyplanet.kr/member/check/nick";
    String body = "nickname=$nickname";
    Map<String, String> header = {
      "Content-Type": "application/x-www-form-urlencoded"
    };
    var response = await http.post(url, body: body, headers: header);
    String result = response.body;
    print(result);
    // 닉네임 중복이면 true
    if ("\"" + nickname.toLowerCase() + "\"" == result.toLowerCase()) {
      return new Future(() => true);
    }
    // 중복이 아니면 false
    else {
      return new Future(() => false);
    }
  }

// todo.8 조건만족 시 회원가입 성공
  Future<String> register(String email, String pw, String phoneNumber,
      String nickname, String sex, String bornTime) async {
    const String url = "http://studyplanet.kr/member/register.do";
    String body =
    '''{"email":"$email","pw":"$pw","phoneNumber":"$phoneNumber","sex":"$sex","bornTime":"$bornTime","nickname":"$nickname"}''';

    Map<String, String> header = {"Content-Type": "application/json"};
    var response = await http.post(url, body: body, headers: header);
    String result = response.body;
    print("result: $result");
    // 회원가입 성공하면 100, 실패하면 101
    return new Future(() => result);
  }
}
