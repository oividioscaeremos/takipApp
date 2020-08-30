import 'dart:developer';

import 'package:dizi_takip/classes/Palette.dart';
import 'package:dizi_takip/classes/SizeConfig.dart';
import 'package:dizi_takip/classes/UiOverlayStyle.dart';
import 'package:dizi_takip/components/loginScreen/inputBox.dart';
import 'package:dizi_takip/i18n/strings.g.dart';
import 'package:dizi_takip/screens/RegisterScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String username;
  String password;
  bool usernameShowError = false;
  Color _usernameColor = Palette().darkGrey;
  Color _pwdColor = Palette().darkGrey;

  FocusNode _A = new FocusNode();
  FocusNode _B = new FocusNode();

  static final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _A.addListener(_onFocusChange);
    _B.addListener(_onFocusChange);

    UiOverlayStyle(Palette().grey, Brightness.dark);
  }

  void _onFocusChange() {
    setState(() {
      if (_A.hasFocus) {
        _usernameColor = Palette().darkGrey.withOpacity(0.7);
        _pwdColor = Palette().darkGrey;
      } else if (_B.hasFocus) {
        _usernameColor = Palette().darkGrey;
        _pwdColor = Palette().darkGrey.withOpacity(0.7);
      } else {
        _usernameColor = Palette().darkGrey;
        _pwdColor = Palette().darkGrey;
      }
    });
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => RegisterScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.fastLinearToSlowEaseIn;

        var tween = Tween(begin: begin, end: end);
        var offsetAnimation = animation.drive(tween);
        var curvedAnimation = CurvedAnimation(parent: animation, curve: curve);

        return SlideTransition(
          position: tween.animate(curvedAnimation),
          child: child,
        );
      },
    );
  }

  void _usernameChanged(String str) {
    username = str.toLowerCase();
  }

  void _passwordChanged(String str) {
    password = str;
  }

  String _validateUsername() {
    RegExp regExp =
        new RegExp(r'^[a-zA-Z0-9]([._](?![._])|[a-zA-Z0-9]){6,18}[a-zA-Z0-9]');

    if (!regExp.hasMatch(username)) {
      setState(() {
        usernameShowError = true;
      });
      return t.loginScreen.usernameNotValid;
    }
    return null;
  }

  String _validatePassword() {
    return null;
  }

  void login() {}

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return MaterialApp(
      title: "DiziTakip",
      home: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Palette().grey,
          body: SafeArea(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      t.loginScreen.login.toUpperCase(),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Palette().white.withOpacity(0.8),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.safeBlockVertical * 5,
                    ),
                    InputBox(
                      bgColor: _usernameColor,
                      id: "username",
                      labelText: t.loginScreen.username,
                      onChanged: _usernameChanged,
                      onEnabledbgColor: Palette().darkGrey.withOpacity(0.9),
                      showError: usernameShowError,
                      validate: _validateUsername,
                      prefixIcon: Icons.account_circle,
                      focusNode: _A,
                    ),
                    SizedBox(
                      height: SizeConfig.safeBlockVertical * 2,
                    ),
                    InputBox(
                      bgColor: _pwdColor,
                      id: "password",
                      labelText: t.loginScreen.password,
                      onChanged: _passwordChanged,
                      onEnabledbgColor: Palette().darkGrey.withOpacity(0.9),
                      showError: usernameShowError,
                      validate: _validatePassword,
                      prefixIcon: Icons.lock_outline,
                      focusNode: _B,
                      isObscure: true,
                    ),
                    SizedBox(
                      height: SizeConfig.safeBlockVertical * 3,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Palette().white,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Text(
                              t.loginScreen.login,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.safeBlockVertical,
                        ),
                        Text(
                          t.global.or,
                          style: TextStyle(
                            color: Palette().white.withOpacity(0.8),
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.safeBlockVertical,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(_createRoute());
                          },
                          child: Container(
                            child: Text(
                              t.registerScreen.register,
                              style: TextStyle(
                                color: Palette().white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
