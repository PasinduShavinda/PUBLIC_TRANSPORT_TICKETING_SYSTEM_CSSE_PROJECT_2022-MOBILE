class LoginPageValidator{

  // Email Validateion
  static String emailValidator(final String value){
    String message = '';
    RegExp regexEmail = new RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (value!.isEmpty) {
      message = "Please Enter Your Email";
    }
    else if (!regexEmail.hasMatch(value)) {
      message ="Please Enter a valid email";
    }
    else{
      message = "Valid Email";
    }
    return message;
  }

  // Password Validation
  static String passwordValidator(final String value){
    String message = '';
    RegExp regex = new RegExp(r'^.{6,}$');
    if (value!.isEmpty) {
      message = "Password is required for login";
    }
    else if (!regex.hasMatch(value)) {
      message = "Enter Valid Password";
    }
    else{
      message = "Valid Password";
    }
    return message;
  }
}