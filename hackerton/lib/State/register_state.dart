import 'package:flutter/material.dart';

class RegisterState extends ChangeNotifier {
  String _email;
  String _password;
  String _phoneNumber;
  String _sex;
  String _birthday;

  void setPhoneNumber(String phoneNumber) => this._phoneNumber = phoneNumber;
  void setSex(String sex) => this._sex = sex;
  void setBirthday(String birthday) => this._birthday = birthday;
  void setEmail(String email) => this._email = email;
  void setPassword(String password) => this._password = password;

  String getEmail() => this._email;
  String getPassword() => this._password;
  String getPhoneNumber() => this._phoneNumber;
  String getSex() => this._sex;
  String getBirthday() => this._birthday;

}