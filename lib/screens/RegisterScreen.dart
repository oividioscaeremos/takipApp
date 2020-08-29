import 'dart:convert';
import 'dart:developer';

import 'package:dizi_takip/classes/ApiHandlers/InitNewShow.dart';
import 'package:dizi_takip/classes/ApiHandlers/QueryBuilder.dart';
import 'package:dizi_takip/classes/DatabaseClasses/Show.dart';
import 'package:dizi_takip/classes/Palette.dart';
import 'package:dizi_takip/classes/SizeConfig.dart';
import 'package:dizi_takip/components/loginScreen/inputBox.dart';
import 'package:dizi_takip/i18n/strings.g.dart';
import 'package:dizi_takip/screens/LoginScreen.dart';
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

    Firebase.initializeApp().whenComplete(() {
      setState(() {});
    });
  }

  bool validateEmail() {
    RegExp regExp = new RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    return regExp.hasMatch(emailAddress);
  }

  void onChangeUsername(String _str) {
    username = _str.toLowerCase();
  }

  void onChangeEmail(String _str) {
    print(_str);
    emailAddress = _str.toLowerCase();
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
        var curve = Curves.fastLinearToSlowEaseIn;

        var tween = Tween(begin: begin, end: end);
        var offsetAnimation = animation.drive(tween);
        var curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve
        );

        return SlideTransition(
          position: tween.animate(curvedAnimation),
          child: child,
        );
      },
    );
  }

  Future<void> register(BuildContext context) async {
    try {
      UserCredential user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailAddress,
          password: password
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(
              t.global.error,
            ),
            content: Text(
                t.registerScreen.weakPassword
            ),
            actions: [
              RaisedButton(
                child: Text(
                    t.global.ok
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        );
      } else if (e.code == 'email-already-in-use') {
        return showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(
              t.global.error,
            ),
            content: Text(
                t.registerScreen.emailInUse
            ),
            actions: [
              RaisedButton(
                child: Text(
                    t.global.ok
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        );
      }
    } catch (e) {
      return showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(
            t.global.error,
          ),
          content: Text(
              t.registerScreen.weakPassword
          ),
          actions: [
            RaisedButton(
              child: Text(
                  e.toString()
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    QueryBuilder qb = QueryBuilder(
        show: "1390",
        isExtended: true
    );

    print(qb.api_call.toString());
    return FutureBuilder(
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
    );

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
            print("just here");

            String apiString = "https://api.trakt.tv/shows/1390/seasons/1/episodes/1?extended=full";
            http.get(apiString,
              headers: {
                "trakt-api-key":"dc0c8f69daaf58412cc4cd72801837609ab166ad03b973ba132ea310741b08cc",
                "content-type":"application/json",
                "trakt-api-version":"2"
              }
            ).whenComplete(() => (resp){
              print("also here");
              /*ExtendedEpisode ep = ExtendedEpisode.fromJson(resp.body);
              print(ep.toJson());*/
            });

            print("after");
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
                      t.registerScreen.register.toUpperCase(),
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
