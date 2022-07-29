
abstract class StringValidator {
  bool validForm(String value);
}

class ValidString implements StringValidator {
  @override
  bool validForm(String? value) {
    if (value == null) {
      return false;
    }
    return value.isNotEmpty;
  }
}

class EmailValidator {
  final StringValidator emailValidator = ValidString();
  final StringValidator passwordValidator = ValidString();
}