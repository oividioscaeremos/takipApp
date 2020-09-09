import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dizi_takip/classes/ApiHandlers/InitNewShow.dart';
import 'package:dizi_takip/classes/ApiHandlers/QueryBuilder.dart';
import 'package:dizi_takip/classes/DatabaseClasses/Show.dart';
import 'package:dizi_takip/classes/ExceptionHandler.dart';
import 'package:dizi_takip/classes/Palette.dart';
import 'package:dizi_takip/classes/SizeConfig.dart';
import 'package:dizi_takip/classes/UiOverlayStyle.dart';
import 'package:dizi_takip/components/loginScreen/inputBox.dart';
import 'package:dizi_takip/components/loginScreen/customButton.dart';
import 'package:dizi_takip/i18n/strings.g.dart';
import 'package:dizi_takip/screens/LoginScreen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  static String id = 'register_screen';

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String username;
  String emailAddress;
  String password;
  Color _emailColor = Palette().colorSecondary;
  Color _usernameColor = Palette().colorSecondary;
  Color _pwdColor = Palette().colorSecondary;
  bool _showErrorForEmail = false;
  bool _showErrorForUsername = false;
  bool _showErrorForPassword = false;

  FocusNode _A = new FocusNode();
  FocusNode _B = new FocusNode();
  FocusNode _C = new FocusNode();

  static final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _A.addListener(_onFocusChange);
    _B.addListener(_onFocusChange);
    _C.addListener(_onFocusChange);

    Firebase.initializeApp().whenComplete(() {
      setState(() {});
    });

    UiOverlayStyle()
        .UiOverlayStyleBoth(Palette().colorPrimary, Brightness.light);
  }

  String _validateEmail(String str) {
    RegExp regExp = new RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    if (str.isEmpty) {
      _showErrorForEmail = true;
      return t.registerScreen.emailIsEmpty;
    }
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

  String _validateUsername(String str) {
    RegExp regExp =
        new RegExp(r'^[a-zA-Z0-9]([._](?![._])|[a-zA-Z0-9]){6,18}[a-zA-Z0-9]');

    if (!regExp.hasMatch(username)) {
      return t.loginScreen.usernameNotValid;
    }

    return null;
  }

  String _validatePassword(str) {
    return null;
  }

  void _onChangeEmail(String _str) {
    emailAddress = _str.toLowerCase();
  }

  void _onChangeUsername(String _str) {
    username = _str.toLowerCase();
  }

  void _onChangePassword(String _str) {
    password = _str;
  }

  void _onFocusChange() {
    setState(() {
      if (_A.hasFocus) {
        _emailColor = Palette().colorSecondary.withOpacity(0.7);
        _usernameColor = Palette().colorSecondary;
        _pwdColor = Palette().colorSecondary;
      } else if (_B.hasFocus) {
        _usernameColor = Palette().colorSecondary.withOpacity(0.7);
        _pwdColor = Palette().colorSecondary;
        _emailColor = Palette().colorSecondary;
      } else if (_C.hasFocus) {
        _pwdColor = Palette().colorSecondary.withOpacity(0.7);
        _usernameColor = Palette().colorSecondary;
        _emailColor = Palette().colorSecondary;
      } else {
        _usernameColor = Palette().colorSecondary;
        _pwdColor = Palette().colorSecondary;
        _emailColor = Palette().colorSecondary;
      }
    });
  }

  void _register(BuildContext context) async {
    final form = _formKey.currentState;
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    if (form.validate()) {
      try {
        UserCredential user =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailAddress,
          password: password,
        );
        user.user.updateProfile(displayName: username);
        firestore.collection('users').doc(username).set({
          "username": username,
          "email": emailAddress,
          "totalWatchTimeInMinutes": 0,
          "watchNext": {},
          "favoriteGenres": [],
          "myOldShows": {},
          "myShows": {},
        });

        Navigator.of(context).pop();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ExceptionHandler(
              context: context, message: t.registerScreen.weakPassword);
        } else if (e.code == 'email-already-in-use') {
          ExceptionHandler(
              context: context, message: t.registerScreen.emailInUse);
        } else if (e.code == 'username-in-use') {
          ExceptionHandler(
              context: context, message: t.registerScreen.usernameInUse);
        }
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
  }

  Future<bool> _onBackPressed(BuildContext context) {
    UiOverlayStyle()
        .UiOverlayStyleBoth(Palette().colorSecondary, Brightness.dark);

    return Navigator.popAndPushNamed(context, RegisterScreen.id);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    /*return FutureBuilder(
      future: InitNewShow(showTraktID: "1407").initShow(),
      builder: (BuildContext context, AsyncSnapshot<Show> snapshot){
        if(snapshot.hasData){
          /*ShowService show = ShowService.fromJson(jsonDecode(snapshot.data));
          print(show.title.toString());
          CollectionReference shows = FirebaseFirestore.instance.collection('shows');
          shows.doc(show.ids.imdb.toString()).set(show.toJson());*/
          //shows.add(show.toJson());
          List<int> bytes = jsonEncode(snapshot.data).toString().codeUnits;

          return SafeArea(child: Text(bytes.length.toString()));
        }
        return CircularProgressIndicator();
      }
    );*/

    return WillPopScope(
      onWillPop: () => _onBackPressed(context),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Palette().colorPrimary,
        body: GestureDetector(
          onTap: () {
            WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
          },
          child: Form(
            key: _formKey,
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: Palette().colorPrimary,
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      t.registerScreen.register,
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
                      focusNode: _A,
                      labelText: t.registerScreen.emailAddress,
                      id: 'email',
                      validate: _validateEmail,
                      onChanged: _onChangeEmail,
                      bgColor: _emailColor,
                      onEnabledbgColor:
                          Palette().colorSecondary.withOpacity(0.9),
                      prefixIcon: Icons.alternate_email,
                      showError: _showErrorForEmail,
                      inputType: TextInputType.emailAddress,
                    ),
                    SizedBox(
                      height: SizeConfig.safeBlockVertical * 2,
                    ),
                    InputBox(
                      focusNode: _B,
                      labelText: t.registerScreen.username,
                      id: 'username',
                      validate: _validateUsername,
                      onChanged: _onChangeUsername,
                      bgColor: _usernameColor,
                      onEnabledbgColor:
                          Palette().colorSecondary.withOpacity(0.9),
                      prefixIcon: Icons.person,
                      showError: _showErrorForUsername,
                    ),
                    SizedBox(
                      height: SizeConfig.safeBlockVertical * 2,
                    ),
                    InputBox(
                      focusNode: _C,
                      labelText: t.registerScreen.password,
                      id: 'password',
                      validate: _validatePassword,
                      onChanged: _onChangePassword,
                      bgColor: _pwdColor,
                      onEnabledbgColor:
                          Palette().colorSecondary.withOpacity(0.9),
                      prefixIcon: Icons.lock_open,
                      showError: _showErrorForPassword,
                      isObscure: true,
                    ),
                    SizedBox(
                      height: SizeConfig.safeBlockVertical * 3,
                    ),
                    CustomButton(
                      text: t.registerScreen.register,
                      buttonColor: Palette().colorQuaternary,
                      onPressed: () {
                        _register(context);
                      },
                    )
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
