import 'package:dizi_takip/classes/Palette.dart';
import 'package:dizi_takip/classes/UiOverlayStyle.dart';
import 'package:dizi_takip/screens/RegisterScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    UiOverlayStyle(Palette().grey, Brightness.dark);
  }

  Future<bool> _onBackPressed(BuildContext context){
    UiOverlayStyle(Palette().darkGrey, Brightness.light);

    return Navigator.popAndPushNamed(context, RegisterScreen.id);
  }

  @override
  Widget build(BuildContext context) {


    return WillPopScope(
      onWillPop: () => _onBackPressed(context),
      child: Scaffold(
        backgroundColor: Palette().grey,
        body: SafeArea(
          child: Container(
            child: Text("LoginSCREEN Babe :)"),
          ),
        ),
      ),
    );
  }
}
