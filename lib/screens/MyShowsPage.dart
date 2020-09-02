import 'package:dizi_takip/classes/Palette.dart';
import 'package:dizi_takip/classes/UiOverlayStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyShowsPage extends StatefulWidget {
  @override
  _MyShowsPageState createState() => _MyShowsPageState();
}

class _MyShowsPageState extends State<MyShowsPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    UiOverlayStyle()
        .UiOverlayStyleOnlyBottom(Palette().colorPrimary, Brightness.light);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Palette().colorPrimary,
        body: Container(
          child: ListView(
            children: [
              Text(
                'MyShowsPage',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
