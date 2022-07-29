import 'package:flutter_test/flutter_test.dart';
import 'package:task_manager/services/validator.dart';

void main(){
  test('valid string', (){
    final validator = ValidString();
    expect(validator.validForm('test'), true);
  });

  test('empty string', (){
    final validator = ValidString();
    expect(validator.validForm(''), false);
  });

  test('null string', (){
    final validator = ValidString();
    expect(validator.validForm(null), false);
  });
}