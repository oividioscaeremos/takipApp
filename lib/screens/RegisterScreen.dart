import 'package:dizi_takip/classes/Palette.dart';
import 'package:dizi_takip/classes/SizeConfig.dart';
import 'package:dizi_takip/components/loginScreen/inputBox.dart';
import 'package:dizi_takip/i18n/strings.g.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  static String id = 'register_screen';

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String emailAddress;
  String password;
  Color _usernameColor = Palette().grey;
  Color _pwdColor = Palette().grey;

  FocusNode _A = new FocusNode();
  FocusNode _B = new FocusNode();

  @override
  void initState() {
    super.initState();

    String localeStr =
    LocaleSettings.currentLocale.toLowerCase() == 'tr' ? 'tr' : 'en';
    LocaleSettings.setLocale(localeStr);

    _A.addListener(_onFocusChange);
    _B.addListener(_onFocusChange);
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
        _usernameColor = Palette().grey.withOpacity(0.7);
        _pwdColor = Palette().grey;
      } else if (_B.hasFocus) {
        _usernameColor = Palette().grey;
        _pwdColor = Palette().grey.withOpacity(0.7);
      } else {
        _usernameColor = Palette().grey;
        _pwdColor = Palette().grey;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return MaterialApp(
      title: 'Login Screen',
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
                  Text(t.loginScreen.welcome),
                  SizedBox(
                    height: SizeConfig.safeBlockVertical * 5,
                  ),
                  InputBox(
                    focusNode: _A,
                    labelText: t.loginScreen.username,
                    id: 'email',
                    validate: validateEmail,
                    onChanged: onChangeEmail,
                    bgColor: _usernameColor,
                    onEnabledbgColor: Palette().grey.withOpacity(0.9),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InputBox(
                    focusNode: _B,
                    labelText: t.loginScreen.password,
                    id: 'password',
                    validate: validateEmail,
                    onChanged: onChangeEmail,
                    bgColor: _pwdColor,
                    onEnabledbgColor: Palette().grey.withOpacity(0.9),
                  ),
                  SizedBox(
                    height: SizeConfig.safeBlockVertical * 5,
                  ),
                  Text(
                    t.loginScreen.login,
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
