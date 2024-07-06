import 'dart:async';
import 'package:seminar/source/validators/validation.dart';

class LoginBloc {
  final StreamController _emailController = StreamController();
  final StreamController _passController = StreamController();

  Stream get emailStream => _emailController.stream;

  Stream get passStream => _passController.stream;

  bool isValidInfo(String user, String pass) {
    if (!Validations.isValidUser(user)) {
      _emailController.sink.addError("Email is invalid");
      return false;
    }
    _emailController.sink.add('');
    if (!Validations.isVadidPass(pass)) {
      _passController.sink.addError("Password is invalid");
      return false;
    }
    _passController.sink.add('');
    return true;
  }

  bool isValidLogin(String user, String pass,bool onSuccess) {
    if (!Validations.isValidLogin(user, pass, onSuccess)) {
      _emailController.sink.addError('Email or Password is incorrect');
      _passController.sink.addError('Email or Password is incorrect');
      return false;
    }
    _emailController.sink.add('');
    _emailController.sink.add('');
    return true;
  }

  void dispose() {
    _emailController.close();
    _passController.close();
  }
}
