class ValidatePassword {
  bool is8Characters;
  bool isContainLetter;
  bool isContainNum;
  bool isNotContainSpace;

  ValidatePassword(
      {this.is8Characters = false,
        this.isContainLetter = false,
        this.isNotContainSpace = false,
        this.isContainNum = false});
  bool getIsCorrected() => (is8Characters && isContainLetter && isContainNum && isNotContainSpace);

  ValidatePassword checkPassword(String value) {
    var correctWordParameter = new ValidatePassword();
    final validNumbers = RegExp(r'(\d+)');
    final validLetter = RegExp(r'[a-zA-Z]*$');

    if (value.isEmpty) {
      return ValidatePassword();
    }

    //8자 이상인지 확인
    if(value.length >= 8 && value.length <= 16) {
      correctWordParameter.is8Characters = true;
    }
    else {
      correctWordParameter.is8Characters = false;
    }

    //문자가 있는지 확인
    if(validLetter.hasMatch(value)) {
      correctWordParameter.isContainLetter = true;
    }
    else {
      correctWordParameter.isContainLetter = false;
    }

    if(validNumbers.hasMatch(value)) {
      correctWordParameter.isContainNum = true;
    }
    else {
      correctWordParameter.isContainNum = false;
    }

    if (value.contains(" ")) {
      correctWordParameter.isNotContainSpace = false;
    }
    else {
      correctWordParameter.isNotContainSpace = true;
    }
    print("공백포함: ${correctWordParameter.isNotContainSpace}");
    return correctWordParameter;
  }
}



