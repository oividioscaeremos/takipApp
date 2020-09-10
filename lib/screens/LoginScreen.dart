import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dizi_takip/classes/ExceptionHandler.dart';
import 'package:dizi_takip/classes/Palette.dart';
import 'package:dizi_takip/classes/SizeConfig.dart';
import 'package:dizi_takip/classes/UiOverlayStyle.dart';
import 'package:dizi_takip/components/loginScreen/inputBox.dart';
import 'package:dizi_takip/i18n/strings.g.dart';
import 'package:dizi_takip/screens/HomePage.dart';
import 'package:dizi_takip/screens/RegisterScreen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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
  bool _showLoading = false;
  Color _usernameColor = Palette().colorPrimary;
  Color _pwdColor = Palette().colorPrimary;

  FocusNode _A = new FocusNode();
  FocusNode _B = new FocusNode();

  static final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      FirebaseAuth.instance.authStateChanges().listen((user) {
        if (user != null) {
          // user is already signed in
          return Navigator.popAndPushNamed(context, HomePage.id);
        }
      });
    });

    _A.addListener(_onFocusChange);
    _B.addListener(_onFocusChange);

    UiOverlayStyle()
        .UiOverlayStyleBoth(Palette().colorSecondary, Brightness.dark);
  }

  void _onFocusChange() {
    setState(() {
      if (_A.hasFocus) {
        _usernameColor = Palette().colorPrimary.withOpacity(0.7);
        _pwdColor = Palette().colorPrimary;
      } else if (_B.hasFocus) {
        _usernameColor = Palette().colorPrimary;
        _pwdColor = Palette().colorPrimary.withOpacity(0.7);
      } else {
        _usernameColor = Palette().colorPrimary;
        _pwdColor = Palette().colorPrimary;
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

  String _validateUsername(String str) {
    if (str.isEmpty) {
      setState(() {
        _usernameShowError = true;
      });
      return t.global.fieldCantBeEmpty;
    }

    setState(() {
      _usernameShowError = false;
    });
    return null;
  }

  String _validatePassword(String str) {
    if (str.isEmpty) {
      setState(() {
        _passwordShowError = true;
      });
      return t.global.fieldCantBeEmpty;
    } else {
      setState(() {
        _passwordShowError = false;
      });
    }
    return null;
  }

  String _validateEmail(String str) {
    RegExp regExp = new RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    if (str.isEmpty) {
      setState(() {
        _showErrorForEmail = true;
      });
      return t.global.fieldCantBeEmpty;
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

  Future<void> _login(BuildContext context) {
    log('we here');
    FormState formState = _formKey.currentState;

    if (formState.validate()) {
      Firebase.initializeApp();
      FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      try {
        firestore.collection('users').doc(username).get().then((userInf) {
          if (userInf.data() == null) {
            return ExceptionHandler(
                buttonText: t.global.ok,
                context: context,
                message: t.loginScreen.cantFindAnAccount);
          }
          log("val2");
          log(userInf.data().toString());

          firebaseAuth
              .signInWithEmailAndPassword(
                  email: userInf.get("email").toString(), password: password)
              .catchError((err) {
            ExceptionHandler(context: context, message: err.toString());
            firestore
                .collection('errors')
                .doc(new DateTime.now().toIso8601String())
                .set({
              "username": username,
              "date": new DateTime.now(),
              "message": (err as FirebaseAuthException).message.toString(),
            });
          }).then((val) {
            log("val");
            log(val.toString());
            return Navigator.pushNamed(context, HomePage.id);
          });
        });
      } catch (e) {
        ExceptionHandler(context: context, message: e.toString());
        firestore
            .collection('errors')
            .doc(new DateTime.now().toIso8601String())
            .set({
          "username": username,
          "date": new DateTime.now(),
          "message": e.toString(),
        });
      }
    }
    return null;
  }

  Future<void> _resetPassword(BuildContext ctx) {
    SizeConfig().init(ctx);
    Firebase.initializeApp();

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
                height: SizeConfig.safeBlockVertical * 30,
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
                          bgColor: Palette().colorPrimary.withOpacity(0.8),
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
                            color: Palette().colorPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(
                                color: Palette().colorSecondary,
                              ),
                            ),
                            child: Text(
                              t.loginScreen.sendMail.toUpperCase(),
                              style: TextStyle(
                                color: Palette().colorQuaternary,
                              ),
                            ),
                            onPressed: () {
                              FirebaseAuth firebaseAuth = FirebaseAuth.instance;
                              firebaseAuth
                                  .sendPasswordResetEmail(email: emailAddress)
                                  .catchError((Object e) {
                                if (e is FirebaseAuthException) {
                                  if (e.code == "user-not-found") {
                                    return ExceptionHandler(
                                        header: t.global.warning,
                                        buttonText: t.global.ok,
                                        context: context,
                                        message: t.loginScreen
                                            .emailSentIfThereIsACorrespondingUserForEmail);
                                  } else {
                                    return ExceptionHandler(
                                        context: context,
                                        message: e.toString());
                                  }
                                } else {
                                  return ExceptionHandler(
                                      context: context, message: e.toString());
                                }
                              }).then((v) {
                                Navigator.of(context, rootNavigator: true)
                                    .pop('dialog');
                              });
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
          resizeToAvoidBottomInset: true,
          backgroundColor: Palette().colorSecondary,
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
                          color: Palette().colorQuaternary.withOpacity(0.8),
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
                        onEnabledbgColor:
                            Palette().colorPrimary.withOpacity(0.9),
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
                        onEnabledbgColor:
                            Palette().colorPrimary.withOpacity(0.9),
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
                                      GestureDetector(
                                        onTap: () => _login(context),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Palette().colorQuaternary,
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
                                          color: Palette()
                                              .colorQuaternary
                                              .withOpacity(0.8),
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
                                              color: Palette().colorQuaternary,
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
                                    color: Palette()
                                        .colorQuaternary
                                        .withOpacity(0.6),
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
