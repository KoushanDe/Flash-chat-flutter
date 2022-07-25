import 'package:flash_chat/screens/chat_option.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';
import 'package:flash_chat/components/no_network.dart';
import 'package:flash_chat/components/errormessage.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  static const String id = '/login';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  bool _visible = false;
  bool _noInternet = false;
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              ErrorMessage(
                  visible: _visible,
                  text: _noInternet
                      ? 'No internet'
                      : 'Invalid ID or password, are you registered?'),
              TextField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  //Do something with the user input.
                  email = value;
                },
                style: TextStyle(color: Colors.grey[900]),
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'your_nickname@something.com'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                onChanged: (value) {
                  //Do something with the user input.
                  password = value;
                },
                style: TextStyle(color: Colors.grey[900]),
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your password'),
                obscureText: true,
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                color: Colors.lightBlueAccent,
                buttonTitle: 'Log In',
                onTap: () async {
                  _visible = false;
                  _noInternet = false;
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    if (email == null || password == null) {
                      setState(() {
                        _visible = true;
                        _noInternet = false;
                        showSpinner = false;
                        throw Exception;
                      });
                    }
                    final newUser = await _auth.signInWithEmailAndPassword(
                        email: email, password: password);

                    setState(() {
                      showSpinner = false;
                    });
                    if (newUser != null)
                      Navigator.pushNamed(context, ChatOption.id);
                  } on Exception catch (e) {
                    _visible = true;
                    if (await checkConnection() == 1) {
                      _noInternet = false;
                      setState(() {
                        showSpinner = false;
                      });
                    } else {
                      _noInternet = true;
                      setState(() {
                        showSpinner = false;
                      });
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
