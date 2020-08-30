import 'dart:developer';

import 'package:dizi_takip/classes/Palette.dart';
import 'package:dizi_takip/classes/SizeConfig.dart';
import 'package:dizi_takip/classes/UiOverlayStyle.dart';
import 'package:dizi_takip/i18n/strings.g.dart';
import 'package:dizi_takip/screens/LoginScreen.dart';
import 'package:dizi_takip/screens/RegisterScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(
      MaterialApp(
        home: DiziTakipApp(),
      ),
    );

class DiziTakipApp extends StatefulWidget {
  @override
  _DiziTakipAppState createState() => _DiziTakipAppState();
}

class _DiziTakipAppState extends State<DiziTakipApp> {
  @override
  void initState() {
    super.initState();

    UiOverlayStyle(Palette().grey, Brightness.dark);

    LocaleSettings.setLocale(
        LocaleSettings.currentLocale == "tr" ? "tr" : "en");
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return MaterialApp(
      initialRoute: LoginScreen.id,
      routes: {
        RegisterScreen.id: (context) => RegisterScreen(),
        LoginScreen.id: (context) => LoginScreen()
      },
    );
  }
}
