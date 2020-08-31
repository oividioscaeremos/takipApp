import 'dart:developer';

import 'package:dizi_takip/classes/Palette.dart';
import 'package:dizi_takip/classes/SizeConfig.dart';
import 'package:dizi_takip/classes/UiOverlayStyle.dart';
import 'package:dizi_takip/components/loginScreen/inputBox.dart';
import 'package:dizi_takip/i18n/strings.g.dart';
import 'package:dizi_takip/screens/RegisterScreen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String emailAddress;
  String username;
  String password;
  bool _usernameShowError = false;
  bool _showErrorForEmail = false;
  bool _passwordShowError = false;
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
        _usernameShowError = true;
      });
      return t.loginScreen.usernameNotValid;
    }
    return null;
  }

  String _validatePassword() {
    return null;
  }

  String _validateEmail(String str) {
    RegExp regExp = new RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    if (str.isEmpty) {
      _showErrorForEmail = true;
      return t.registerScreen.emailIsEmpty;
    }
    log(EmailValidator.validate(str.toLowerCase()).toString());
    if (!EmailValidator.validate(str.toLowerCase())) {
      setState(() {
        _showErrorForEmail = true;
      });
      return t.registerScreen.emailNotValid;
    } else {
      setState(() {
        _showErrorForEmail = false;
      });
      return null;
    }
  }

  void _onChangeEmail(String _str) {
    emailAddress = _str.toLowerCase();
  }

  void login() {}

  Future<void> _resetPassword(BuildContext ctx) {
    SizeConfig().init(ctx);

    return showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      barrierDismissible: false,
      context: ctx,
      transitionDuration: Duration(milliseconds: 500),
      pageBuilder: (context, animation1, animation2) {},
      transitionBuilder: (ctx, anim1, anim2, child) {
        final curvedValue = Curves.linearToEaseOut.transform(anim1.value) - 1;
        return Transform(
          transform: Matrix4.translationValues(0.0, curvedValue * 800, 0.0),
          child: GestureDetector(
            onTap: () {
              WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
            },
            child: Dialog(
              elevation: 0.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Container(
                height: SizeConfig.safeBlockVertical * 25,
                padding: EdgeInsets.all(
                  20.0,
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      child: Text(
                        t.loginScreen.popupPasswordHeader,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Positioned(
                      top: SizeConfig.safeBlockVertical * 5,
                      child: Material(
                        child: InputBox(
                          prefixIcon: Icons.email,
                          validate: _validateEmail,
                          showError: _showErrorForEmail,
                          onChanged: _onChangeEmail,
                          labelText: t.registerScreen.emailAddress,
                          id: "email",
                          bgColor: Palette().darkGrey.withOpacity(0.8),
                          inputType: TextInputType.emailAddress,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          RaisedButton(
                            color: Palette().darkGrey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(
                                color: Palette().grey,
                              ),
                            ),
                            child: Text(
                              t.loginScreen.sendMail.toUpperCase(),
                              style: TextStyle(
                                color: Palette().white,
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(ctx, rootNavigator: true)
                                  .pop('dialog');
                            },
                          ),
                          SizedBox(
                            width: SizeConfig.safeBlockHorizontal * 2,
                          ),
                          Text('-'),
                          SizedBox(
                            width: SizeConfig.safeBlockHorizontal * 2,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(ctx, rootNavigator: true)
                                  .pop('dialog');
                            },
                            child: Container(
                              child: Text(
                                t.global.close,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    /*
    * AlertDialog(
        backgroundColor: Palette().darkGrey,
        title: Text(
          t.loginScreen.popupPasswordHeader,
          style: TextStyle(
            color: Palette().white,
          ),
        ),
        content: InputBox(
          prefixIcon: Icons.email,
          validate: _validateEmail,
          showError: _showErrorForEmail,
          onChanged: _onChangeEmail,
          labelText: t.registerScreen.emailAddress,
          id: "email",
          bgColor: Palette().grey.withOpacity(0.5),
          inputType: TextInputType.emailAddress,
        ),
        actions: [
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                RaisedButton(
                  child: Text(t.global.close),
                  onPressed: () {
                    Navigator.of(ctx, rootNavigator: true).pop('dialog');
                  },
                ),
                RaisedButton(
                  child: Text(t.global.ok),
                  onPressed: () {
                    Navigator.of(ctx, rootNavigator: true).pop('dialog');
                  },
                ),
              ],
            ),
          )
        ],
      ),
    * */
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return MaterialApp(
      title: "DiziTakip",
      home: GestureDetector(
        onTap: () {
          WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Palette().grey,
          body: SafeArea(
            child: Container(
              height: SizeConfig.screenHeight,
              width: SizeConfig.screenWidth,
              child: Form(
                key: _formKey,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                        showError: _usernameShowError,
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
                        showError: _passwordShowError,
                        validate: _validatePassword,
                        prefixIcon: Icons.lock_outline,
                        focusNode: _B,
                        isObscure: true,
                      ),
                      SizedBox(
                        height: SizeConfig.safeBlockVertical * 3,
                      ),
                      Container(
                        width: SizeConfig.screenWidth,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: SizeConfig.screenWidth / 3 +
                                      SizeConfig.blockSizeHorizontal * 4,
                                  child: Text(''),
                                ),
                                Container(
                                  width: SizeConfig.screenWidth / 3 -
                                      SizeConfig.blockSizeHorizontal * 8,
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Palette().white,
                                          borderRadius:
                                              BorderRadius.circular(25),
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
                                    ],
                                  ),
                                ),
                                Container(
                                  width: SizeConfig.screenWidth / 3 +
                                      SizeConfig.blockSizeHorizontal * 4,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: SizeConfig.safeBlockVertical,
                                      ),
                                      Text(
                                        t.global.or,
                                        style: TextStyle(
                                          color:
                                              Palette().white.withOpacity(0.8),
                                        ),
                                      ),
                                      SizedBox(
                                        width: SizeConfig.safeBlockVertical,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context)
                                              .push(_createRoute());
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
                                ),
                              ],
                            ),
                            SizedBox(
                              height: SizeConfig.safeBlockVertical * 2,
                            ),
                            Center(
                              child: GestureDetector(
                                onTap: () => _resetPassword(context),
                                child: Text(
                                  t.loginScreen.forgotMyPassword,
                                  style: TextStyle(
                                    color: Palette().white.withOpacity(0.6),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
