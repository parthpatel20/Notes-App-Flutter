import 'package:notes/data/model/Constant.dart';

class Validatiors {
  validateEmail(String value) {
    RegExp regex = new RegExp(emailValidatorRegEX);
    return regex.hasMatch(value);
  }

  validateName(String val) {
    return val.trim().isEmpty;
  }

  validatePassword(String val) {
    if (val.trim().isNotEmpty && val.trim().length >= 6) {
      return true;
    }
    return false;
  }
}
