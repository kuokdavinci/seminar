class Validations {
  static bool isValidUser (String user){
    return user.length >4;
  }
  static bool isVadidPass (String pass){
    return pass.length>7;
  }
  static bool isValidEmail(String email){
    return email.contains('@');
  }
  static bool isValidID(String id){
    return id.length==8;
  }
  static bool isCorrectPass(String pass,String repeatpass)
  {
    String a = pass;
    String b =repeatpass;
    if(a == b && pass.length== repeatpass.length) {
      return true;
    } else {
      return false;
    }
  }
  static bool isValidLogin (String email,String pass,bool onSuccess)
  {
    return (isValidEmail(email) && isVadidPass(pass)&& onSuccess);
  }

}