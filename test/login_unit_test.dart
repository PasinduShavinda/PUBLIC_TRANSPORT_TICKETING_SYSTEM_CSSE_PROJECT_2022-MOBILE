import 'package:flutter_test/flutter_test.dart';
import 'package:login_reg_002/validator/login_page_validation.dart';

void main() {
  // Email Testing
  test('Empty Email Test', () {
    String result = LoginPageValidator.emailValidator('');
    expect(result, 'Please Enter Your Email');
  });

  test('Incorrect Email Test', () {
    String result = LoginPageValidator.emailValidator('test@gamilcom');
    expect(result, 'Please Enter a valid email');
  });

  test('Correct Email Test', () {
    String result = LoginPageValidator.emailValidator('test@gamil.com');
    expect(result, 'Valid Email');
  });



  // Password Testing
  test('Empty Password Test', () {
    String result = LoginPageValidator.passwordValidator('');
    expect(result, 'Password is required for login');
  });

  test('Incorrect Password Test', () {
    String result = LoginPageValidator.passwordValidator('ppww');
    expect(result, 'Enter Valid Password');
  });

  test('Correct Password Test', () {
    String result = LoginPageValidator.passwordValidator('testPW@123');
    expect(result, 'Valid Password');
  });
}
