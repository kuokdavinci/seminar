import 'dart:async';
import 'package:seminar/source/validators/validation.dart';

class RegisterBloc {
  final StreamController _nameController = StreamController();
  final StreamController _idController = StreamController();
  final StreamController _emailController = StreamController();
  final StreamController _passController = StreamController();
  final StreamController _repeatpassController = StreamController();

  Stream get nameStream => _nameController.stream;
  Stream get idStream => _idController.stream;
  Stream get emailStream => _emailController.stream;
  Stream get passStream => _passController.stream;
  Stream get repeatpassStream => _repeatpassController.stream;

  bool isValidRegister(
      String name, String id, String email, String pass, String repeatpass,bool isUserExist) {
    if (!Validations.isValidUser(name)) {
      _nameController.sink.addError('Name contains at least 4 characters');
      return false;
    }
    _nameController.sink.add('');
    if (!Validations.isValidID(id)) {
      _idController.sink.addError('Id is a 8-digits number');
      return false;
    }
    _idController.sink.add('');
    if (!Validations.isValidEmail(email)) {
      _emailController.sink.addError('Email is invalid');
      return false;
    }
    _emailController.sink.add('');
    if (!Validations.isVadidPass(pass)) {
      _passController.sink.addError('Password contains at least 8 characters');
      return false;
    }
    _passController.sink.add('');
    if (!Validations.isCorrectPass(pass, repeatpass)) {
      _repeatpassController.sink.addError('Repeat password do not macth');
      return false;
    }
    _passController.sink.add('');
    _repeatpassController.sink.add('');
    if(isUserExist)
    {
      _emailController.sink.addError('Email has been taken or invalid');
      return false;
    }
    _emailController.sink.add('');
    return true;
  }

  void dispose() {
    _nameController.close();
    _idController.close();
    _passController.close();
    _emailController.close();
    _repeatpassController.close();
  }
}
