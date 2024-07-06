import 'package:seminar/source/blocs/register_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../fire_base/fire_base_auth.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  RegisterBloc bloc = RegisterBloc();
  bool _isUserExist = false;
  bool _showPass = false;
  bool _showRepeatPass =false;
  final FireAuth _firebaseAuth = FireAuth();

  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _repeatpassController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        backgroundColor: Colors.indigo,
      ),

      body: Container(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        color: Colors.indigo,
        child: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              width: 420,
              child: Card(
                margin: const EdgeInsets.symmetric(vertical: 30,horizontal: 20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 5.0, vertical: 35.0),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text(
                          'Sign Up',
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              color: Colors.black),
                        ),
                        const SizedBox(height: 25),
                        StreamBuilder(
                          stream: bloc.nameStream,
                          builder: (context, snapshot) =>
                              TextField(
                                controller: _userController,
                                decoration: InputDecoration(
                                  errorText: snapshot.hasError
                                      ? snapshot.error.toString()
                                      : null,
                                  label: const Text(
                                    'Name:',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic),
                                  ),
                                ),
                              ),
                        ),
                        const SizedBox(height: 15),
                        StreamBuilder(
                          stream: bloc.idStream,
                          builder: (context, snapshot) =>
                              TextField(
                                controller: _idController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  errorText: snapshot.hasError ? snapshot.error
                                      .toString() : null,
                                  label: const Text(
                                    'ID:',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic),
                                  ),
                                ),
                              ),
                        ),
                        const SizedBox(height: 15),
                        StreamBuilder(stream: bloc.emailStream,
                          builder: (context, snapshot) =>
                              TextField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  errorText: snapshot.hasError ? snapshot.error
                                      .toString() : null,
                                  label: const Text(
                                    'Email:',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic),
                                  ),
                                ),
                              ),),
                        const SizedBox(height: 15),
                        Stack(
                          alignment: AlignmentDirectional.centerEnd,
                          children: [
                            StreamBuilder(
                            stream: bloc.passStream, builder: (context, snapshot) =>
                              TextField(
                                controller: _passController,
                                decoration: InputDecoration(
                                  errorText: snapshot.hasError ? snapshot.error
                                      .toString() : null,
                                  label: const Text(
                                    'Password :',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic),
                                  ),
                                ),
                                obscureText: !_showPass
                              ),),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                    onTap: showPass,
                                    child: Text(
                                      !_showPass ? 'SHOW' : 'HIDE',
                                      style: const TextStyle(
                                          color: Colors.indigo,fontWeight: FontWeight.bold),
                                    )),
                                const SizedBox(
                                  width: 15,
                                ),
                              ],
                            )
                        ],
                        ),
                        const SizedBox(height: 15),
                        Stack(
                          alignment: AlignmentDirectional.centerEnd,
                          children: [
                            StreamBuilder(stream: bloc.repeatpassStream,
                              builder: (context, snapshot) =>
                                  TextField(
                                    controller: _repeatpassController,
                                    decoration: InputDecoration(
                                      errorText: snapshot.hasError ? snapshot.error
                                          .toString() : null,
                                      label: const Text(
                                        'Confirm password:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                      obscureText: !_showRepeatPass,
                                  ),),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                    onTap: showRepeatPass,
                                    child: Text(
                                      !_showRepeatPass ? 'SHOW' : 'HIDE',
                                      style: const TextStyle(
                                          color: Colors.indigo,fontWeight: FontWeight.bold),
                                    )),
                                const SizedBox(
                                  width: 15,
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _signUp,

                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Sign Up'),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  void showPass() {
    setState(() {
      _showPass = !_showPass;
    });
  }
  void showRepeatPass() {
    setState(() {
      _showRepeatPass = !_showRepeatPass;
    });
  }

  void showSuccessSignUp() {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          margin: EdgeInsets.only(bottom: 30,left: 30,right:30),
          content: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.white,
              ),
              SizedBox(width: 10),
              Text(
                "Sign up successfully!",
                style: TextStyle(color: Colors.white,fontSize: 17),
              )
            ],
          ),
          backgroundColor: Colors.lightGreen,
          shape: StadiumBorder(),
          behavior: SnackBarBehavior.floating,
        ));
    Future.delayed(Duration(seconds: 2), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });
  }
  void _signUp() async {
    if (!_isUserExist && bloc.isValidRegister(
        _userController.text,
        _idController.text,
        _emailController.text,
        _passController.text,
        _repeatpassController.text,
        _isUserExist)) {
      String username = _userController.text;
      String pass = _passController.text;
      String email = _emailController.text;
      String id = _idController.text;

      User? user = await _firebaseAuth.signUpWithEmailAndPassword(email, pass, username, id);

      if (user != null) {
        showSuccessSignUp();
      } else {
        _isUserExist = true;
        bloc.isValidRegister(
            _userController.text, _idController.text, _emailController.text,
            _passController.text, _repeatpassController.text, _isUserExist);
      }
    }
    _isUserExist = false;
  }

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
    _userController.dispose();
    _passController.dispose();
    _idController.dispose();
    _emailController.dispose();
    _repeatpassController.dispose();
  }
}
