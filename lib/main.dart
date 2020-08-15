import 'package:dizi_takip/classes/Palette.dart';
import 'package:dizi_takip/classes/SizeConfig.dart';
import 'package:dizi_takip/components/loginScreen/inputBox.dart';
import 'package:dizi_takip/i18n/strings.g.dart';
import 'package:flutter/material.dart';

void main() => runApp(
      MaterialApp(
        home: LoginScreen(),
      ),
    );

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String emailAddress;
  String password;

  @override
  void initState() {
    super.initState();

    String localeStr =
        LocaleSettings.currentLocale.toLowerCase() == 'tr' ? 'tr' : 'en';
    LocaleSettings.setLocale(localeStr);
  }

  bool validateEmail() {
    return true;
  }

  void onChangeEmail(String _str) {
    print(_str);
    emailAddress = _str;
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
        body: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(t.loginScreen.welcome),
                  SizedBox(
                    height: SizeConfig.safeBlockVertical * 5,
                  ),
                  InputBox(
                    labelText: t.loginScreen.username,
                    id: 'email',
                    validate: validateEmail,
                    onChanged: onChangeEmail,
                    bgColor: Palette().grey,
                    onEnabledbgColor: Palette().grey.withOpacity(0.9),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InputBox(
                    labelText: t.loginScreen.password,
                    id: 'password',
                    validate: validateEmail,
                    onChanged: onChangeEmail,
                    bgColor: Palette().grey,
                    onEnabledbgColor: Palette().grey.withOpacity(0.5),
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
