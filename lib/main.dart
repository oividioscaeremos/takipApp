import 'package:dizi_takip/classes/Palette.dart';
import 'package:dizi_takip/classes/SizeConfig.dart';
import 'package:dizi_takip/components/loginScreen//inputBox.dart';
import 'package:dizi_takip/i18n/strings.g.dart';
import 'package:dizi_takip/screens/LoginScreen.dart';
import 'package:dizi_takip/screens/RegisterScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: Palette().darkGrey,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarColor: Palette().darkGrey,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    LocaleSettings.useDeviceLocale().whenComplete((){
      if(LocaleSettings.currentLocale.contains("tr")){
        LocaleSettings.setLocale("tr");
      }else {
        LocaleSettings.setLocale("en");
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return MaterialApp(
      initialRoute: RegisterScreen.id,
      routes: {
        RegisterScreen.id: (context) => RegisterScreen(),
        LoginScreen.id: (context) => LoginScreen()
      },
    );
  }
}
