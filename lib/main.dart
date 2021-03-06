import 'dart:developer';

import 'package:dizi_takip/classes/Palette.dart';
import 'package:dizi_takip/classes/SizeConfig.dart';
import 'package:dizi_takip/classes/UiOverlayStyle.dart';
import 'package:dizi_takip/i18n/strings.g.dart';
import 'package:dizi_takip/screens/HomePage.dart';
import 'package:dizi_takip/screens/LoginScreen.dart';
import 'package:dizi_takip/screens/MyShowsPage.dart';
import 'package:dizi_takip/screens/RegisterScreen.dart';
import 'package:dizi_takip/screens/SearchPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(DiziTakipApp());

class DiziTakipApp extends StatefulWidget {
  @override
  _DiziTakipAppState createState() => _DiziTakipAppState();
}

class _DiziTakipAppState extends State<DiziTakipApp> {
  @override
  void initState() {
    super.initState();

    UiOverlayStyle()
        .UiOverlayStyleBoth(Palette().colorSecondary, Brightness.dark);

    LocaleSettings.setLocale(
        LocaleSettings.currentLocale == "tr" ? "tr" : "en");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: LoginScreen.id,
      routes: {
        RegisterScreen.id: (context) => RegisterScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        HomePage.id: (context) => HomePage(),
        MyShowsPage.id: (context) => MyShowsPage(),
        SearchPage.id: (context) => SearchPage()
      },
    );
  }
}
