import 'package:flutter_test/flutter_test.dart';
import 'package:login_reg_002/validator/registration_page_validator.dart';

void main() {
  // User Type Testing
  test('Empty User Type Test', () {
    String result = RegPageValidator.userTypeValidator('');
    expect(result, 'User Type cannot be Empty');
  });

  test('Incorrect User Type Test', () {
    String result = RegPageValidator.userTypeValidator('PASSENGER');
    expect(result, 'Enter Valid user type !(User type must type in lowercase and only characters)');
  });

  test('Correct User Type Test', () {
    String result = RegPageValidator.userTypeValidator('conductor');
    expect(result, 'Valid User Type');
  });

  // First Name Testing
  test('Empty First Name Test', () {
    String result = RegPageValidator.fnameValidator('');
    expect(result, 'First Name cannot be Empty');
  });

  test('Incorrect First Name Test', () {
    String result = RegPageValidator.fnameValidator('Kamal23487');
    expect(result, 'Enter Valid Name (Only characters allowed)');
  });

  test('Correct First Name Test', () {
    String result = RegPageValidator.fnameValidator('Kamal');
    expect(result, 'Valid first name');
  });

  // Second Name Testing
  test('Empty Second Name Test', () {
    String result = RegPageValidator.snameValidator('');
    expect(result, 'Second Name cannot be Empty');
  });

  test('Incorrect Second Name Test', () {
    String result = RegPageValidator.snameValidator('Nimal22');
    expect(result, 'Enter Valid Name (Only characters allowed)');
  });

  test('Correct Second Name Test', () {
    String result = RegPageValidator.snameValidator('Nimal');
    expect(result, 'Valid second name');
  });

  // Email Testing
  test('Empty Email Test', () {
    String result = RegPageValidator.emailValidator('');
    expect(result, 'Please Enter Your Email');
  });

  test('Incorrect Email Test', () {
    String result = RegPageValidator.emailValidator('testReggamil.com');
    expect(result, 'Please Enter a valid email');
  });

  test('Correct Email Test', () {
    String result = RegPageValidator.emailValidator('testReg@gamil.com');
    expect(result, 'Valid Email');
  });

  // NIC Testing
  test('Empty NIC Test', () {
    String result = RegPageValidator.nicValidator('');
    expect(result, 'Please Enter Your NIC number');
  });

  test('Incorrect NIC Test', () {
    String result = RegPageValidator.nicValidator('283964982782375823748935');
    expect(result, 'Please Enter a valid NIC number');
  });

  test('Correct NIC Test', () {
    String result = RegPageValidator.nicValidator('200989876543');
    expect(result, 'Valid NIC');
  });

  // Password Testing
  test('Empty Password Test', () {
    String result = RegPageValidator.passwordValidator('');
    expect(result, 'Password Cannot Be Empty');
  });

  test('Incorrect Password Test', () {
    String result =  RegPageValidator.passwordValidator('342g');
    expect(result, 'Weak Password(Min. 6 Character & Min. 1 special character)');
  });

  test('Correct Password Test', () {
    String result =  RegPageValidator.passwordValidator('Pasindu@345A');
    expect(result, 'Valid Password');
  });

}
