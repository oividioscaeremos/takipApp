import 'package:dizi_takip/classes/Palette.dart';
import 'package:dizi_takip/classes/SizeConfig.dart';
import 'package:dizi_takip/components/loginScreen/inputBox.dart';
import 'package:dizi_takip/i18n/strings.g.dart';
import 'package:dizi_takip/screens/LoginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  static String id = 'register_screen';

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String emailAddress;
  String password;
  Color _emailColor = Palette().grey;
  Color _usernameColor = Palette().grey;
  Color _pwdColor = Palette().grey;

  FocusNode _A = new FocusNode();
  FocusNode _B = new FocusNode();
  FocusNode _C = new FocusNode();

  @override
  void initState() {
    super.initState();

    _A.addListener(_onFocusChange);
    _B.addListener(_onFocusChange);
    _C.addListener(_onFocusChange);
  }

  bool validateEmail() {
    RegExp regExp = new RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    return regExp.hasMatch(emailAddress);
  }

  void onChangeEmail(String _str) {
    print(_str);
    emailAddress = _str;
  }

  void _onFocusChange() {
    setState(() {
      if (_A.hasFocus) {
        _emailColor = Palette().grey.withOpacity(0.7);
        _usernameColor = Palette().grey;
        _pwdColor = Palette().grey;
      } else if (_B.hasFocus) {
        _usernameColor = Palette().grey.withOpacity(0.7);
        _pwdColor = Palette().grey;
        _emailColor = Palette().grey;
      } else if(_C.hasFocus){
        _pwdColor = Palette().grey.withOpacity(0.7);
        _usernameColor = Palette().grey;
        _emailColor = Palette().grey;
      }else{
        _usernameColor = Palette().grey;
        _pwdColor = Palette().grey;
        _emailColor = Palette().grey;
      }
    });
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => LoginScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.decelerate;

        var tween = Tween(begin: begin, end: end);
        var offsetAnimation = animation.drive(tween);
        var curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );

        return SlideTransition(
          position: tween.animate(curvedAnimation),
          child: child,
        );
      },
    );
  }

  Future<void> register() async {
    try {
      UserCredential user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailAddress,
          password: password
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return MaterialApp(
      title: t.registerScreen.title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Palette().darkGrey,
        body: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: Palette().darkGrey,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(t.registerScreen.register),
                  SizedBox(
                    height: SizeConfig.safeBlockVertical * 5,
                  ),
                  InputBox(
                    focusNode: _A,
                    labelText: t.registerScreen.emailAddress,
                    id: 'email',
                    validate: validateEmail,
                    onChanged: onChangeEmail,
                    bgColor: _emailColor,
                    onEnabledbgColor: Palette().grey.withOpacity(0.9),
                    prefixIcon: Icons.alternate_email,
                  ),
                  SizedBox(
                    height: SizeConfig.safeBlockVertical * 2,
                  ),
                  InputBox(
                    focusNode: _B,
                    labelText: t.registerScreen.username,
                    id: 'username',
                    validate: validateEmail,
                    onChanged: onChangeEmail,
                    bgColor: _usernameColor,
                    onEnabledbgColor: Palette().grey.withOpacity(0.9),
                    prefixIcon: Icons.person,
                  ),
                  SizedBox(
                    height: SizeConfig.safeBlockVertical * 2,
                  ),
                  InputBox(
                    focusNode: _C,
                    labelText: t.registerScreen.password,
                    id: 'password',
                    validate: validateEmail,
                    onChanged: onChangeEmail,
                    bgColor: _pwdColor,
                    onEnabledbgColor: Palette().grey.withOpacity(0.9),
                    prefixIcon: Icons.lock_open,
                  ),
                  SizedBox(
                    height: SizeConfig.safeBlockVertical * 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(_createRoute());
                    },
                    child: Text(
                      t.registerScreen.register,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
