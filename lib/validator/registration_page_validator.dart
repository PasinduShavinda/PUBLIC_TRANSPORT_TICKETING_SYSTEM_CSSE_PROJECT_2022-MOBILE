class RegPageValidator{

  // User Type Validation
  static String userTypeValidator(final String value){
    String message = '';
    RegExp regex = new RegExp(r'^[a-z_\-]+$');
    if (value!.isEmpty) {
      message = "User Type cannot be Empty";
    }
    else if (!regex.hasMatch(value)) {
      message = "Enter Valid user type !(User type must type in lowercase and only characters)";
    }
    else{
      message = "Valid User Type";
    }
    return message;
  }

  // First Name Validation
  static String fnameValidator(final String value){
    String message = '';
    RegExp regex = new RegExp(r'^[a-zA-Z]*$');
    if (value!.isEmpty) {
       message = "First Name cannot be Empty";
    }
    else if (!regex.hasMatch(value)) {
      message = "Enter Valid Name (Only characters allowed)";
    }
    else{
      message = "Valid first name";
    }
    return message;
  }

  // Second Name Validation
  static String snameValidator(final String value){
    String message = '';
    RegExp regex = new RegExp(r'^[a-zA-Z]*$');
    if (value!.isEmpty) {
      message = "Second Name cannot be Empty";
    }
    else if (!regex.hasMatch(value)) {
      message = "Enter Valid Name (Only characters allowed)";
    }
    else{
      message = "Valid second name";
    }
    return message;
  }

  // Email Validation
  static String emailValidator(final String value){
    String message = '';
    if (value!.isEmpty) {
      message =  "Please Enter Your Email";
    }
    // reg expression for email validation
    else if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
        .hasMatch(value)) {
      message =  "Please Enter a valid email";
    }
    else{
      message = "Valid Email";
    }
    return message;
  }

  // NIC Validation
  static String nicValidator(final String value){
    String message = '';
    RegExp regexNic = new RegExp(r'^([0-9]{9}[x|X|v|V]|[0-9]{12})$');
    if (value!.isEmpty) {
      message = "Please Enter Your NIC number";
    }
    // reg expression for NIC validation
    else if (!regexNic.hasMatch(value)) {
      message = "Please Enter a valid NIC number";
    }
    else{
      message = "Valid NIC";
    }
    return message;
  }
  // Password Validation
  static String passwordValidator(final String value){
    String message = '';
    RegExp regex = new RegExp(r'  ((?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[^A-Za-z0-9])(?=.{6,}))|((?=.*[a-z])(?=.*[A-Z])(?=.*[^A-Za-z0-9])(?=.{8,}))');
    if (value!.isEmpty) {
      return ("Password Cannot Be Empty");
    }
    else if (!regex.hasMatch(value)) {
      return ("Weak Password(Min. 6 Character & Min. 1 special character)");
    }
    else{
      message = "Valid Password";
    }
    return message;
  }

}