import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plasma_donor/helper/constants.dart';
import 'package:plasma_donor/services/auth.dart';
import 'package:plasma_donor/views/homepage.dart';
import 'package:plasma_donor/views/register.dart';

import 'package:plasma_donor/widget/appBar.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

bool validateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  return (!regex.hasMatch(value)) ? false : true;
}

class _SignInState extends State<SignIn> {
  // final AuthService _authService = AuthService();
  final _formkey = GlobalKey<FormState>();
  String email = '';
  String password = '';

  bool _isLoading = false;
  AuthService authService = new AuthService();
  final FirebaseAuth appAuth = FirebaseAuth.instance;
  signIn() async {
    if (_formkey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });

      authService.signInEmailAndPass(email, password).then((value) {
        if (value != null) {
          setState(() {
            _isLoading = false;
          });
          Constants.saveUserLoggedInSharedPreference(true);

          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => HomePage()));

          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.white));
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: AppLogo(),
        brightness: Brightness.light,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        //brightness: Brightness.li,
      ),
      body: _isLoading
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : Form(
              key: _formkey,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Spacer(),
                    Container(
                      child: Column(
                        children: [
                          TextFormField(
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            enableSuggestions: false,
                            validator: (val) {
                              return validateEmail(val)
                                  ? null
                                  : "Enter correct email";
                            },
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(hintText: "Email"),
                            onChanged: (val) {
                              email = val;
                            },
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          TextFormField(
                            obscureText: true,
                            validator: (val) {
                              return val.isEmpty ? "Enter password" : null;
                            },
                            decoration: InputDecoration(hintText: "Password"),
                            onChanged: (val) {
                              password = val;
                            },
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          GestureDetector(
                            onTap: () {
                              signIn();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 20),
                              decoration: BoxDecoration(
                                  color: Colors.amberAccent[700],
                                  borderRadius: BorderRadius.circular(30)),
                              child: Text(
                                "Sign In",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
